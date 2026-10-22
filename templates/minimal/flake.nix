{
  description = "A minimal NixOS configuration using Nixbian";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixbian.url = "github:zibaone/nixbian";
    nixbian.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixbian,
      ...
    }:
    {
      nixosConfigurations.my-sbc = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux"; # Adjust this to your target SBC architecture (e.g., aarch64-linux or riscv64-linux)
        modules = [
          nixbian.nixosModules.nixbian
          ./configuration.nix
        ];
      };
    };
}
