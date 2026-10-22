from scripts.config_to_nix import convert_config_to_nix


def test_convert_config_to_nix():
    sample_config = """
# CONFIG_PM is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=m
CONFIG_NR_CPUS=8
CONFIG_LOCALVERSION="-nixbian"
CONFIG_6LOWPAN=y
"""
    expected_nix = """{ lib, ... }:
{
  PM = lib.kernel.no;
  SYSVIPC = lib.kernel.yes;
  POSIX_MQUEUE = lib.kernel.module;
  NR_CPUS = lib.kernel.freeform "8";
  LOCALVERSION = lib.kernel.freeform "-nixbian";
  "6LOWPAN" = lib.kernel.yes;
}
"""
    result = convert_config_to_nix(sample_config)
    assert result == expected_nix
