; TGBL main file
; Include it at the beginning of your program

; Fill sectors with zeroes
; Args: number of sectors, beginning of sectors to be filled
%macro tgblm_endSector 2
	times 512 * %1 - ($ - %2) db 0
%endmacro

; Include modules macro
; List of included modules is configured by INCLUDE_MODULE defines
; Number of loaded sector is configured by NUM_OF_USER_SECTORS define
; Args: user program start label
%macro tgblm_start 1
	org 0x7C00
	bits 16
	section .text

	; SECTOR 1 - BOOTSECTOR
	%include "lib/tgbl_boot.asm"
	tgblm_boot NUM_OF_USER_SECTORS + 3

	; SECTOR 2 - GRAPHICAL, TEXT & TIME FUNCTIONS
	sector2:
	jmp %1
	%ifdef INCLUDE_GRAPHICS
		%include "lib/tgbl_graphics.asm"
	%endif
	%ifdef INCLUDE_TEXT
		%include "lib/tgbl_text.asm"
	%endif
	%ifdef INCLUDE_TIME
		%include "lib/tgbl_time.asm"
	%endif
	tgblm_endSector 1, sector2

	; SECTOR 3 - KEYBOARD ROUTINES
	%ifdef INCLUDE_KEYBOARD
	sector3:
		%include "lib/tgbl_keyboard.asm"
	tgblm_endSector 1, sector3
	%endif
%endmacro
