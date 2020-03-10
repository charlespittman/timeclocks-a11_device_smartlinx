#
# SoC-specific compile-time definitions.
#

BOARD_SOC_TYPE := IMX8MP
BOARD_TYPE := EVK
BOARD_HAVE_VPU := true
BOARD_VPU_TYPE := hantro
HAVE_FSL_IMX_GPU2D := false
HAVE_FSL_IMX_GPU3D := true
HAVE_FSL_IMX_IPU := false
HAVE_FSL_IMX_PXP := false
BOARD_KERNEL_BASE := 0x40400000
TARGET_GRALLOC_VERSION := v3
TARGET_HIGH_PERFORMANCE := true
TARGET_USES_HWC2 := true
TARGET_HWCOMPOSER_VERSION := v2.0
USE_OPENGL_RENDERER := true
TARGET_HAVE_VULKAN := true
ENABLE_CFI=false

SOONG_CONFIG_IMXPLUGIN += \
                        BOARD_HAVE_VPU \
                        BOARD_VPU_TYPE

SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_TYPE = IMX8MP
SOONG_CONFIG_IMXPLUGIN_BOARD_HAVE_VPU = true
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_TYPE = hantro

#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx8m/evk_8mp

include device/fsl/imx8m/BoardConfigCommon.mk

BUILD_TARGET_FS ?= ext4
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale

# Support gpt
ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
  BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab_super.bpt
  ADDITION_BPT_PARTITION = partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab_super.bpt \
                           partition-table-dual:device/fsl/common/partition/device-partitions-13GB-ab-dual-bootloader_super.bpt \
                           partition-table-28GB-dual:device/fsl/common/partition/device-partitions-28GB-ab-dual-bootloader_super.bpt
else
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab-no-product.bpt
    ADDITION_BPT_PARTITION = partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab-no-product.bpt \
                             partition-table-dual:device/fsl/common/partition/device-partitions-13GB-ab-dual-bootloader-no-product.bpt \
                             partition-table-28GB-dual:device/fsl/common/partition/device-partitions-28GB-ab-dual-bootloader-no-product.bpt
  else
    BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab.bpt
    ADDITION_BPT_PARTITION = partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab.bpt \
                             partition-table-dual:device/fsl/common/partition/device-partitions-13GB-ab-dual-bootloader.bpt \
                             partition-table-28GB-dual:device/fsl/common/partition/device-partitions-28GB-ab-dual-bootloader.bpt
  endif
endif

# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml

TARGET_BOOTLOADER_BOARD_NAME := EVK

USE_OPENGL_RENDERER := true

# NXP 8997 WIFI
BOARD_WLAN_DEVICE            := nxp
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211
BOARD_HOSTAPD_PRIVATE_LIB               := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# NXP 8997 BT
BOARD_HAVE_BLUETOOTH_NXP := true

# NXP 8997 BT
BOARD_HAVE_BLUETOOTH_NXP := true

BOARD_USE_SENSOR_FUSION := true

# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

BOARD_HAVE_USB_CAMERA := true

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA4096
# The testkey_rsa4096.pem is copied from external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_KEY_PATH := device/fsl/common/security/testkey_rsa4096.pem
TARGET_USES_MKE2FS := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

CMASIZE=800M
# NXP default config
BOARD_KERNEL_CMDLINE := init=/init androidboot.console=ttymxc1 androidboot.hardware=freescale firmware_class.path=/vendor/firmware loop.max_part=7

# memory config
BOARD_KERNEL_CMDLINE += transparent_hugepage=never

# display config
BOARD_KERNEL_CMDLINE += androidboot.lcd_density=240 androidboot.primary_display=imx-drm

# wifi config
BOARD_KERNEL_CMDLINE += androidboot.wificountrycode=CN

# low memory device build config
ifeq ($(LOW_MEMORY),true)
BOARD_KERNEL_CMDLINE += cma=320M@0x400M-0xb80M androidboot.displaymode=720p galcore.contiguousSize=33554432
else
BOARD_KERNEL_CMDLINE += cma=$(CMASIZE)@0x400M-0xb80M
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_PREBUILT_DTBOIMAGE := out/target/product/evk_8mp/dtbo-imx8mp.img

ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    TARGET_BOARD_DTS_CONFIG := imx8mp:imx8mp-evk-no-product.dtb
  else
    TARGET_BOARD_DTS_CONFIG := imx8mp:imx8mp-evk.dtb
    # Used to support mcu image
    TARGET_BOARD_DTS_CONFIG += imx8mp-rpmsg:imx8mp-evk-rpmsg.dtb
    # Support HDMI interface
    TARGET_BOARD_DTS_CONFIG += imx8mp-hdmi:imx8mp-evk-hdmi.dtb
    # Support LVDS interface
    TARGET_BOARD_DTS_CONFIG += imx8mp-lvds:imx8mp-evk-it6263-lvds-dual-channel.dtb
  endif
else # no dynamic parition feature
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    TARGET_BOARD_DTS_CONFIG := imx8mp:imx8mp-evk-no-product-no-dynamic_partition.dtb
  else
    TARGET_BOARD_DTS_CONFIG := imx8mp:imx8mp-evk-no-dynamic_partition.dtb
  endif
endif

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx8m/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers

ALL_DEFAULT_INSTALLED_MODULES += $(BOARD_VENDOR_KERNEL_MODULES)
