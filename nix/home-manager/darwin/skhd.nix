{
  pkgs,
  lib,
  config,
  ...
}:
{
  xdg.configFile."skhd/skhdrc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nix/config/skhd/skhdrc";
  };
}
