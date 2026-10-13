{
  config,
  ...
}:
{
  home.file."Library/Application Support/Alfred/Alfred.alfredpreferences".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nix/config/alfred/Alfred.alfredpreferences";
}
