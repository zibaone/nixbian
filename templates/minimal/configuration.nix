{ config, pkgs, ... }:
{
  # Configure your board and kernel via the Nixbian Hardware Module
  hardware.nixbian = {
    enable = true;
    board = "orangepizero3"; # Replace with your board name (e.g., orangepizero3, visionfive2, etc.)
    kernelVendor = "edge"; # Choose series: current, edge, or vendor
  };

  # Minimal bootloader settings
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Basic network and hostname configuration
  networking.hostName = "nixbian-sbc";

  # Configure your system environment (packages, services, users...)
  services.openssh.enable = true;
  users.users.root.initialPassword = "nix";

  system.stateVersion = "24.11";
}
