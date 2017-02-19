org 0x7C00
bits 16
section .text

; Fill sectors with zeroes
%macro fill 2
	times 512 * %1 - ($ - %2) db 0
%endmacro

; SECTOR 1 - BOOTSECTOR
%include "bootsector.asm"

; SECTOR 2 - MAIN SECTOR
main:
	call init
	.mainLoop:
		call keyboardHandler
		sleep 5
		jmp .mainLoop
	hlt

fill 1, sector2

; SECTOR 3 - GRAPHICAL FUNCTIONS
%include "tgbl_graphics.asm"

; SECTOR 4 - KEYBOARD ROUTINES
%include "tgbl_keyboard.asm"
