{ platforms, lib }:
lib.recursiveUpdate platforms."generic-vendor" {
  board = "easepi-a2";
  dtb = "rockchip/rk3568-easepi-a2.dtb";
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr easepi-a2-rk3568_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr easepi-a2-rk3568_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    config = "easepi-a2-rk3568_defconfig";
  };
}
