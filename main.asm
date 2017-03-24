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
	tgblm_initKey KEY_ESC, ESC_key_handler
	tgblm_initKey KEY_Q, Q_key_handler
	tgblm_initKey KEY_W, W_key_handler
	tgblm_initKey KEY_A, A_key_handler
	tgblm_initKey KEY_S, S_key_handler

	tgblm_hideCursor
	tgblm_drawDoubleBorder 1, 1, scrHeight - 2, scrWidth - 2, BG_DGRAY | FG_LGRAY
	tgblm_printChar 244, BG_GREEN | FG_RED, scrHMid, 3
	tgblm_printChar 245, BG_RED | FG_GREEN, scrHMid + 1, 3
	tgblm_drawVerticalLine 1, 5, scrHeight - 2, '#', BG_DGRAY | FG_RED
	tgblm_drawHorizontalLine scrHeight - 5, 5, scrWidth - 6, '#', BG_DGRAY | FG_GREEN

	tgblm_printString sampleText1, FG_LGRAY, scrHMid - 1, scrWMid -  sampleText1len / 2
	tgblm_printString sampleText2, FG_LGRAY, scrHMid, scrWMid - sampleText2len / 2
	tgblm_printString sampleText3, FG_LGRAY, scrHMid + 2, scrWMid -  sampleText3len / 2

	mov word [sampleNum], 0
	tgblm_hexWordToDecASCII sampleNum, sampleNumStr
	tgblm_printString sampleNumStr, FG_LGRAY, scrHMid + 1, scrWMid - 2

	.mainLoop:
		call tgbl_keyboardHandler
		tgblm_sleep 5
		jmp .mainLoop
	hlt

ESC_key_handler:
	call tgbl_shutdown
	ret

Q_key_handler:
	mov byte [sampleText2 + 6], 'W'
	tgblm_printString sampleText2, FG_LGRAY, scrHMid, scrWMid - sampleText2len / 2
	ret

W_key_handler:
	mov byte [sampleText2 + 6], 'Q'
	tgblm_printString sampleText2, FG_LGRAY, scrHMid, scrWMid - sampleText2len / 2
	ret

A_key_handler:
	dec word [sampleNum]
	tgblm_hexWordToDecASCII sampleNum, sampleNumStr
	tgblm_drawHorizontalLine scrHMid + 1, scrWMid - 2, 5, 0, FG_BLACK
	tgblm_printString sampleNumStr, FG_LGRAY, scrHMid + 1, scrWMid - 2
	ret

S_key_handler:
	inc word [sampleNum]
	tgblm_hexWordToDecASCII sampleNum, sampleNumStr
	tgblm_drawHorizontalLine scrHMid + 1, scrWMid - 2, 5, 0, FG_BLACK
	tgblm_printString sampleNumStr, FG_LGRAY, scrHMid + 1, scrWMid - 2
	ret

fill 1, main

; SECTOR 5 - Constants
sector5:
sampleText1 db "Press ESC to shutdown", 0
sampleText1len equ $ - sampleText1
sampleText2 db "Press Q to change this text", 0
sampleText2len equ $ - sampleText2
sampleText3 db "Press A or S to change the number above", 0
sampleText3len equ $ - sampleText3

fill 1, sector5

; Variables
section .bss
sampleNum resw 1
sampleNumStr resb 10
