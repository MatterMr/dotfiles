{
  config,
  ...
}:
{
  xdg.configFile."yabai/yabairc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nix/config/yabai/yabairc";
  };
}
