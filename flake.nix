{
  description = "Nixbian - Armbian metadata and kernel management for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      systems,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      # Global library functions
      flake.lib = import ./nix/lib.nix { inherit (nixpkgs) lib; };

      # NixOS Module bridge
      flake.nixosModules = {
        nixbian = import ./nix/parts/nixos-module.nix self;
        default = self.nixosModules.nixbian;
      };

      # Starter templates for new users
      flake.templates = {
        minimal = {
          path = ./templates/minimal;
          description = "A minimal NixOS configuration utilizing Nixbian's hardware modules";
        };
        default = self.templates.minimal;
      };

      imports = [
        ./nix/parts/packages.nix
        ./nix/parts/apps.nix
        ./nix/parts/devshell.nix
        ./nix/parts/checks.nix
      ];
    };
}
