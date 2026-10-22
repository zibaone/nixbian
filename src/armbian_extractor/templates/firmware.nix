{ pkgs }:
let
  lib = pkgs.lib;
  defaultSrc = pkgs.fetchFromGitHub {
    owner = "armbian";
    repo = "firmware";
    rev = "617ccae735b1bff23b2d90ee711786ed42b8dc18";
    hash = "sha256-8d9/KHhL+FYnoR+1ZUMvYFG6A2+nfz8smOpWkm+vpJY=";
  };

  # 1. Base Builder: copies firmware files from sources
  buildRaw =
    {
      family,
      srcs,
      include,
      copyAll,
      extraCommands,
      dirs,
    }:
    pkgs.runCommand "raw-firmware-${family}" { } ''
      mkdir -p $out/lib/firmware

      # Helper to safe copy from multiple sources
      copy_dir() {
        if [ -z "$1" ]; then
          return 0
        fi
        local found=0
        for s in ${toString srcs}; do
          local dir_path=""
          if [ -d "$s/$1" ]; then
            dir_path="$s/$1"
          elif [ -d "$s/packages/blobs/$1" ]; then
            dir_path="$s/packages/blobs/$1"
          fi

          if [ -n "$dir_path" ]; then
            echo "Copying $1 from $dir_path..."
            local dest="$out/lib/firmware/$(dirname "$1")"
            mkdir -p "$dest"
            # Ensure destination is writable if it already exists (from a previous source)
            chmod -R +w "$out/lib/firmware" 2>/dev/null || true
            
            # Copy content. If destination directory exists, merge contents.
            cp -rf "$dir_path" "$dest/"
            found=1
          fi
        done
        
        if [ $found -eq 0 ]; then
          echo "Warning: Firmware dir $1 not found in any source"
        fi
      }

      ${
        if copyAll then
          ''
            # Copy all contents from all sources
            for s in ${toString srcs}; do
              if [ -d "$s" ]; then
                echo "Copying all contents from $s..."
                chmod -R +w "$out/lib/firmware" 2>/dev/null || true
                find "$s" -mindepth 1 -maxdepth 1 ! -name ".git" -exec cp -rf {} "$out/lib/firmware/" \;
              fi
            done
          ''
        else if include != null then
          ''
            # Selective installation
            for item in ${toString include}; do
              copy_dir "$item"
            done
          ''
        else
          ''
            # Standard installation using dirs if specified, otherwise family
            ${
              if dirs != null then
                ''
                  for d in ${toString dirs}; do
                    copy_dir "$d"
                  done
                ''
              else
                ''
                  copy_dir "${family}"

                  # Try to find blobs matching the family name without suffixes
                  ${
                    let
                      f64 = lib.removeSuffix "64" family;
                      f32 = lib.removeSuffix "32" family;
                    in
                    ''
                      ${lib.optionalString (f64 != family) ''copy_dir "${f64}"''}
                      ${lib.optionalString (f32 != family) ''copy_dir "${f32}"''}
                    ''
                  }
                ''
            }
            copy_dir "bt"
          ''
      }

      ${extraCommands}

      # Clean up broken symlinks
      find $out/lib/firmware -xtype l -delete
    '';

  # 2. Pruning Step: filters firmware using DTB compatible list
  prune =
    { src, dtb }:
    pkgs.runCommand "pruned-firmware"
      {
        nativeBuildInputs = [ pkgs.dtc ];
        dtb_file = dtb;
      }
      ''
        mkdir -p $out/lib/firmware
        if [ ! -f "$dtb_file" ]; then
          echo "Error: DTB file not found at $dtb_file"
          exit 1
        fi

        # Decompile DTB to DTS
        dtc -I dtb -O dts -o board.dts "$dtb_file"

        # Extract compatibility keywords
        grep -o 'compatible = "[^"]*"' board.dts | \
          sed -E 's/compatible = "([^"]*)"/\1/' | \
          tr '[:upper:]' '[:lower:]' | \
          tr ', ' '\n' | sort -u > keywords.txt

        echo "Extracted hardware keywords:"
        cat keywords.txt

        # Always preserve core wireless regulatory files and directories
        cp -rf ${src}/lib/firmware/regulatory* $out/lib/firmware/ 2>/dev/null || true

        # Scan and copy matching firmware folders/files
        while read -r kw; do
          if [ -z "$kw" ] || [ ''${#kw} -lt 3 ]; then
            continue
          fi

          find ${src}/lib/firmware -mindepth 1 -maxdepth 2 -iname "*$kw*" | while read -r match; do
            rel_path=''${match#${src}/lib/firmware/}
            dest_path="$out/lib/firmware/$rel_path"
            mkdir -p "$(dirname "$dest_path")"
            cp -rf "$match" "$dest_path"
          done
        done < keywords.txt
      '';

  # 3. Compression Step: Compresses files using ZSTD if kernel config supports it
  compress =
    { src, kernelConfig }:
    pkgs.runCommand "compressed-firmware"
      {
        nativeBuildInputs = [ pkgs.zstd ];
        kernel_config = kernelConfig;
      }
      ''
        mkdir -p $out/lib/firmware
        if [ -d "${src}/lib/firmware" ]; then
          cp -rf ${src}/lib/firmware/. $out/lib/firmware/
          chmod -R +w $out/lib/firmware
        fi

        is_compressed=0
        if [ -f "$kernel_config" ]; then
          if grep -q "CONFIG_FW_LOADER_COMPRESS=y" "$kernel_config"; then
            is_compressed=1
          fi
        fi

        if [ "$is_compressed" = "1" ]; then
          echo "Compressing firmware with zstd..."
          find $out/lib/firmware -type f ! -name "*.zst" -exec zstd --rm -19 {} \;
        fi

        # Clean up broken symlinks after compression
        find $out/lib/firmware -xtype l -delete
      '';
in
rec {
  # Build firmware by combining raw copy, optional pruning and optional compression
  build =
    {
      family,
      srcs ? [ defaultSrc ],
      include ? null,
      copyAll ? false,
      extraCommands ? "",
      dirs ? null,
      dtb ? null,
      kernelConfig ? null,
    }:
    let
      raw = buildRaw {
        inherit
          family
          srcs
          include
          copyAll
          extraCommands
          dirs
          ;
      };
      pruned =
        if dtb != null then
          prune {
            inherit dtb;
            src = raw;
          }
        else
          raw;
      compressed =
        if kernelConfig != null then
          compress {
            inherit kernelConfig;
            src = pruned;
          }
        else
          pruned;
    in
    compressed;

  # Backward compatibility
  forFamily = family: build { inherit family; };
}
