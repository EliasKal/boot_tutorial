; ====================================================================================================
; This small program prepares an environment for the main program, written in C.
; Here it sets up a simple stack by initializing the stack pointer. Then main is called.
; In this program there is no [ORG] directive.
; The code's starting address (0x8000, as defined in bootloader.asm) is given as 
; a parameter to the linker, when start and main are linked together (see create_image.sh).
; ====================================================================================================

[BITS 16]				; 16-bit mode
		
global start			; start is declared global, so that the linker can see it
start:
   mov sp, 0xa000		; this is where stack starts (grows downwards)
   
extern main				; main is declared extern, as it is defined in another file
   jmp main				; call main
