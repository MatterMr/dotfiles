{ inputs, ... }:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    user = "mattermr";
  };

  homebrew = {
    enable = true;
    taps = [ ];
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
      "wireshark-app"
    ];
    brews = [ ];
    masApps = { };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
