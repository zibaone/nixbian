{ platforms, lib }:
lib.recursiveUpdate platforms."k3-beagle-vendor" {
  board = "pocketbeagle2";
  dtb = null;
  family = "k3-beagle";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    config = "am6232_pocketbeagle2_a53_defconfig";
  };
}
