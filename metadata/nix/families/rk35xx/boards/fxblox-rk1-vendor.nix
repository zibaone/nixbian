{ platforms, lib }:
lib.recursiveUpdate platforms."rk35xx-vendor" {
  board = "fxblox-rk1";
  dtb = null;
  family = "rk35xx";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr fxblox-rk1-rk3588_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr fxblox-rk1-rk3588_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    config = "fxblox-rk1-rk3588_defconfig";
  };
}
