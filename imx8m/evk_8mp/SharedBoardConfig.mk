KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64

#Enable this to config 1GB ddr on evk_imx8mp
#LOW_MEMORY := true

#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true

#Enable this to disable product partition build.
#IMX_NO_PRODUCT_PARTITION := true

#NXP 8997 wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/marvell/mrvl8997/wlan_src/mlan.ko \
    $(KERNEL_OUT)/drivers/net/wireless/marvell/mrvl8997/wlan_src/pcie8xxx.ko \