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

; SECTOR 3 - MAIN SECTOR
main:
	call tgbl_initVGA
	tgblm_initKey KEY_S, S_key_handler
	tgblm_initKey KEY_X, X_key_handler

	tgblm_hideCursor
	tgblm_drawDoubleBorder 1, 1, scrHeight - 2, scrWidth - 2, BG_DGRAY | FG_LGRAY
	tgblm_printChar 244, BG_GREEN | FG_RED, scrHMid, 3
	tgblm_printChar 245, BG_RED | FG_GREEN, scrHMid + 1, 3
	tgblm_drawVerticalLine 1, 5, scrHeight - 2, '#', BG_DGRAY | FG_RED
	tgblm_drawHorizontalLine scrHeight - 5, 5, scrWidth - 6, '#', BG_DGRAY | FG_GREEN
	.mainLoop:
		tgblm_printString sampleText, FG_LGRAY, scrHMid, scrWMid - 5
		call tgbl_keyboardHandler
		tgblm_sleep 5
		jmp .mainLoop
	hlt

S_key_handler:
	mov byte [sampleText + 9], 's'
	ret

X_key_handler:
	mov byte [sampleText + 9], 'x'
	ret

fill 1, main

; SECTOR 5 - Constants
sampleText db "Sample Text", 0
