# Allwinner H618 quad core 4GB RAM SoC WiFi USB — TV box (Transpeed 8K618-T)
#
# Carte absente du dépôt Armbian (vérifié : ni config/boards, ni boards.json).
# Ce fichier est la source locale de la carte pour nixbian ; il est lu après
# Armbian et ignoré si une entrée amont apparaît (voir core.py,
# `_locate_board_conf`).
#
# Mesuré sur la carte (boot0 UART, 2 boots identiques) :
#   PMIC AXP1530 (= AXP313a), DDR3-1333 @648 MHz, 4096 Mo,
#   eMMC 59 640 Mo sur mmc2 (8 bits), vendor U-Boot 2018.07.
# Mainline : DTS depuis v6.8, U-Boot transpeed-8k618-t_defconfig depuis v2024.04.
BOARD_NAME="Transpeed 8K618-T"
BOARD_VENDOR="transpeed"
BOARDFAMILY="sun50iw9"
BOARD_MAINTAINER="HavenOS (local, absent from Armbian)"
BOOTCONFIG="transpeed-8k618-t_defconfig"
BOOTBRANCH="tag:v2025.04"
BOOTPATCHDIR="v2025-sunxi"
BOOT_FDT_FILE="allwinner/sun50i-h618-transpeed-8k618-t.dtb"
OVERLAY_PREFIX="sun50i-h616"
KERNEL_TARGET="edge"
KERNEL_PARAMS="console=ttyS0,115200"
