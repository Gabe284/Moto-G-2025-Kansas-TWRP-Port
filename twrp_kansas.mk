$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, vendor/twrp/config/common.mk)
$(call inherit-product, device/motorola/kansas/device.mk)

PRODUCT_DEVICE := kansas
PRODUCT_NAME := twrp_kansas
PRODUCT_BRAND := motorola
PRODUCT_MODEL := moto g 2025
PRODUCT_MANUFACTURER := motorola
