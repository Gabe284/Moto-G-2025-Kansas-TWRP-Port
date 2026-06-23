#
# Motorola Moto G 2025 — Kansas
#

DEVICE_PATH := device/motorola/kansas

ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_BOARD_PLATFORM := mt6835

# Kansas uses a dedicated vendor partition.
TARGET_COPY_OUT_VENDOR := vendor

# A/B
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    system \
    system_ext \
    product \
    vendor \
    vendor_dlkm \
    system_dlkm

# Header v4 vendor_boot
TARGET_NO_KERNEL := true
TARGET_NO_RECOVERY := true

BOARD_BOOT_HEADER_VERSION := 4
BOARD_HEADER_SIZE := 2128

BOARD_KERNEL_PAGESIZE := 4096
BOARD_PAGE_SIZE := 4096
BOARD_FLASH_BLOCK_SIZE := 262144

BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_OFFSET := 0x00000000
BOARD_RAMDISK_OFFSET := 0x26f00000
BOARD_TAGS_OFFSET := 0x07c80000
BOARD_DTB_OFFSET := 0x07c80000

BOARD_VENDOR_CMDLINE := bootopt=64S3,32N2,64N2 mem.enable_mglru=1 loglevel=4 initcall_debug=0

TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img

BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_MKBOOTIMG_ARGS += --vendor_cmdline "$(BOARD_VENDOR_CMDLINE)"
BOARD_MKBOOTIMG_ARGS += --board ""

BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_RAMDISK_USE_LZ4 := true

# Preserve Motorola's platform ramdisk exactly.
BOARD_VENDOR_RAMDISK_FRAGMENTS := platform
BOARD_VENDOR_RAMDISK_FRAGMENT.platform.PREBUILT := \
    $(DEVICE_PATH)/prebuilt/vendor_ramdisk_platform.lz4
BOARD_VENDOR_RAMDISK_FRAGMENT.platform.MKBOOTIMG_ARGS += \
    --ramdisk_type PLATFORM

# Build TWRP as a separate type-2 recovery fragment.
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true

TARGET_RECOVERY_FSTAB := \
    $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab

# Filesystems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_USES_METADATA_PARTITION := true

# Recovery display
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TW_THEME := portrait_hdpi
TW_BRIGHTNESS_PATH := "/sys/class/backlight/ktd3136-bl/brightness"
TW_MAX_BRIGHTNESS := 2047
TW_DEFAULT_BRIGHTNESS := 566
TW_NO_SCREEN_BLANK := true

# Recovery features
TW_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
TW_INCLUDE_FASTBOOTD := true
TW_USE_TOOLBOX := true
TW_EXCLUDE_APEX := true
TW_INCLUDE_REPACKTOOLS := true
TW_DEVICE_VERSION := kansas-unofficial

# Initial build intentionally excludes data decryption support.
# Leave TW_EXCLUDE_ENCRYPTED_BACKUPS unset on TeamWin android-12.1.
# That branch incorrectly links libopenaes whenever the variable is nonempty.
