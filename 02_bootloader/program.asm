; ====================================================================================================
; This program simply prints a character on the screen.
; The program is almost the same as in Tutorial 1, so refer to that tutorial for information.
; The only difference is the code's starting address, here 0x8000.
; 0x8000 is the address where the bootloader loads the sectors from floppy (see bootloader.asm).
; ====================================================================================================

[ORG 0x8000]								; this is where the sectors were loaded
[BITS 16]									; 16-bit mode

start:
   mov ax, 0xb800
   mov ds, ax								; set data segment register
   
   mov word [ds:0x0000], 'A' | (0x07 << 8)	; write character and format at ds:0x0000 (ds * 0x10 + 0x0000)
   
   jmp $									; endless loop
