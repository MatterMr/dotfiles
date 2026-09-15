{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../shared
    ./hyprland.nix
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
    gamescope
    gamemode
  ];

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

  programs.vesktop.enable = true;

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
            		toggle_hud=Shift_R+F12
            		font_scale=2
            		fps
            		fps_metrics=avg
            		fps_metrics=avg,0.01
            		frametime
            		gpu_stats
            		gpu_temp
            		cpu_stats
            		cpu_temp
            		ram
            		vram
            		fsr
            		display_server
            		present_mode
    						fps_limit=120
        				fps_limit_method=early
  '';
}
