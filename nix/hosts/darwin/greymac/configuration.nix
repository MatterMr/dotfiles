{ pkgs, inputs, ... }:
{
  users.users.mattermr = {
    home = "/Users/mattermr";
    shell = pkgs.fish; # good place to set this too since you're switching
  };

  # Base Config
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";
  launchd.daemons.nix-daemon.serviceConfig.RunAtLoad = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 6;
  programs.fish.enable = true;
  nix.package = pkgs.nix;
  nix.settings.trusted-users = [ "@admin" ];
  # System Settings
  system.primaryUser = "mattermr";
  system.defaults = {
    dock.autohide = true;
    dock.persistent-apps = [
      "/Users/mattermr/Applications/Home Manager Apps/kitty.app"
      "/Applications/Nix Apps/Firefox.app"
      "/Applications/Nix Apps/Obsidian.app"
      "/System/Applications/Mail.app"
    ];
    finder.FXPreferredViewStyle = "clmv";
    finder.AppleShowAllFiles = true;
    loginwindow.GuestEnabled = false;
    spaces.spans-displays = false;
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
    };
  };

  # Base Packages
  environment.systemPackages = with pkgs; [
    nerd-fonts.hack
    firefox
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
        version = "AhsanFazal-ad0a12d";
        doInstallCheck = false;
        src = final.fetchFromGitHub {
          owner = "AhsanFazal";
          repo = "yabai";
          rev = "ad0a12d63f639534a296a1d065b0d04979f1b4db";
          hash = "sha256-CFC9KuBw7oyOjL5t8D+JIdk6/cdSh91J/K/8XA3v3aE=";
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
