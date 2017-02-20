; TGBL graphical functions and macros

; Width and height of screen
scrHeight	equ 25
scrWidth	equ 80
scrHMid		equ 12
scrWMid		equ 40
vramWidth 	equ 160

; Background colors
BG_BLACK	equ 0x00
BG_BLUE		equ 0x10
BG_GREEN	equ 0x20
BG_CYAN		equ 0x30
BG_RED		equ 0x40
BG_MAGENTA	equ 0x50
BG_BROWN	equ 0x60
BG_LGRAY	equ 0x70
BG_DGRAY	equ 0x80
BG_LBLUE	equ 0x90
BG_LGREEN	equ 0xA0
BG_LCYAN	equ 0xB0
BG_LRED		equ 0xC0
BG_LMAGENTA	equ 0xD0
BG_YELLOW	equ 0xE0
BG_WHITE	equ 0xF0

; Foreground colors
FG_BLACK	equ 0x00
FG_BLUE		equ 0x01
FG_GREEN	equ 0x02
FG_CYAN		equ 0x03
FG_RED		equ 0x04
FG_MAGENTA	equ 0x05
FG_BROWN	equ 0x06
FG_LGRAY	equ 0x07
FG_DGRAY	equ 0x08
FG_LBLUE	equ 0x09
FG_LGREEN	equ 0x0A
FG_LCYAN	equ 0x0B
FG_LRED		equ 0x0C
FG_LMAGENTA	equ 0x0D
FG_YELLOW	equ 0x0E
FG_WHITE	equ 0x0F

; Setting VGA 80x25 text mode
; Spoils AX
tgbl_initVGA:
	mov ax, 0x0003
	int 10h
	; VRAM access
	mov ax, 0xb800
	mov es, ax
	ret

; Get VRAM address of the symbol
; Args: row, column
; Returns DI = BH * 160 + BL * 2
; Spoils CX
%macro tgblm_getVRAMAddr 2
	mov bh, %1
	mov bl, %2
	call tgbl_getVRAMAddr
%endmacro
tgbl_getVRAMAddr:
	; 160 = 128 + 32
	movzx cx, bh
	shl cx, 7
	movzx di, bh
	shl di, 5
	add di, cx
	movzx cx, bl
	shl cx, 1
	add di, cx
	ret

; Draw border
; Args: upper corner row, left corner column, height, width, char, color
; Spoils AX, DI
%macro tgblm_drawBorder 6
_tgblm_drawBorder:
	mov al, %5
	mov ah, %6
	mov di, (%1) * vramWidth + (%2) * 2
	; Draw top line
	.top:
		stosw
		cmp di, (%1) * vramWidth + ((%2) + (%4)) * 2
		jb .top
	; Draw bottom line
	mov di, ((%1) + (%3) - 1) * vramWidth + (%2) * 2
	.bottom:
		stosw
		cmp di, ((%1) + (%3) - 1) * vramWidth + ((%2) + (%4)) * 2
		jb .bottom
	; Draw side lines
	mov di, ((%1) + 1) * vramWidth + (%2) * 2
	.side:
		mov word [es:di], ax
		add di, ((%4) - 1) * 2
		mov word [es:di], ax
		add di, vramWidth - ((%4) - 1) * 2
		cmp di, ((%1) + (%3) - 2) * vramWidth + ((%2) + (%4)) * 2
		jb .side
%endmacro
