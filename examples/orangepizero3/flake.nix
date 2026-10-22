{
  description = "NixOS SD image for Orange Pi Zero 3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixbian.url = "path:../../";
    nixbian.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixbian,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      flake = {
        nixosConfigurations.orangepizero3 = nixpkgs.lib.nixosSystem {
          # Use pkgsCross to explicitly trigger cross-compilation
          pkgs = nixpkgs.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform;

          modules = [
            (
              {
                pkgs,
                lib,
                config,
                ...
              }:
              {
                imports = [
                  ./sd-image.nix
                  nixbian.nixosModules.nixbian
                ];

                # Configure board and kernel series via the Nixbian Hardware Module
                hardware.nixbian = {
                  enable = true;
                  board = "orangepizero3";
                  kernelVendor = "edge";
                };

                # Basic NixOS config
                networking.hostName = "nixbian-opizero3";
                system.stateVersion = "24.11";

                # Enable SSH and set a default password for the example
                services.openssh = {
                  enable = true;
                  settings.PermitRootLogin = "yes";
                };
                users.users.root.initialPassword = "nix";
              }
            )
          ];
        };
      };
    };
}
