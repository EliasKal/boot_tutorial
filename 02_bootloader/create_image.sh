#!/bin/sh

# ==============================================================================
# This script creates an image file containing both the bootloader and the 
# program.
# It first compiles the bootloader and the program.
# Then it pads the bootloader executable, so it fills one sector,
# and adds the boot signature so it is bootable.
# Then it pads the program executable, so it fills 5 sectors,
# as is expected by the bootloader (see bootloader.asm).
# Finally it concatenates the two padded files in one image file.
# ==============================================================================

# Compile bootloader
nasm -f bin -o bootloader.bin bootloader.asm

# Compile program
nasm -f bin -o program.bin program.asm

# Make bootloader bootable
dd if=/dev/zero of=bootloader.bin.padded ibs=510 count=1
echo -n -e '\xAA\x55' >> bootloader.bin.padded
dd if=bootloader.bin of=bootloader.bin.padded conv=notrunc

# Pad program to fill 5 sectors
dd if=/dev/zero of=program.bin.padded ibs=512 count=5
dd if=program.bin of=program.bin.padded conv=notrunc

# Concatenate bootloader and program to create image file
cat bootloader.bin.padded program.bin.padded > image.img

# Cleanup temporary files
rm *.bin *.padded

