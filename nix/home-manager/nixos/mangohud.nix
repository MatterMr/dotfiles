{
  config,
  ...
}:
{
  xdg.configFile."MangoHud/MangoHud.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nix/config/MangoHud/MangoHud.conf";
  };
}
