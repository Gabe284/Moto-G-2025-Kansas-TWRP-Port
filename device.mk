LOCAL_PATH := device/motorola/kansas

PRODUCT_USE_DYNAMIC_PARTITIONS := true
# PRODUCT_SHIPPING_API_LEVEL is intentionally unset for the twrp-12.1 recovery-only build.
# Motorola stock vendor firmware is Android 13/API 33, while this TWRP branch exposes SystemSDK 32.

PRODUCT_PROPERTY_OVERRIDES += \
    ro.virtual_ab.enabled=true \
    ro.virtual_ab.compression.enabled=true \
    ro.virtual_ab.userspace.snapshots.enabled=true

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/init.recovery.mt6835.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mt6835.rc \
    $(LOCAL_PATH)/recovery/root/init.recovery.project.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.project.rc \
    $(LOCAL_PATH)/recovery/root/system/etc/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/recovery.fstab \
    $(LOCAL_PATH)/recovery/root/lib/modules/modules.load.recovery:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/modules.load.recovery \
    $(LOCAL_PATH)/recovery/root/lib/modules/modules.dep:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/modules.dep \
    $(LOCAL_PATH)/recovery/root/lib/modules/modules.alias:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/modules.alias \
    $(LOCAL_PATH)/recovery/root/lib/modules/sensors_class.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/sensors_class.ko \
    $(LOCAL_PATH)/recovery/root/lib/modules/focaltech_0flash_mmi_v3.ko:$(TARGET_COPY_OUT_RECOVERY)/root/lib/modules/focaltech_0flash_mmi_v3.ko \
    $(LOCAL_PATH)/recovery/root/vendor/firmware/focaltech_ts_fw_boe_ft8057m.bin:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/firmware/focaltech_ts_fw_boe_ft8057m.bin \
    $(LOCAL_PATH)/recovery/root/vendor/firmware/focaltech_ts_fw_boe_ft8057s.bin:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/firmware/focaltech_ts_fw_boe_ft8057s.bin
