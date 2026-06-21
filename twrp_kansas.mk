# Architecture configuration must precede the base product inheritance.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Populate the standard Android root filesystem required while constructing
# the standalone recovery ramdisk fragment in vendor_boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Inherit common TWRP configuration.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit Kansas device configuration.
$(call inherit-product, device/motorola/kansas/device.mk)

PRODUCT_DEVICE := kansas
PRODUCT_NAME := twrp_kansas
PRODUCT_BRAND := motorola
PRODUCT_MODEL := moto g 2025
PRODUCT_MANUFACTURER := motorola
