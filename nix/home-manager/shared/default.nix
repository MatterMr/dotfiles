{ ... }:
{
  imports = [
    ./git.nix
    ./kitty.nix
    ./nvim.nix
    ./latex.nix
    ./devtools.nix
    ./firefox.nix
  ];
  home.stateVersion = "26.11";
}
