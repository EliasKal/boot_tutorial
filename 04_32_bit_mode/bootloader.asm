; ==============================================================================
; This is a simple bootloader.
; It loads some sectors from floppy to memory, and executes them.
; Loading from memory is done with BIOS interrupt 0x13, with ah = 0x02.
; Before calling the interrupt, appropriate values must be put in specific
; registers.
; These values set up the address where the sectors will be put,
; the drive from which to read data, the number of sectors to read etc.
; ==============================================================================

[ORG 0x7C00]    ; this is where BIOS loads the program by default
[BITS 16]       ; 16-bit mode

start:
    ; Setup the address where the sectors will be loaded.
    ; The address is stored in es:bx.
    mov ax, 0x0000
    mov es, ax
    mov bx, 0x8000	; the address here is 0x0000:0x8000

    ; Load sectors from drive
    mov ah, 0x02    ; 0x02 in ah means load sectors from drive
    mov al, 0x05    ; num of sectors to read, here 5 sectors (more than enough)
    mov ch, 0x00    ; track number
    mov cl, 0x02    ; starting sector, here start from sector 2
    mov dh, 0x00    ; head number
    mov dl, 0x00    ; drive number, here 0 for floppy drive
    int 0x13        ; call the BIOS interrupt

    ; jump to program loaded
    jmp 0x8000

