; ==============================================================================
; This is a simple program that prints a character on the screen.
; The processor is in 16-bit real mode (default mode when computer is powered 
; on).
; The character to be printed must be loaded in the video memory.
; There are two bytes (one word) for each character in the video memory:
; the low byte is the character and the high byte the character's format.
; The video memory starts at 0x0b8000. To access this address, a segment 
; register must be used.
; ==============================================================================

[ORG 0x7c00]    ; this is where BIOS loads the program by default
[BITS 16]       ; 16 bit mode

start:
    mov ax, 0xb800
    mov ds, ax       ; set data segment register

    ; write character and format at ds:0x0000 (ds * 0x10 + 0x0000)
    mov word [ds:0x0000], 'A' | (0x07 << 8)

    jmp $            ; endless loop

