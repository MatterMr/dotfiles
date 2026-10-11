{ inputs, pkgs, ... }:
{

  imports = [
    ../shared
    ./yabai.nix
    ./skhd.nix
  ];

  home.username = "mattermr";
  home.homeDirectory = "/Users/mattermr";
}
