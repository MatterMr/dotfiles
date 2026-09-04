{ inputs, pkgs, ... }:
{

  imports = [
    ../shared
    ./yabai.nix
    ./skhd.nix
  ];

  home.username = "mattermr";
  home.homeDirectory = "/Users/mattermr";
  home.stateVersion = "25.11";
}
