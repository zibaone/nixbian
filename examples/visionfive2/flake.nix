{
  description = "NixOS SD image for StarFive VisionFive 2 (RISC-V)";

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
        nixosConfigurations.visionfive2 = nixpkgs.lib.nixosSystem {
          # Use pkgsCross.riscv64 to explicitly trigger RISC-V cross-compilation
          pkgs = nixpkgs.legacyPackages.x86_64-linux.pkgsCross.riscv64;

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
                  board = "visionfive2";
                  kernelVendor = "vendor";
                };

                # Basic NixOS config
                networking.hostName = "nixbian-visionfive2";
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
