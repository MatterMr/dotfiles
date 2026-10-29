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
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    protonup-rs
    mangohud
    nautilus
    btop
    r2modman
    google-chrome
    osu-lazer-bin
    inputs.resproxy.packages.${pkgs.stdenv.hostPlatform.system}.default

    # screenshot support
    grim
    slurp
    swappy

    # Clipboard
    wl-clipboard
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
  programs.claude-code.enable = true;

}
