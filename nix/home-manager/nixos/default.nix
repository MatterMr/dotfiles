{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../shared
    ./mangohud.nix
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
    nautilus
    btop
    inputs.resproxy.packages.${pkgs.stdenv.hostPlatform.system}.default
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
  programs.obsidian.enable = true;
  programs.mullvad-vpn.enable = true;

}
