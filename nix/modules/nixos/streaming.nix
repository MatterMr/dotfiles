# Moonlight streaming host (Sunshine) on a virtual Hyprland display.
{ pkgs, config, ... }:
let
  stream-ctl = pkgs.writeShellApplication {
    name = "stream-ctl";
    runtimeInputs = [
      config.programs.hyprland.package
      pkgs.coreutils
      pkgs.gnugrep
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
          ;;
        off)
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
          ;;
        *)
          echo "usage: stream-ctl [status|on|off]" >&2
          exit 2
          ;;
      esac
    '';
  };
  ctl = "${stream-ctl}/bin/stream-ctl";

  stream-login = pkgs.writeShellApplication {
    name = "stream-login";
    runtimeInputs = [
      pkgs.systemd
      pkgs.gnugrep
    ];
    text = ''
      # Starting the service takes over tty1, so never do it over a live session.
      if loginctl list-sessions --no-legend | grep -qw seat0; then
        echo "already logged in"
        exit 0
      fi
      sudo systemctl start stream-login.service
      echo "logging in; give Hyprland and Sunshine a few seconds"
    '';
  };
in
{
  environment.systemPackages = [
    stream-ctl
    stream-login
  ];

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

  # No auto-login at boot. Running `stream-login` over SSH (key + sudo password)
  # starts the tty1 session.
  systemd.services.stream-login = {
    description = "Log mattermr in on tty1 for streaming";
    conflicts = [ "getty@tty1.service" ];
    after = [ "getty@tty1.service" ];
    # A rebuild must not kill the running session.
    restartIfChanged = false;
    serviceConfig = {
      ExecStart = "${pkgs.util-linux}/bin/agetty --autologin mattermr --login-program ${config.services.getty.loginProgram} --noclear --keep-baud tty1 115200,38400,9600 linux";
      # Back to the password prompt when the session ends.
      ExecStopPost = "${pkgs.systemd}/bin/systemctl --no-block start getty@tty1.service";
      StandardInput = "tty";
      StandardOutput = "tty";
      TTYPath = "/dev/tty1";
      TTYReset = true;
      TTYVHangup = true;
      UtmpIdentifier = "tty1";
      KillMode = "process";
      SendSIGHUP = true;
      IgnoreSIGPIPE = false;
      Restart = "no";
    };
  };
}
