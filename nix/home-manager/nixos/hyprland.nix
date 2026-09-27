{
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.walker.homeManagerModules.default ];
  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nix/config/hypr/hyprland.lua";

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    PROTON_ENABLE_WAYLAND = "1";
    PROTON_USE_NTSYNC = "1";
    PROTON_FSR4_UPGRADE = "1";
    ENABLE_LAYER_MESA_ANTI_LAG = "1";
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  services.hyprlauncher = {
    enable = true;
    settings = {
      cache = {
        enabled = true;
      };
      finders = {
        desktop_icons = true;
        desktop_launch_prefix = "uwsm app --";
        math_prefix = "=";
      };
      general = {
        grab_focus = true;
      };
      ui = {
        window_size = "400 260";
      };
    };
  };

  services.dunst.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
  };
  services.hyprpolkitagent.enable = true;

  services.cliphist.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
  };

}
