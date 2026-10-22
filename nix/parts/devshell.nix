{ self, ... }:
{
  perSystem =
    { pkgs, self', ... }:
    let
      lib = pkgs.lib;
      # Load data for the current repo to know all platforms and boards
      data = self.lib.loadMetadata pkgs (self + "/metadata");

      # Generate devShells for each board
      boardDevShells = lib.listToAttrs (
        lib.concatMap (
          boardKey:
          let
            # 1. Kernel devShell
            kernelPkg = self'.packages."kernel-${boardKey}" or null;
            boardInfo = data.boardsIndex.${boardKey} or { };
            family = boardInfo.family or null;
            branch = boardInfo.branch or "current";
            familyData = data.families.${family} or { };
            platformInfo = familyData.platforms."${family}-${branch}" or { };
            kMeta = platformInfo.kernel or { };
            configPathNix = kMeta.config_path_nix or null;

            kernelDevShell =
              if kernelPkg != null then
                let
                  patchedSource = pkgs.stdenv.mkDerivation {
                    name = "${kernelPkg.name}-patched-source";
                    src = kernelPkg.src;
                    nativeBuildInputs = kernelPkg.nativeBuildInputs or [ ];
                    patches = builtins.map (p: p.patch) (kernelPkg.kernelPatches or [ ]);
                    phases = [
                      "unpackPhase"
                      "patchPhase"
                      "installPhase"
                    ];
                    installPhase = ''
                      mkdir -p $out
                      cp -R . $out/
                    '';
                  };
                in
                pkgs.mkShell {
                  name = "kernel-dev-${boardKey}";

                  # Expose the cross-compiler and host build tools
                  packages = [
                    kernelPkg.stdenv.cc
                    pkgs.gnumake
                    pkgs.bison
                    pkgs.flex
                    pkgs.openssl.dev
                    pkgs.ncurses.dev
                    pkgs.bc
                    pkgs.elfutils
                    pkgs.pkg-config
                    pkgs.qemu
                    pkgs.gdb
                    pkgs.dtc
                  ];

                  # Environment variables for cross-compilation
                  ARCH = kernelPkg.stdenv.targetPlatform.linuxArch or "arm64";
                  CROSS_COMPILE = kernelPkg.stdenv.cc.targetPrefix or "";

                  shellHook = ''
                    echo "❄️ Nixbian Kernel Dev Shell for ${boardKey}"
                    echo "Target Architecture: $ARCH"
                    echo "Cross Compiler Prefix: $CROSS_COMPILE"
                    echo ""
                    echo "Commands:"
                    echo "  unpack-kernel  - Extract and patch kernel source to ./kernel-src/"
                    echo "  init-config    - Copy default kernel configuration to ./kernel-src/.config"
                    echo "  menuconfig     - Run kernel menuconfig on ./kernel-src/"
                    ${
                      if configPathNix != null then
                        ''
                          echo "  save-config    - Copy ./kernel-src/.config into the repository (family config)"
                        ''
                      else
                        ""
                    }echo "  run-qemu       - Run compiled kernel in QEMU virtual machine"
                    echo "  run-qemu --gdb - Run kernel in QEMU, freezing CPU at startup for GDB"
                    echo ""

                    unpack-kernel() {
                      echo "Copying fully-patched kernel source to ./kernel-src..."
                      rm -rf ./kernel-src
                      mkdir -p ./kernel-src
                      cp -R --no-preserve=mode,ownership ${patchedSource}/* ./kernel-src/
                      chmod -R u+w ./kernel-src/
                      echo "Done!"
                    }

                    init-config() {
                      if [ ! -d ./kernel-src ]; then
                        echo "Error: Run unpack-kernel first!"
                        return 1
                      fi
                      echo "Copying default kernel config to ./kernel-src/.config..."
                      cp ${kernelPkg.configfile} ./kernel-src/.config
                      chmod u+w ./kernel-src/.config
                      echo "Done!"
                    }

                    menuconfig() {
                      if [ ! -f ./kernel-src/.config ]; then
                        echo "Error: Run init-config first!"
                        return 1
                      fi
                      (
                        cd ./kernel-src
                        make menuconfig
                      )
                    }

                    run-qemu() {
                      # Map Nix stdenv targetPlatform linuxArch names to standard Linux build/QEMU names
                      L_ARCH="$ARCH"
                      if [ "$L_ARCH" = "arm" ]; then
                        L_ARCH="arm"
                      fi

                      KERNEL_IMG=""
                      if [ "$L_ARCH" = "arm64" ]; then
                        KERNEL_IMG="./kernel-src/arch/arm64/boot/Image"
                      elif [ "$L_ARCH" = "arm" ]; then
                        if [ -f "./kernel-src/arch/arm/boot/zImage" ]; then
                          KERNEL_IMG="./kernel-src/arch/arm/boot/zImage"
                        else
                          KERNEL_IMG="./kernel-src/arch/arm/boot/Image"
                        fi
                      elif [ "$L_ARCH" = "riscv" ]; then
                        KERNEL_IMG="./kernel-src/arch/riscv/boot/Image"
                      fi

                      if [ ! -f "$KERNEL_IMG" ]; then
                        echo "Error: Kernel image not found at $KERNEL_IMG"
                        echo "Please compile the kernel first inside ./kernel-src/"
                        return 1
                      fi

                      GDB_OPTS=""
                      if [ "$1" = "--gdb" ]; then
                        GDB_OPTS="-s -S"
                        echo "🔌 GDB port active on tcp::1234. Freezing CPU at startup. Connect with gdb!"
                      fi

                      echo "Starting QEMU emulation for $L_ARCH..."
                      echo "Press Ctrl-A then X to exit QEMU."
                      echo ""

                      if [ "$L_ARCH" = "arm64" ]; then
                        qemu-system-aarch64 \
                          -M virt \
                          -cpu cortex-a53 \
                          -smp 2 \
                          -m 1024 \
                          -kernel "$KERNEL_IMG" \
                          -append "console=ttyAMA0 earlycon=pl011,0x09000000 loglevel=8" \
                          -nographic \
                          $GDB_OPTS
                      elif [ "$L_ARCH" = "arm" ]; then
                        qemu-system-arm \
                          -M virt \
                          -cpu cortex-a15 \
                          -smp 2 \
                          -m 1024 \
                          -kernel "$KERNEL_IMG" \
                          -append "console=ttyAMA0 earlycon=pl011,0x09000000 loglevel=8" \
                          -nographic \
                          $GDB_OPTS
                      elif [ "$L_ARCH" = "riscv" ]; then
                        qemu-system-riscv64 \
                          -M virt \
                          -smp 2 \
                          -m 1024 \
                          -kernel "$KERNEL_IMG" \
                          -append "console=ttyS0 earlycon=sbi loglevel=8" \
                          -nographic \
                          $GDB_OPTS
                      else
                        echo "Emulation not supported for $L_ARCH yet."
                      fi
                    }
                    ${
                      if configPathNix != null then
                        ''

                          save-config() {
                            if [ ! -f ./kernel-src/.config ]; then
                              echo "Error: ./kernel-src/.config not found!"
                              return 1
                            fi
                            
                            # Find repository root
                            REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
                            CONFIG_REL_PATH="metadata/nix/families/${family}/${configPathNix}"
                            CONFIG_ABS_PATH="$REPO_ROOT/$CONFIG_REL_PATH"
                            
                            echo "Copying ./kernel-src/.config to $CONFIG_REL_PATH (verbatim)..."
                            cp ./kernel-src/.config "$CONFIG_ABS_PATH"
                            chmod 0644 "$CONFIG_ABS_PATH"
                          }
                        ''
                      else
                        ""
                    }
                  '';
                }
              else
                null;

            # 2. U-Boot devShell
            ubootPkg = self'.packages."uboot-${boardKey}" or null;
            ubootDevShell =
              if ubootPkg != null then
                let
                  patchedSource = pkgs.stdenv.mkDerivation {
                    name = "${ubootPkg.name}-patched-source";
                    src = ubootPkg.src;
                    patches = ubootPkg.extraPatches or [ ];
                    phases = [
                      "unpackPhase"
                      "patchPhase"
                      "installPhase"
                    ];
                    installPhase = ''
                      mkdir -p $out
                      cp -R . $out/
                    '';
                  };
                in
                pkgs.mkShell {
                  name = "uboot-dev-${boardKey}";

                  packages = [
                    ubootPkg.stdenv.cc
                    pkgs.gnumake
                    pkgs.bison
                    pkgs.flex
                    pkgs.openssl.dev
                    pkgs.ncurses.dev
                    pkgs.bc
                    pkgs.pkg-config
                  ];

                  ARCH = ubootPkg.stdenv.targetPlatform.linuxArch or "arm64";
                  CROSS_COMPILE = ubootPkg.stdenv.cc.targetPrefix or "";
                  BL31 = if ubootPkg ? BL31 && ubootPkg.BL31 != null then ubootPkg.BL31 else "";

                  shellHook = ''
                    echo "❄️ Nixbian U-Boot Dev Shell for ${boardKey}"
                    echo "Target Architecture: $ARCH"
                    echo "Cross Compiler Prefix: $CROSS_COMPILE"
                    if [ -n "$BL31" ]; then
                      echo "ARM Trusted Firmware (BL31): $BL31"
                    fi
                    echo ""
                    echo "Commands:"
                    echo "  unpack-uboot   - Extract and patch U-Boot source to ./uboot-src/"
                    echo "  init-config    - Configure U-Boot with defconfig (${
                      if ubootPkg.defconfig != null then ubootPkg.defconfig else "none"
                    })"
                    echo ""

                    unpack-uboot() {
                      echo "Copying fully-patched U-Boot source to ./uboot-src..."
                      rm -rf ./uboot-src
                      mkdir -p ./uboot-src
                      cp -R --no-preserve=mode,ownership ${patchedSource}/* ./uboot-src/
                      chmod -R u+w ./uboot-src/
                      echo "Done!"
                    }

                    init-config() {
                      if [ ! -d ./uboot-src ]; then
                        echo "Error: Run unpack-uboot first!"
                        return 1
                      fi
                      echo "Configuring U-Boot in ./uboot-src using config ${
                        if ubootPkg.defconfig != null then ubootPkg.defconfig else "none"
                      }..."
                      cd ./uboot-src
                      make ${if ubootPkg.defconfig != null then ubootPkg.defconfig else "none"}
                      cd ..
                      echo "Done!"
                    }
                  '';
                }
              else
                null;

          in
          (
            if kernelDevShell != null then
              [
                {
                  name = "kernel-dev-${boardKey}";
                  value = kernelDevShell;
                }
              ]
            else
              [ ]
          )
          ++ (
            if ubootDevShell != null then
              [
                {
                  name = "uboot-dev-${boardKey}";
                  value = ubootDevShell;
                }
              ]
            else
              [ ]
          )
        ) (builtins.attrNames data.boardsIndex)
      );

    in
    {
      devShells = {
        default = pkgs.mkShell {
          inputsFrom = [ self'.packages.default ];
          packages = [
            pkgs.python3Packages.pytest
            pkgs.python3Packages.ipython
            pkgs.just
            pkgs.jq
            pkgs.git
            pkgs.nvfetcher
            pkgs.nix-prefetch-git
            pkgs.python3Packages.toml
            pkgs.attic-client
            pkgs.cachix
            pkgs.ruff
            pkgs.nixfmt-rfc-style
          ];

          shellHook = ''
            echo "❄️ Nixbian Development Shell"
            echo "Commands: just upgrade, just fetch-board <name>, just check, pytest"
            echo "Caching: attic login, cachix use"
            echo "Usage: nix build .#<board-name>"
          '';
        };
      }
      // boardDevShells;
    };
}
