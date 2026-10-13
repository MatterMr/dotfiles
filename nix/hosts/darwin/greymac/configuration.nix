{ pkgs, inputs, ... }:
{
  users.users.mattermr = {
    home = "/Users/mattermr";
    shell = pkgs.fish;
  };

  # Base Config
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";
  launchd.daemons.nix-daemon.serviceConfig.RunAtLoad = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  nixpkgs.config.allowUnfree = true;
  programs.fish.enable = true;
  nix.package = pkgs.nix;
  nix.settings.trusted-users = [ "@admin" ];

  # System Settings
  system.primaryUser = "mattermr";
  system.stateVersion = 6;
  system.defaults = {
    dock = {
      autohide = true;
      persistent-apps = [
        "/Users/mattermr/Applications/Home Manager Apps/kitty.app"
        "/Users/mattermr/Applications/Home Manager Apps/Firefox.app"
        "/Applications/Nix Apps/Obsidian.app"
        "/System/Applications/Mail.app"
      ];
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Clsv";
      FXRemoveOldTrashItems = true;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    screencapture = {
      location = "~/Downloads";
      type = "png";
      disable-shadow = true;
      show-thumbnail = false;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      "com.apple.swipescrolldirection" = true;
      "com.apple.sound.beep.volume" = 0.0;
      "com.apple.sound.beep.feedback" = 0;
    };
    WindowManager = {
      StandardHideWidgets = true; # hide desktop widgets (Stage Manager off)
      StageManagerHideWidgets = true; # hide desktop widgets (Stage Manager on)
    };
    # Change Spotlight to Alt-Space
    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # 64 = Show Spotlight search
          "64" = {
            enabled = false;
          };
        };
      };
    };
    loginwindow.GuestEnabled = false;
    spaces.spans-displays = false;
    ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
    controlcenter.BatteryShowPercentage = true;
  };

  # Base Packages
  environment.systemPackages = with pkgs; [
    nerd-fonts.hack
    vesktop
    obsidian
  ];

  # # Custom Obsidian Sync Script
  # launchd.agents.my-script = {
  #   serviceConfig = {
  #     ProgramArguments = [ "/bin/bash" "-c" "~/Developer/scripts/obsidian-sync.sh" ];
  #     StartInterval = 300;
  #     RunAtLoad = true;
  #     StandardOutPath = "/var/log/obsidian-sync.log";
  #     StandardErrorPath = "/var/log/obsidian-sync.err";
  #   };
  # };
  nixpkgs.overlays = [
    (final: prev: {
      yabai = prev.yabai.overrideAttrs (old: {
        version = "NightWatcher314-7.1.31";
        doInstallCheck = false;
        src = final.fetchFromGitHub {
          owner = "NightWatcher314";
          repo = "yabai";
          rev = "8afe28084dda66c50c30f0abc3279ce1b723ca63";
          hash = "sha256-62TB/S1OFWjIkrKOkpF35POb5mUkoC7lF6QW6nY2eIY=";
        };
      });
    })

  ];

  # Window manager config
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    package = pkgs.yabai;
  };

  services.skhd.enable = true;
  services.jankyborders = {
    enable = true;
    hidpi = true;
    active_color = "0xFFFFFFFF";
    inactive_color = "0x00FFFFFF";
  };
}
