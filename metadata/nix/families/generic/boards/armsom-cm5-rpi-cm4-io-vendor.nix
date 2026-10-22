{ platforms, lib }:
lib.recursiveUpdate platforms."generic-vendor" {
  board = "armsom-cm5-rpi-cm4-io";
  dtb = null;
  family = "generic";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
    atf_target_map = "M0_CROSS_COMPILE=arm-linux-gnueabi- PLAT=\${BOOT_SOC:=$(expr armsom-cm5-rpi-cm4-io-rk3576_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)} bl31;;build/\${BOOT_SOC:=$(expr armsom-cm5-rpi-cm4-io-rk3576_defconfig : .*\(rk[[:digit:]]\+.*\)_.* || true)}/release/bl31/bl31.elf:bl31.elf";
    config = "armsom-cm5-rpi-cm4-io-rk3576_defconfig";
  };
}
