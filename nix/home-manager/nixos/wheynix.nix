{ ... }:
{
  imports = [
    ../shared/nvim.nix
    ../shared/devtools.nix
    ../shared/git.nix
  ];
  home.username = "mattermr";
  home.homeDirectory = "/home/mattermr";
  home.stateVersion = "26.11";
}
