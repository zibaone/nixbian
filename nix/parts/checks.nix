{
  self,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      # Evaluate a NixOS configuration and force the kernel patch list and the
      # U-Boot package. `system.build.toplevel` is NOT evaluated: the NixOS
      # assertions on the Armbian kernel config (options =y) are not the
      # subject of this check and would require a real build. The goal is to
      # prove that the module evaluates for the board, without any build.
      mkNixosCheck =
        {
          name,
          system ? "aarch64-linux",
          board,
          kernelVendor,
          expectedUboot,
          extraModules ? [ ],
        }:
        let
          evaluated = self.inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              self.nixosModules.default
              {
                hardware.nixbian.enable = true;
                hardware.nixbian.board = board;
                hardware.nixbian.kernelVendor = kernelVendor;
                fileSystems."/" = {
                  device = "/dev/sda1";
                  fsType = "ext4";
                };
                boot.loader.grub.enable = false;
              }
            ]
            ++ extraModules;
          };
          ubootPkg = evaluated.config.hardware.nixbian.uBoot.package;
          ubootOk = if expectedUboot == "null" then ubootPkg == null else ubootPkg != null;
          ubootState = if ubootPkg == null then "null" else "package";
          # Evaluating the patch list forces the module wiring without
          # building (or deriving) the kernel.
          patchCount = builtins.length evaluated.config.boot.kernelPackages.kernel.kernelPatches;
        in
        pkgs.runCommand "check-nixos-${name}" { } ''
          test "${if ubootOk then "1" else "0"}" = "1"
          echo "${system} ${ubootState} ${toString patchCount}" > $out
        '';

      metadata = self.packages.${pkgs.system}.metadata;
    in
    {
      checks = {
        # The metadata artifact must stay copyable (relative paths, no
        # reference to the store of the build machine).
        inherit metadata;

        # Fail if generated metadata leaks a store path or a home directory.
        # Upstream patches are excluded: they are vendored verbatim and may
        # legitimately contain such strings.
        metadata-clean =
          pkgs.runCommand "check-metadata-clean"
            {
              nativeBuildInputs = [ pkgs.gnugrep ];
            }
            ''
              set -eu
              matches="$(grep -RInE '/nix/store/[0-9a-z]{32}-|/home/[a-z]+(/|$)' ${metadata} --exclude-dir=patches || true)"
              if [ -n "$matches" ]; then
                echo "non-portable paths in metadata:" >&2
                echo "$matches" >&2
                exit 1
              fi
              touch $out
            '';

        # Every generated JSON file must parse, so a broken generator run
        # cannot silently ship invalid metadata.
        metadata-json =
          pkgs.runCommand "check-metadata-json"
            {
              nativeBuildInputs = [ pkgs.jq ];
            }
            ''
              find ${metadata} -name '*.json' -exec jq empty {} +
              touch $out
            '';

        # Build the CLI package as part of the flake gate. The NixOS checks
        # above only evaluate configurations; this catches packaging errors.
        cli = self.packages.${pkgs.system}.default;

        # One representative board per major family, plus the no-U-Boot case.
        # This covers sunxi64 (H616), sunxi 32-bit, bcm2711 (Raspberry Pi),
        # meson64 (Amlogic) and rockchip64.
        nixos-orangepizero3-edge = mkNixosCheck {
          name = "orangepizero3-edge";
          board = "orangepizero3";
          kernelVendor = "edge";
          expectedUboot = "package";
        };
        nixos-orangepizero-current = mkNixosCheck {
          name = "orangepizero-current";
          system = "armv7l-linux";
          board = "orangepizero";
          kernelVendor = "current";
          expectedUboot = "package";
        };
        nixos-rpi4b-current = mkNixosCheck {
          name = "rpi4b-current";
          board = "rpi4b";
          kernelVendor = "current";
          expectedUboot = "package";
        };
        nixos-aml-a311d-cc-current = mkNixosCheck {
          name = "aml-a311d-cc-current";
          board = "aml-a311d-cc";
          kernelVendor = "current";
          expectedUboot = "package";
        };
        nixos-orangepi5-current = mkNixosCheck {
          name = "orangepi5-current";
          board = "orangepi5";
          kernelVendor = "current";
          expectedUboot = "package";
        };
        nixos-no-uboot = mkNixosCheck {
          name = "no-uboot";
          board = "phytiumpi";
          kernelVendor = "current";
          expectedUboot = "null";
          extraModules = [
            { hardware.nixbian.uBoot.useUpstream = true; }
          ];
        };
      };
    };
}
