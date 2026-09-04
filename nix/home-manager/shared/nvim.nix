{
  pkgs,
  lib,
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
    # Lazy Dependencies
    git
    lazygit
    ripgrep
    fzf
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
    # Formatter
    stylua
    nixfmt

  ];

}
