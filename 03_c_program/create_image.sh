#!/bin/sh

# ====================================================================================================
# This script creates an image file from the source files.
# First the bootloader is compiled and a bootable file (bootloader.bin.padded) is created.
# Then start.asm and main.c are compiled and linked together in a kernel.bin.
# Through its parameters, the linker sets the format of kernel.bin as binary,
# sets the code's starting address at 0x8000 (as expected by bootloader, see bootloader.asm)
# and sets the start label, found in start.asm, as the kernel's entry point.
# Next the script pads kernel.bin to fill 5 sectors, as expected by bootloader.
# Finally bootloader.bin.padded and kernel.bin.padded are concatenated to form the image file.
# ====================================================================================================

# Compile bootloader
nasm -f bin -o bootloader.bin bootloader.asm

# Make bootloader bootable
dd if=/dev/zero of=bootloader.bin.padded ibs=510 count=1
echo -n -e '\xAA\x55' >> bootloader.bin.padded
dd if=bootloader.bin of=bootloader.bin.padded conv=notrunc

# Compile program source files
nasm -f elf -o start.o start.asm		# output format is elf, so it can be linked with main
gcc -c -o main.o main.c

# Link object files
ld -o kernel.bin --oformat=binary --Ttext=0x8000 -e start start.o main.o

# Pad kernel to fill 5 sectors
dd if=/dev/zero of=kernel.bin.padded ibs=512 count=5
dd if=kernel.bin of=kernel.bin.padded conv=notrunc

# Concatenate bootloader and kernel to create image file
cat bootloader.bin.padded kernel.bin.padded > image.img

# Cleanup temporary files
rm *.o *.bin *.padded
