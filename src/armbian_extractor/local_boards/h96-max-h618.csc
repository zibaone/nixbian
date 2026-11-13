# Allwinner H618 quad core 2GB RAM SoC eMMC-only — TV box (H96 Max H618)
#
# Carte absente du dépôt Armbian (vérifié : ni config/boards, ni boards.json,
# ni DTS mainline). Ce fichier est la source locale de la carte pour nixbian ;
# il est lu après Armbian et ignoré si une entrée amont apparaît (voir core.py,
# `_locate_board_conf`).
#
# Mesuré sur la carte (boot0 UART + FDT vendor + boot NixOS depuis la eMMC) :
#   PMIC AXP1530 (= AXP313a), DDR3-1333 @648 MHz, 2048 Mo,
#   eMMC 15 028 Mo sur mmc2 (8 bits, HS-SDR52 50 MHz, pas de HS200),
#   pas de slot SD (mmc0), WiFi AIC8800 en SDIO1 (wlan_regon=PG18),
#   Ethernet EMAC1 + PHY AC300 co-packagé (MDIO 0x10, RMII, PWM5 = 24 MHz).
#
# BOOTCONFIG : le H96 n'a pas de defconfig U-Boot amont (404 sur v2025.04 et
# master), et son boot0 vendor est mort (écrasé par le SPL mainline lors de
# l'installation). `transpeed-8k618-t_defconfig` est la base retenue : même
# SoC, même PMIC, même DDR3-648 — elle a amorcé cette carte en RAM depuis le
# FEL, puis depuis la eMMC. Ne pas la changer sans revalider un boot complet.
#
# Le DTS n'existe pas non plus : il est fourni par le patch nixbian
# `kernel/sunxi-7.0-h96-max` (registre dans platform_patches.json), qui ajoute
# le fichier et son entrée Makefile. BOOT_FDT_FILE doit donc nommer ce DTS.
BOARD_NAME="H96 Max H618"
BOARD_VENDOR="h96"
BOARDFAMILY="sun50iw9"
BOARD_MAINTAINER="HavenOS (local, absent from Armbian)"
BOOTCONFIG="transpeed-8k618-t_defconfig"
BOOTBRANCH="tag:v2025.04"
BOOTPATCHDIR="v2025-sunxi"
BOOT_FDT_FILE="allwinner/sun50i-h618-h96-max.dtb"
OVERLAY_PREFIX="sun50i-h616"
KERNEL_TARGET="edge"
KERNEL_PARAMS="console=ttyS0,115200"
