{ lib }:
rec {
  # Fetch Armbian source for a given version
  fetchArmbian =
    pkgs: version:
    let
      versions = builtins.fromJSON (builtins.readFile ../versions.json);
      info = versions."${version}";
    in
    pkgs.fetchFromGitHub {
      owner = "armbian";
      repo = "build";
      rev = info.rev;
      hash = info.hash;
    };

  # Load metadata into Nix attributes
  loadMetadata =
    pkgs: metadataPath:
    let
      boardsJson = builtins.fromJSON (builtins.readFile "${metadataPath}/boards.json");

      # Extract unique families from the boards dictionary
      familiesList = lib.unique (map (b: b.family) (lib.attrValues boardsJson));

      # Helper to import family data
      loadFamily =
        family:
        let
          familyPath = "${metadataPath}/nix/families/${family}";
          platforms = import "${familyPath}/platforms.nix";
          boards = import "${familyPath}/default.nix" { inherit lib; };
        in
        {
          inherit platforms boards;
        };

      families = lib.genAttrs familiesList (name: loadFamily name);

      # Map all boards for easy access
      allBoards = lib.listToAttrs (
        lib.concatMap (
          f:
          map (b: {
            name = b;
            value = families.${f}.boards.${b};
          }) (lib.attrNames families.${f}.boards)
        ) familiesList
      );

      helpers = import "${metadataPath}/nix/library.nix" { inherit pkgs; };

    in
    {
      inherit families helpers;
      platforms = allBoards;
      boardsIndex = boardsJson;
    };
}
