{
  config,
  ...
}:
{
  xdg.configFile."karabiner/karabiner.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nix/config/karabiner/karabiner.json";
  };
}
