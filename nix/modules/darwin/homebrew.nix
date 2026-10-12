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
      "karabiner-elements"
      "linearmouse"
      "zoom"
      "steam"
      "skim"
      "claude"
      "docker-desktop"
      "wireshark-app"
      "mullvad-vpn"
      "crossover"
      "alfred"
    ];
    brews = [ ];
    masApps = { };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.extraFlags = [ "--verbose" ];
  };
}
