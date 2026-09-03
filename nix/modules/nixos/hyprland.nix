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
  # environment.sessionVariables = {
  #   HYPR_PLUGIN_DIR = hypr-plugin-dir;
  # };
  environment.systemPackages = with pkgs; [
    nwg-displays
  ];
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
