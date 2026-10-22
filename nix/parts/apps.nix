{ ... }:
{
  perSystem =
    { self', pkgs, ... }:
    {
      apps = {
        default = {
          type = "app";
          program = "${self'.packages.default}/bin/nixbian-extract";
          meta.description = "Extract metadata from Armbian source";
        };
        update-versions = {
          type = "app";
          program = "${self'.packages.default}/bin/nixbian-update";
          meta.description = "Update versions.json with latest Armbian releases";
        };
        # Hardware discovery helpers
        list-families = {
          type = "app";
          program = "${pkgs.writeShellScriptBin "list-families" ''
            ${pkgs.nix}/bin/nix eval .#legacyPackages.${pkgs.stdenv.hostPlatform.system}.boards --apply builtins.attrNames --json | ${pkgs.jq}/bin/jq -r '.[]'
          ''}/bin/list-families";
        };
        list-boards = {
          type = "app";
          program = "${pkgs.writeShellScriptBin "list-boards" ''
            FAMILY=$1
            if [ -z "$FAMILY" ]; then
              echo "Listing ALL supported boards (600+):"
              ${pkgs.nix}/bin/nix eval .#legacyPackages.${pkgs.stdenv.hostPlatform.system}.platforms --apply builtins.attrNames --json | ${pkgs.jq}/bin/jq -r '.[]'
            else
              ${pkgs.nix}/bin/nix eval .#legacyPackages.${pkgs.stdenv.hostPlatform.system}.boards.$FAMILY --apply builtins.attrNames --json | ${pkgs.jq}/bin/jq -r '.[]'
            fi
          ''}/bin/list-boards";
        };
      };
    };
}
