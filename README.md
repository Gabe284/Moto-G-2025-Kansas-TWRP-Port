# TWRP device tree for Motorola Kansas

Initial experimental TWRP tree for the Motorola Moto G 2025
XT2513-1, codename `kansas`.

## Layout

- Boot header version 4
- Stock platform vendor-ramdisk fragment preserved
- TWRP built as a separate type-2 recovery fragment
- Stock slot-B kernel and init_boot remain unchanged
- FocalTech SPI touchscreen modules included
- FBE metadata decryption not yet supported

## Build

```sh
repo init --depth=1 \
  -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git \
  -b twrp-12.1

repo sync -c --force-sync --no-clone-bundle --no-tags

source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_kansas-eng
mka vendorbootimage


## Latest verified build

The `fix/usb-display-product-v2` branch completed GitHub Actions run 12 successfully on 2026-06-24. The workflow completed all stages, including the vendor_boot build, explicit vendor_boot repack, structural validation, and artifact upload. The 14-day artifact retention period has elapsed, so the image is no longer available from that run. This confirms a successful CI build and image-structure checks, not a physical-device boot test.

The development branch uses `RGBX_8888` for the recovery display and validates the vendor_boot v4 ramdisk table, fragment order, stock platform ramdisk SHA-256, stock DTB SHA-256, and the 64 MiB vendor_boot size limit. Continue from `fix/usb-display-product-v2`; do not replace its stock boot components with newly generated ones without device-specific evidence.

## Collecting the next device-side validation data

A read-only inventory script is available at `tools/collect-kansas-device-report.sh`. It records device identity properties, active slot, partition names and sizes, stock fstab entries, encryption/keymaster properties, display/backlight nodes, input devices, kernel modules, and USB state. It does not dump partitions or read personal files.

From Termux, after cloning this repository:

```sh
cd ~/Moto-G-2025-Kansas-TWRP-Port
git switch tools/device-validation-report
git pull --ff-only
su -c "sh /data/data/com.termux/files/home/Moto-G-2025-Kansas-TWRP-Port/tools/collect-kansas-device-report.sh"
```

The report is written to `/sdcard/Download/kansas-twrp-device-report.txt`. Review it before sharing. The report is intended to guide the next configuration stage; it does not enable encryption support or flash anything.

## Safety

Do not flash the generated `vendor_boot.img` yet. First verify the image against the exact device's current stock vendor_boot, DTB, active slot, and partition layout. Keep a known-good stock boot/vendor_boot/init_boot backup for both slots before any recovery boot or flash test.
