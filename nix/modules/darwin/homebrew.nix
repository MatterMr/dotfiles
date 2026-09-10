{ inputs, pkgs, ... }:
{
  homebrew = {
    enable = true;
    casks = [
      "microsoft-teams"
      "windows-app"
      "karabiner-elements"
      "linearmouse"
      "zoom"
      "steam"
      "skim"
      "claude"
      "docker-desktop"
      "mullvad-vpn@beta"
      "wireshark-app"
    ];
    brews = [ ];
    masApps = { };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
