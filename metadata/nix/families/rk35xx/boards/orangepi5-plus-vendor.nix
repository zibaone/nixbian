{ platforms, lib }:
lib.recursiveUpdate platforms."rk35xx-vendor" {
  board = "orangepi5-plus";
  dtb = null;
  family = "rk35xx";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr orangepi-5-plus-rk3588_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr orangepi-5-plus-rk3588_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    config = "orangepi-5-plus-rk3588_defconfig";
  };
}
