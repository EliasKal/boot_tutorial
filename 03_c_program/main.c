// =============================================================================
// This is the main program, written in C.
// It just prints a character on the screen.
// The first line is an inline assembly command which tells gcc's assembler 
// that this is 16-bit code.
// This program does the same thing as the program of 02_bootloader, only in
// C syntax.
// =============================================================================

asm(".code16\n");    // 16-bit mode

int main()
{
    unsigned short *screen;
   
    screen = (unsigned short *)0xb8000;
    *screen = 'A' | (0x07 << 8);            // character and format are written 
                                            // in video memory
   
    while (1);							    // endless loop
   
    return 0;
}

