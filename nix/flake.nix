{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
      ...
    }:
    {
      nixosConfigurations = {
        greynix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
                boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
              }
            )
            ./configuration.nix
            ./hyprland.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.mattermr = ./home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
      };
    };
}
