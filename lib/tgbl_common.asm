; TGBL common functions and macros

; Width and height of screen
scrHeight   equ 25
scrWidth    equ 80
scrHMid     equ 12
scrWMid     equ 40
vramWidth   equ 160

; Background colors
BG_BLACK    equ 0x00
BG_BLUE     equ 0x10
BG_GREEN    equ 0x20
BG_CYAN     equ 0x30
BG_RED      equ 0x40
BG_MAGENTA  equ 0x50
BG_BROWN    equ 0x60
BG_LGRAY    equ 0x70

BG_BLINK    equ 0x80

; Foreground colors
FG_BLACK    equ 0x00
FG_BLUE     equ 0x01
FG_GREEN    equ 0x02
FG_CYAN     equ 0x03
FG_RED      equ 0x04
FG_MAGENTA  equ 0x05
FG_BROWN    equ 0x06
FG_LGRAY    equ 0x07
FG_DGRAY    equ 0x08
FG_LBLUE    equ 0x09
FG_LGREEN   equ 0x0A
FG_LCYAN    equ 0x0B
FG_LRED     equ 0x0C
FG_LMAGENTA equ 0x0D
FG_YELLOW   equ 0x0E
FG_WHITE    equ 0x0F

; Setting VGA 80x25 text mode
; Spoils AX
tgbl_initVGA:
	mov ax, 0x0003
	int 10h
	; VRAM access
	mov ax, 0xb800
	mov es, ax
	ret

; Clear screen
; Spoils: AX, DI
%macro tgblm_clearScreen 0
	xor ax, ax
	xor di, di
	%%clrloop:
		stosw
		cmp di, vramWidth * scrHeight
		jne %%clrloop
%endmacro

; Hide cursor
; Spoils: AH, CH
%macro tgblm_hideCursor 0
	mov ah, 01h
	mov ch, 0x20
	int 10h
%endmacro

; Shutdown
tgbl_shutdown:
	mov ax, 0x5301
	xor bx, bx
	int 15h
	mov ax, 0x5307
	mov bx, 0x0001
	mov cx, 0x0003
	int 15h
	; This will never return...

; Soft reboot
%define tgblm_softReboot jmp 0FFFFh:0
