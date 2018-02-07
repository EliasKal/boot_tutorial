#!/bin/sh

# ====================================================================================================
# This is a script that automates the creation of the image file from the source file.
# First the source file is compiled into binary code.
# Then the binary file is padded to fill one sector (512 bytes) with 
# the boot signature added at the end to make it bootable.
# This last padded file is the image file.
# ====================================================================================================

# Compile source file into binary
nasm -f bin -o boot.bin boot.asm

# Create image file
dd if=/dev/zero of=image.img ibs=510 count=1	# create a file with 510 zeros
echo -n -e '\xAA\x55' >> image.img				# add boot signature at the end
dd if=boot.bin of=image.img conv=notrunc		# insert executable at the beginning

# Cleanup temporary files
# rm *.bin
