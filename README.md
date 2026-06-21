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
