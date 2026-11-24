# Moonlight streaming host (Sunshine) on a virtual Hyprland display.
{ pkgs, config, ... }:
let
  # VirtualHere USB client: attaches the Steam Controller puck plugged into
  # greymac as a real USB device (USB/IP), so Steam sees the actual controller.
  # The download URL is unversioned: a new upstream release changes the hash
  # and the build fails until it is updated here.
  virtualhere-client = pkgs.runCommand "virtualhere-client-6.0.3" {
    src = pkgs.fetchurl {
      url = "https://www.virtualhere.com/sites/default/files/usbclient/vhclientx86_64";
      sha256 = "d66d41a12e1137ce3adec1f851987a2bfb3cc62ca96a280646abcd6d9c4ec554";
    };
  } "install -Dm755 $src $out/bin/vhclientx86_64";
  vh = "${virtualhere-client}/bin/vhclientx86_64";
  greymacVirtualHere = "192.168.1.81:7575";

  stream-ctl = pkgs.writeShellApplication {
    name = "stream-ctl";
    runtimeInputs = [
      config.programs.hyprland.package
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.gnused
      virtualhere-client
    ];
    text = ''
      export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
      # Over SSH there is no Hyprland environment, so use the newest instance.
      if [ -z "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
        # shellcheck disable=SC2012
        HYPRLAND_INSTANCE_SIGNATURE="$(ls -t "$XDG_RUNTIME_DIR/hypr" | head -n1)"
        export HYPRLAND_INSTANCE_SIGNATURE
      fi

      active() { hyprctl monitors | grep -q "^Monitor $1 "; }
      dp3_off() { hyprctl eval 'hl.monitor({output = "DP-3", disabled = true})'; }
      dp3_on() {
        hyprctl eval 'hl.monitor({output = "DP-3", disabled = false, mode = "prefered", position = "0x0", scale = 2, bitdepth = 8, vrr = 2})'
      }
      wait_for() {
        for _ in $(seq 20); do
          if active "$1"; then return 0; fi
          sleep 0.25
        done
        return 1
      }
      # Address of the puck on greymac's VirtualHere server, if it is listed.
      puck() {
        timeout 10 vhclientx86_64 -t LIST 2>/dev/null \
          | sed -n 's/.*Steam Controller Puck (\([^)]*\)).*/\1/p' | head -n1
      }

      case "''${1:-status}" in
        on)
          w="''${SUNSHINE_CLIENT_WIDTH:-3024}"
          h="''${SUNSHINE_CLIENT_HEIGHT:-1964}"
          fps="''${SUNSHINE_CLIENT_FPS:-60}"
          scale=1
          if [ "$h" -ge 1600 ]; then scale=2; fi
          hyprctl eval "hl.monitor({output = \"STREAM\", mode = \"''${w}x''${h}@''${fps}\", position = \"2560x0\", scale = $scale})"
          if ! active STREAM; then hyprctl output create headless STREAM; fi
          wait_for STREAM
          # DP-3 off: STREAM becomes the only display, so Sunshine's
          # output_name = 0 is STREAM and everything opens there.
          dp3_off
          sleep 1
          # Borrow the controller puck from greymac. Not fatal: without it,
          # Moonlight's own gamepad input still works.
          p="$(puck || true)"
          if [ -n "$p" ]; then
            timeout 20 vhclientx86_64 -t "USE,$p" || echo "puck attach failed" >&2
          fi
          ;;
        off)
          # Give the puck back to greymac.
          p="$(puck || true)"
          if [ -n "$p" ]; then
            timeout 20 vhclientx86_64 -t "STOP USING,$p" || true
          fi
          dp3_on
          if ! wait_for DP-3; then
            hyprctl reload
            wait_for DP-3 || true
          fi
          # Never remove the last working display.
          if active DP-3 && active STREAM; then hyprctl output remove STREAM; fi
          ;;
        status)
          hyprctl monitors | grep -A1 "^Monitor"
          timeout 10 vhclientx86_64 -t LIST 2>/dev/null | grep -A3 "Hub" || echo "VirtualHere client not running"
          ;;
        *)
          echo "usage: stream-ctl [status|on|off]" >&2
          exit 2
          ;;
      esac
    '';
  };
  ctl = "${stream-ctl}/bin/stream-ctl";
in
{
  environment.systemPackages = [ stream-ctl ];

  services.sunshine = {
    enable = true;
    settings = {
      sunshine_name = "greynix";
      capture = "wlr";
      encoder = "vaapi";
      output_name = 0;
      upnp = "disabled";
      origin_web_ui_allowed = "pc";
      global_prep_cmd = builtins.toJSON [
        {
          do = "${ctl} on";
          undo = "${ctl} off";
        }
      ];
    };
    applications.apps = [
      { name = "Desktop"; }
      {
        name = "Steam Big Picture";
        detached = [ "/run/current-system/sw/bin/steam steam://open/bigpicture" ];
      }
    ];
  };
  systemd.user.services.sunshine = {
    environment.LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
    # Bring DP-3 back even if Sunshine crashes.
    serviceConfig.ExecStopPost = "-${ctl} off";
  };
  services.avahi.enable = false;

  # VirtualHere client (runs as root; its control pipe /tmp/vhclient is
  # world-writable, which is how stream-ctl attaches the puck).
  boot.kernelModules = [ "vhci_hcd" ];
  systemd.services.virtualhere-client = {
    description = "VirtualHere USB client (Steam Controller puck from greymac)";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${vh} -e -c /var/lib/virtualhere/config.ini";
      ExecStartPost = "${pkgs.bash}/bin/sh -c 'sleep 2; ${vh} -t \"MANUAL HUB ADD,${greymacVirtualHere}\"'";
      StateDirectory = "virtualhere";
      Restart = "on-failure";
    };
  };

  # Home network only. Tailscale traffic arrives through wheynix, so it
  # also comes from this subnet. Port 47990 (admin page) stays closed.
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -s 192.168.1.0/24 -p tcp -m multiport --dports 22,47984,47989,48010 -j nixos-fw-accept
    iptables -A nixos-fw -s 192.168.1.0/24 -p udp -m multiport --dports 47998,47999,48000,48002,48010 -j nixos-fw-accept
  '';
  # SSH settings live in hosts/nixos/greynix/configuration.nix; here it is
  # only kept off the open firewall (the LAN rule above lets port 22 in).
  services.openssh.openFirewall = false;

  # Remote power-on
  networking.interfaces.enp16s0.wakeOnLan.enable = true;
  services.getty.autologinUser = "mattermr";
}
