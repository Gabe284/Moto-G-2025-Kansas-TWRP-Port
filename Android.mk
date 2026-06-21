LOCAL_PATH := $(call my-dir)

# FocalTech touchscreen dependency for the recovery ramdisk.
include $(CLEAR_VARS)
LOCAL_MODULE := kansas_sensors_class_ko
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := recovery/root/lib/modules/sensors_class.ko
LOCAL_MODULE_STEM := sensors_class.ko
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/lib/modules
include $(BUILD_PREBUILT)

# FocalTech touchscreen driver for the recovery ramdisk.
include $(CLEAR_VARS)
LOCAL_MODULE := kansas_focaltech_0flash_ko
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := recovery/root/lib/modules/focaltech_0flash_mmi_v3.ko
LOCAL_MODULE_STEM := focaltech_0flash_mmi_v3.ko
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/lib/modules
include $(BUILD_PREBUILT)
