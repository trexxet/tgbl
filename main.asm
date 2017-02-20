org 0x7C00
bits 16
section .text

; Fill sectors with zeroes
%macro fill 2
	times 512 * %1 - ($ - %2) db 0
%endmacro

; SECTOR 1 - BOOTSECTOR
%include "lib/tgbl_boot.asm"
tgblm_boot 4

; SECTOR 2 - GRAPHICAL, TEXT & TIME FUNCTIONS
sector2:
jmp main
%include "lib/tgbl_graphics.asm"
%include "lib/tgbl_text.asm"
%include "lib/tgbl_time.asm"
fill 1, sector2

; SECTOR 3 - KEYBOARD ROUTINES
sector3:
%include "lib/tgbl_keyboard.asm"
fill 1, sector3

; SECTOR 4 - MAIN SECTOR
main:
	call tgbl_initVGA
	tgblm_hideCursor
	tgblm_drawBorder 1, 1, scrHeight - 2, scrWidth - 2, '#', BG_DGRAY | FG_LGRAY
	tgblm_printChar 244, BG_GREEN | FG_RED, scrHMid, 3
	tgblm_printChar 245, BG_RED | FG_GREEN, scrHMid + 1, 3
	tgblm_printString sampleText, BG_BLACK | FG_LGRAY, scrHMid, scrWMid - 5
	.mainLoop:
		call tgbl_keyboardHandler
		tgblm_sleep 5
		jmp .mainLoop
	hlt
fill 1, main

; SECTOR 5 - Constants
sampleText db "Sample Text", 0
