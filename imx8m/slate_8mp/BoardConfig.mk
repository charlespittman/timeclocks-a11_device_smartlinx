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
TARGET_GRALLOC_VERSION := v4
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
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_ONLY = false

#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/smartlinx/imx8m/slate_8mp

include device/smartlinx/imx8m/BoardConfigCommon.mk

BUILD_TARGET_FS ?= ext4
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.nxp

BOARD_BPT_INPUT_FILES += device/nxp/common/partition/device-partitions-13GB-ab-dual-bootloader_super.bpt
ADDITION_BPT_PARTITION = partition-table-28GB:device/nxp/common/partition/device-partitions-28GB-ab_super.bpt \
                        partition-table-dual:device/nxp/common/partition/device-partitions-13GB-ab-dual-bootloader_super.bpt \
                        partition-table-28GB-dual:device/nxp/common/partition/device-partitions-28GB-ab-dual-bootloader_super.bpt


# Vendor Interface manifest and compatibility
ifeq ($(POWERSAVE),true)
    DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest_powersave.xml
else
    DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
endif

DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(IMX_DEVICE_PATH)/device_framework_matrix.xml

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
BOARD_HAVE_USB_MJPEG_CAMERA := false

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA4096
# The testkey_rsa4096.pem is copied from external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_KEY_PATH := device/nxp/common/security/testkey_rsa4096.pem

BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 2

TARGET_USES_MKE2FS := true

CMASIZE=800M
# NXP default config
BOARD_KERNEL_CMDLINE := init=/init androidboot.console=ttymxc2 androidboot.hardware=nxp firmware_class.path=/vendor/firmware loop.max_part=7

# memory config
BOARD_KERNEL_CMDLINE += transparent_hugepage=never
BOARD_KERNEL_CMDLINE += swiotlb=65536

# display config
BOARD_KERNEL_CMDLINE += androidboot.lcd_density=160 androidboot.primary_display=imx-drm

# remove blinking cursor at boot
BOARD_KERNEL_CMDLINE += vt.global_cursor_default=0

## wifi config
ifeq ($(POWERSAVE),true)
    BOARD_KERNEL_CMDLINE += androidboot.wificountrycode=CN moal.mod_para=wifi_mod_para_powersave.conf
else
    BOARD_KERNEL_CMDLINE += androidboot.wificountrycode=CN moal.mod_para=wifi_mod_para.conf
endif

# low memory device build config
ifeq ($(LOW_MEMORY),true)
BOARD_KERNEL_CMDLINE += cma=320M@0x400M-0xb80M androidboot.displaymode=720p galcore.contiguousSize=33554432
else
BOARD_KERNEL_CMDLINE += cma=$(CMASIZE)@0x400M-0xb80M
endif

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
BOARD_KERNEL_CMDLINE += androidboot.vendor.sysrq=1
endif

# powersave config
ifeq ($(POWERSAVE),true)
    BOARD_KERNEL_CMDLINE += androidboot.powersave.usb=true
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_PREBUILT_DTBOIMAGE := out/target/product/slate_8mp/dtbo-imx8mp.img

TARGET_BOARD_DTS_CONFIG += imx8mp:imx8mp-verdin-slate.dtb

BOARD_SEPOLICY_DIRS := \
       device/smartlinx/imx8m/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

TARGET_BOARD_KERNEL_HEADERS := device/nxp/common/kernel-headers

ALL_DEFAULT_INSTALLED_MODULES += $(BOARD_VENDOR_KERNEL_MODULES)

BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS += metadata

ifneq (user,$(TARGET_BUILD_VARIANT))
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
endif
