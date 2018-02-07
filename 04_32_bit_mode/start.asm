; ====================================================================================================
; This program sets up an environment for the main program.
; It switches the processor from 16-bit real mode to 32-bit protected mode.
; Then it sets up the stack, by assigning a value to the stack pointer, and calls main.
; In order for the processor to switch to protected mode,
; a Global Descriptor Table (GDT) must be prepared.
; The GDT contains entries (descriptors) describing memory segments and their read/write permissions.
; Here a flat model is adopted:
; There are two descriptors, one for the code segment and one for the data segment,
; both having the same base and limit.
; Both segments cover the whole addressable memory.
; For the GDT to be complete, a null descriptor must be declared too.
; GDT base and limit are stored in GDTR register when lgdt instruction is executed.
; To switch to 32-bit protected mode, these steps must be done:
;   1. Disable interrupts.
;   2. Load GDT info into GDTR register (with lgdt).
;   3. Switch to protected mode by setting bit 0 of cr0 register to 1.
;   4. Do a far jump to overwrite the cs register.
;   5. Update the other segment registers to the data or the null descriptors.
; After the switching is done, the stack is set up by assigning a proper value to the esp register.
; Then main is called.
; ====================================================================================================

[BITS 16]						; program starts at 16-bit mode

global start					; start label is declared global so that the linker can see it
start:   
   cli							; disable interrupts
   
   lgdt [gdt_info]				; load GDT
   
   mov eax, cr0	
   or al, 1
   mov cr0, eax					; switch to protected mode (bit 0 of cr0 from 0 to 1)
   
   jmp SYS_CODE_SEL:pmode		; far jump to overwrite cs register
   

[BITS 32]						; now any code is in 32-bit mode

pmode:
   mov ax, SYS_DATA_SEL			; update segment registers to point to data segment descriptor
   mov ds, ax
   mov es, ax
   mov ss, ax
   
   mov esp, 0x10000				; set esp to set up the stack (grows downwards)
   
extern main						; main is declared extern because it is defined in another file
   jmp main						; call main
   

; GDTR data (information loaded in GDTR register with lgdt)
gdt_info:
   dw gdt_end-gdt-1				; GDT limit
   dd gdt						; GDT base

; GDT
; follows flat model: code and data segments have same
; base and limits, occupying 4G addresses.
gdt:
; null descriptor
   times 8 db 0

; code segment descriptor
SYS_CODE_SEL equ $-gdt
   dw 0xFFFF					; limit 15:0
   dw 0x0000					; base 15:0
   db 0x00						; base 23:16
   db 0x9A						; present, ring 0, code, readable
   db 0xCF						; 4k granular limit, 32-bit
   db 0x00						; base 31:24
   
SYS_DATA_SEL equ $-gdt
   dw 0xFFFF					; limit 15:0
   dw 0x0000					; base 15:0
   db 0x00						; base 23:16
   db 0x92						; present, ring 0, data, writable
   db 0xCF						; 4k granular limit, 32-bit
   db 0x00						; base 31:24

gdt_end:
