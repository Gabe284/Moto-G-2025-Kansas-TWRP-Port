# TWRP device tree for Motorola Kansas

Experimental TWRP device tree for the Motorola Moto G 2025, model XT2513-1, codename `kansas`, MediaTek MT6835.

## Device-tree design

- ARM64 target.
- Android vendor_boot header version 4.
- Motorola stock platform vendor-ramdisk fragment preserved.
- TWRP built as a separate type-2 recovery ramdisk fragment.
- Stock kernel, DTB, and init_boot are not rebuilt by this recovery-only workflow.
- FocalTech SPI touchscreen kernel modules and firmware are included.
- FBE and metadata decryption are not yet implemented or validated.

## Build locally

```sh
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
repo sync -c --force-sync --no-clone-bundle --no-tags
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_kansas-eng
mka vendorbootimage
```

## Latest verified CI build

The `fix/usb-display-product-v2` branch completed GitHub Actions run 12 successfully on 2026-06-24. All workflow stages completed, including the vendor_boot build, explicit vendor_boot repack, structural validation, and artifact upload. The 14-day artifact retention period has elapsed, so the image is no longer downloadable from that run.

This establishes that CI produced an image passing the workflow's structural checks. It does **not** establish that the image boots on physical hardware.

That branch includes:
- `RGBX_8888` recovery display format.
- Explicit vendor_boot v4 repacking with ordered `platform` and `recovery` fragments.
- Validation of the stock platform ramdisk and DTB SHA-256 hashes.
- Validation of the recovery fragment name/type, fragment count, image header, and 64 MiB vendor_boot partition limit.

Use `fix/usb-display-product-v2` as the integration baseline. Do not replace stock boot components or flash the image before matching it against the current device's stock images and partition layout.

## Collect device-side validation data

The read-only inventory script `tools/collect-kansas-device-report.sh` collects:
- Device identity and active-slot properties.
- Partition names, symlink targets, and available partition sizes.
- Stock fstab entries and current mounts.
- Encryption, Keymaster, Gatekeeper, and vold properties.
- Display, backlight, touchscreen/input, and kernel-module information.
- USB and ADB state.

It does not dump partitions, extract encryption keys, modify device settings, or flash anything.

From Termux, run the following. It clones the repository only if needed, then checks out the validation branch:

```sh
REPO="$HOME/Moto-G-2025-Kansas-TWRP-Port"
if [ ! -d "$REPO/.git" ]; then
    git clone https://github.com/Gabe284/Moto-G-2025-Kansas-TWRP-Port.git "$REPO"
fi
cd "$REPO" || exit 1
git fetch origin
if git show-ref --verify --quiet refs/heads/tools/device-validation-report; then
    git switch tools/device-validation-report
else
    git switch --track -c tools/device-validation-report origin/tools/device-validation-report
fi
git pull --ff-only
su -c "sh '$REPO/tools/collect-kansas-device-report.sh'"
```

The report is written to `/sdcard/Download/kansas-twrp-device-report.txt`. Review it before sharing.

## Safety requirements

1. Keep known-good stock backups of `boot`, `init_boot`, `vendor_boot`, `dtbo`, and relevant vbmeta partitions for both slots where available.
2. Confirm the current active slot and exact partition sizes before any write operation.
3. Validate the generated vendor_boot image against the current stock vendor_boot, DTB, and platform ramdisk.
4. First test recovery using a supported temporary boot method if the device bootloader supports it. Do not assume `fastboot boot` is supported for this MediaTek device.
5. Do not flash until recovery boot, touchscreen, USB/ADB, storage mounting, and normal Android reboot have been tested.
6. Do not claim encryption support until FBE and metadata decryption have been demonstrated against the device's actual Android 16 userdata configuration.
