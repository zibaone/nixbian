# Mini DTB test: compile ONLY the allwinner/ family DTBs
# Usage: nix build -f tests/dtb-test.nix
{
  pkgs ? import <nixpkgs> { },
}:

let
  sources = pkgs.callPackage ../metadata/sources/generated.nix { };
  src = sources.kernel-sunxi64-branch-linux-6-18-y.src;
  nativeCc = "${pkgs.buildPackages.stdenv.cc}/bin/cc";
  nativeCpp = "${pkgs.buildPackages.stdenv.cc}/bin/cpp";
  familyDir = "allwinner";
in
pkgs.stdenv.mkDerivation {
  name = "dtb-test-orangepizero3";
  inherit src;
  nativeBuildInputs = with pkgs.buildPackages; [
    bison
    flex
  ];
  buildPhase = ''
    make ARCH=arm64 defconfig
    make ARCH=arm64 scripts_dtc HOSTCC=${nativeCc}

    mkdir -p $out
    for dts in arch/arm64/boot/dts/${familyDir}/*.dts; do
      name=$(basename $dts .dts)
      ${nativeCpp} -nostdinc -undef -x assembler-with-cpp \
        -I arch/arm64/boot/dts/${familyDir} \
        -I arch/arm64/boot/dts \
        -I arch/arm/boot/dts \
        -I include \
        -I arch/arm64/include \
        $dts |
      scripts/dtc/dtc -@ -o $out/$name.dtb -b 0 2>&1 | grep -v "^Warning\|^  also\|^$" || true
    done
  '';
  installPhase = "true";
}
