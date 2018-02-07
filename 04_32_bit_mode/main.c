// ====================================================================================================
// This is the main program. It just prints a character on the screen.
// This program is almost the same as the main program in Tutorial 3.
// The only difference is that there is no directive for 16-bit mode.
// This code is in 32-bit mode, which is the default.
// ====================================================================================================

int main()
{
   unsigned short *screen;
   
   screen = (unsigned short *)0xb8000;
   *screen = 'A' | (0x07 << 8);				// write character and format in video memory
   
   while (1);								// endless loop
   
   return 0;
}
