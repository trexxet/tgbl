; Set the number of sectors used by program excluding boot sector and sector with TGBL
%define NUM_OF_USER_SECTORS 2
; Set included modules
%define INCLUDE_COMMON
%define INCLUDE_GRAPHICS
%define INCLUDE_TEXT
%define INCLUDE_KEYBOARD
%define INCLUDE_TIME
; Include TGBL and launch program
%include "tgbl_main.asm"
tgblm_start main

; Your program starts here
main:
	call tgbl_initVGA               ; VGA 80x25 text mode init
	tgblm_hideCursor
	call initKeys                   ; Keyboard init
	tgblm_saveSysTimeMS timerTicks  ; Timer init

	call drawLines
	call drawText
	mov word [sampleNum], 0
	call redrawNum

	.mainLoop:
		call tgbl_keyboardHandler ; Check keyboard state
		tgblm_timer incSampleNum, t_second * 1, timerTicks ; Timer iteration
		tgblm_sleep 10 ; Sleep a bit before next main loop iteration
		jmp .mainLoop
	hlt

initKeys:
	call tgbl_clearKeyHandlersTable
	; Link handlers to keystrokes
	tgblm_initKey KEY_ESC, ESC_key_handler
	tgblm_initKey KEY_Q, Q_key_handler
	tgblm_initKey KEY_W, W_key_handler
	tgblm_initKey KEY_A, A_key_handler
	tgblm_initKey KEY_S, S_key_handler
	ret

ESC_key_handler:
	call tgbl_shutdown
	; This will never return...

Q_key_handler:
	mov byte [sampleText2 + 6], 'W'
	tgblm_printString sampleText2, FG_LGRAY, scrHMid, scrWMid - sampleText2_len / 2
	ret

W_key_handler:
	mov byte [sampleText2 + 6], 'Q'
	tgblm_printString sampleText2, FG_LGRAY, scrHMid, scrWMid - sampleText2_len / 2
	ret

A_key_handler:
	dec word [sampleNum]
	call redrawNum
	ret

incSampleNum:
S_key_handler:
	inc word [sampleNum]
	call redrawNum
	ret

redrawNum:
	; First, we have to convert number to decimal ASCII string
	tgblm_uintWordToStr sampleNum, sampleNumStr
	; Then we clear place for string
	tgblm_clearString scrHMid + 1, scrWMid - 2, 5
	; And print it
	tgblm_printString sampleNumStr, FG_LGRAY, scrHMid + 1, scrWMid - 2
	ret

drawLines:
	tgblm_drawDoubleBorder 1, 1, scrHeight - 2, scrWidth - 2, BG_LGRAY | FG_BLACK
	tgblm_printChar 244, BG_GREEN | FG_RED | BG_BLINK, scrHMid, 3
	tgblm_printChar 245, BG_RED | FG_GREEN | BG_BLINK, scrHMid + 1, 3
	tgblm_drawVerticalLine 1, 5, scrHeight - 2, '#', BG_LGRAY | FG_RED
	tgblm_drawHorizontalLine scrHeight - 5, 5, scrWidth - 6, '#', BG_LGRAY | FG_GREEN
	ret

drawText:
	tgblm_printString sampleText1, FG_LGRAY, scrHMid - 1, scrWMid -  sampleText1_len / 2
	tgblm_printString sampleText2, FG_LGRAY, scrHMid, scrWMid - sampleText2_len / 2
	tgblm_printString sampleText3, FG_LGRAY, scrHMid + 2, scrWMid -  sampleText3_len / 2
	ret

; Fills the rest of sector with zeroes
tgblm_endSector 1, main

; Constants
constSector:
tgblm_addConstString sampleText1, "Press ESC to shutdown"
tgblm_addConstString sampleText2, "Press Q to change this text"
tgblm_addConstString sampleText3, "Press A or S to change the number above manually"

tgblm_endSector 1, constSector

; Variables
section .bss
sampleNum resw 1
sampleNumStr resb 6
timerTicks resw 1
