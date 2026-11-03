#!/system/bin/sh
# Read-only hardware and recovery compatibility inventory for Motorola Kansas.
# Run as root. Does not dump partitions, keys, identifiers, or personal files.

set -u

OUT="${1:-/sdcard/Download/kansas-twrp-device-report.txt}"
OUT_DIR="${OUT%/*}"
[ "$OUT_DIR" = "$OUT" ] && OUT_DIR="."

if [ "$(id -u)" != "0" ]; then
    echo "ERROR: run this script as root (for example: su -c sh ...)" >&2
    exit 1
fi

mkdir -p "$OUT_DIR" 2>/dev/null || exit 1
umask 077
: > "$OUT" || exit 1
exec >> "$OUT" 2>&1

section() {
    printf '\n\n========== %s ==========\n' "$1"
}

prop() {
    key="$1"
    value="$(getprop "$key" 2>/dev/null)"
    printf '%-42s %s\n' "$key" "$value"
}

file_if_readable() {
    file="$1"
    if [ -r "$file" ]; then
        echo "--- $file"
        cat "$file"
    fi
}

section "REPORT METADATA"
date 2>/dev/null
uname -a
id
echo "Output is a read-only inventory; no partition data was written."

section "DEVICE IDENTITY"
for key in \
    ro.product.manufacturer \
    ro.product.brand \
    ro.product.model \
    ro.product.device \
    ro.product.name \
    ro.product.vendor.device \
    ro.product.vendor.model \
    ro.build.fingerprint \
    ro.vendor.build.fingerprint \
    ro.board.platform \
    ro.hardware \
    ro.boot.hardware \
    ro.boot.hardware.sku \
    ro.boot.product.hardware.sku \
    ro.boot.slot_suffix \
    ro.boot.slot \
    ro.bootmode \
    ro.boot.bootdevice \
    ro.boot.verifiedbootstate \
    ro.boot.flash.locked \
    ro.boot.vbmeta.device_state \
    ro.build.version.release \
    ro.build.version.sdk \
    ro.vendor.build.version.sdk \
    ro.crypto.state \
    ro.crypto.type \
    ro.crypto.metadata.enabled \
    ro.crypto.volume.filenames_mode \
    ro.crypto.volume.options \
    ro.hardware.egl \
    ro.opengles.version
do
    prop "$key"
done

section "KERNEL AND MEMORY"
cat /proc/version 2>/dev/null
grep -E '^(MemTotal|MemAvailable|SwapTotal|SwapFree):' /proc/meminfo 2>/dev/null
getconf PAGE_SIZE 2>/dev/null
cat /sys/devices/system/cpu/present 2>/dev/null
cat /sys/devices/system/cpu/online 2>/dev/null

section "PARTITION MAP AND SIZES"
for base in /dev/block/by-name /dev/block/bootdevice/by-name /dev/block/platform/*/by-name; do
    if [ -d "$base" ]; then
        echo "--- $base"
        ls -l "$base" 2>/dev/null
        for part in boot_a boot_b init_boot_a init_boot_b vendor_boot_a vendor_boot_b dtbo_a dtbo_b vbmeta_a vbmeta_b vbmeta_system_a vbmeta_system_b recovery_a recovery_b metadata userdata super; do
            node="$base/$part"
            if [ -e "$node" ]; then
                real="$(readlink -f "$node" 2>/dev/null)"
                size=""
                [ -n "$real" ] && size="$(blockdev --getsize64 "$real" 2>/dev/null)"
                printf '%-20s target=%-45s bytes=%s\n' "$part" "$real" "$size"
            fi
        done
    fi
done

section "STOCK FSTAB FILES"
for f in /vendor/etc/fstab* /odm/etc/fstab* /system/etc/fstab* /first_stage_ramdisk/fstab*; do
    [ -f "$f" ] && file_if_readable "$f"
done

section "MOUNT AND FILESYSTEM STATE"
cat /proc/mounts 2>/dev/null
cat /proc/filesystems 2>/dev/null

section "CRYPTO AND KEYMASTER SERVICES"
getprop | grep -Ei 'crypto|encrypt|keymaster|gatekeeper|tee|trustonic|keystore|vold' 2>/dev/null
command -v service >/dev/null 2>&1 && service list 2>/dev/null | grep -Ei 'vold|keymaster|gatekeeper|keystore' || true

section "DISPLAY AND BACKLIGHT"
for f in /sys/class/graphics/fb0/virtual_size /sys/class/graphics/fb0/bits_per_pixel /sys/class/graphics/fb0/modes; do
    file_if_readable "$f"
done
for d in /sys/class/backlight/*; do
    [ -d "$d" ] || continue
    echo "--- $d"
    for f in "$d/brightness" "$d/max_brightness" "$d/actual_brightness" "$d/type"; do
        file_if_readable "$f"
    done
done

section "INPUT DEVICES"
file_if_readable /proc/bus/input/devices
for d in /sys/class/input/event*; do
    [ -e "$d" ] || continue
    printf '%s -> %s\n' "$d" "$(readlink -f "$d/device" 2>/dev/null)"
    for f in "$d/device/name" "$d/device/modalias"; do
        file_if_readable "$f"
    done
done

section "RECOVERY-RELEVANT MODULES"
if command -v lsmod >/dev/null 2>&1; then
    lsmod
else
    cat /proc/modules 2>/dev/null
fi
for d in /vendor/lib/modules /vendor_dlkm/lib/modules /system_dlkm/lib/modules; do
    [ -d "$d" ] && ls -l "$d"
done

section "USB AND ADB STATE"
for key in sys.usb.state sys.usb.config persist.sys.usb.config ro.adb.secure ro.debuggable; do
    prop "$key"
done
for f in /sys/class/android_usb/android0/state /sys/class/android_usb/android0/functions /sys/class/typec/*/data_role /sys/class/typec/*/power_role; do
    [ -f "$f" ] && file_if_readable "$f"
done

section "DEVICE TREE AND BOOT CONFIG AVAILABILITY"
for f in /proc/device-tree/model /proc/device-tree/compatible /sys/firmware/devicetree/base/model /sys/firmware/devicetree/base/compatible; do
    if [ -r "$f" ]; then
        printf '%s: ' "$f"
        tr '\000' ' ' < "$f"
        echo
    fi
done

section "REPORT COMPLETE"
echo "Saved report: $OUT"
echo "Review the report for private information before sharing it."
