%define NUM_OF_USER_SECTORS 1
%define INCLUDE_COMMON
%define INCLUDE_KEYBOARD
%define INCLUDE_TIME
; Include pictures module
%define INCLUDE_PICTURE
%include "tgbl_main.asm"
tgblm_start main

main:
	call tgbl_initVGA
	tgblm_hideCursor
	call initKeys

	.mainLoop:
		call tgbl_keyboardHandler
		tgblm_sleep 10
		jmp .mainLoop
	hlt

initKeys:
	call tgbl_clearKeyHandlersTable
	tgblm_initKey KEY_ESC, ESC_key_handler
	ret

ESC_key_handler:
	call tgbl_shutdown

tgblm_endSector 1, main

; Constants
constSector:

tgblm_endSector 1, constSector
