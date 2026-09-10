{
  pkgs,
  config,
  ...
}:
{
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nix/config/nvim";

  home.shellAliases = {
    "vim" = "nvim";
  };
  home.packages = with pkgs; [
    neovim

    # pdf viewer
    # zathura
    # zathuraPkgs.zathura_pdf_poppler

    # Lazy Dependencies
    git
    lazygit
    ripgrep
    fzf
    fd
    luaPackages.tree-sitter-cli
    gcc
    wget
    unzip
    imagemagick
    python3
    rustc
    cargo
    nodejs

    # LSP
    lua-language-server
    nil
    rust-analyzer
    ocamlPackages.ocaml-lsp

    # Formatter
    stylua
    nixfmt
    ocamlformat

  ];

}
