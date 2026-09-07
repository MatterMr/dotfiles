{ pkgs, ... }:
{
  home.packages = with pkgs; [
    texlab # LaTeX language server
    texliveFull # full TeX Live (= scheme-full); includes latexmk and all packages
  ];
}
