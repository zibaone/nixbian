{ platforms, lib }: lib.recursiveUpdate platforms."phytium-embedded-legacy" {
  board = "phytiumpi";
  dtb = "phytium/phytiumpi_firefly.dtb";
  family = "phytium-embedded";
  firmware = {
  };
  firmware_include = null;
  kernel = {
  };
  kernel_params = null;
  uboot = {
  };
}
