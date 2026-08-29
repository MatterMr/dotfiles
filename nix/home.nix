{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/kitty.nix
    ./modules/nvim.nix
    # ./modules/tools.nix
    ./modules/hyprland.nix
  ];

  home.username = "mattermr";
  home.homeDirectory = "/home/mattermr";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    firefox
    git
    protonup-rs
    mangohud
  ];

  services.cliphist.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      "vim" = "nvim";
    };
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    loginShellInit = ''
         if status is-login
           if test -z "$WAYLAND_DISPLAY"; and test "$XDG_VTNR" = 1
             if uwsm check may-start
        exec uwsm start hyprland.desktop
      end
           end
         end
    '';
  };
  programs.git = {
    enable = true;
    settings.user = {
      name = "MatterMr";
      email = "greymatter432@icloud.com";
    };
  };

  programs.vesktop.enable = true;

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    toggle_hud=Shift_R+F12
    no_display

    fps
    fps_metrics=avg
    frametime
    gpu_stats
    cpu_stats
    ram
    vram
    fsr
    display_server
  '';
}
