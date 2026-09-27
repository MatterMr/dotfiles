{
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Add cachix cache for hyprland to prevent rebuilding
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    # Required so non-root users are allowed to use the above substituter/keys.
    # Use @wheel for all sudo users, or list your username explicitly.
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
  # add lact
  services.lact.enable = true;

  # Enable amdgpu overclocking
  hardware.amdgpu.overdrive.enable = true;

  # Custom graphics settings to match hyprland mesa version
  hardware.graphics = {
    package = pkgs-unstable.mesa;
    package32 = pkgs-unstable.pkgsi686Linux.mesa;
    enable32Bit = true;
  };
  # Enable the hyprland Module
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = true;

  };
}
