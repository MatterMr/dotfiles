{ inputs, pkgs, ... }:
{

  imports = [
    ../shared
    ./yabai.nix
    ./skhd.nix
    ./karabiner.nix
    ./alfred.nix
  ];

  home.username = "mattermr";
  home.homeDirectory = "/Users/mattermr";
}
