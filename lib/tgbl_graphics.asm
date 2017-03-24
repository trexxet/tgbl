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

; Draw vertical line
; Args: upper corner row, column, height, char, color
; Spoils AX, DI
%macro tgblm_drawVerticalLine 5
%%tgblm_drawVerticalLine:
	mov al, %4
	mov ah, %5
	mov di, (%1) * vramWidth + (%2) * 2
	%%line:
		mov word [es:di], ax
		add di, vramWidth
		cmp di, ((%1) + (%3)) * vramWidth + (%2) * 2
		jb %%line
%endmacro

; Draw horizontal line
; Args: row, left corner column, width, char, color
; Spoils AX, DI
%macro tgblm_drawHorizontalLine 5
%%tgblm_drawHorizontalLine:
	mov al, %4
	mov ah, %5
	mov di, (%1) * vramWidth + (%2) * 2
	%%line:
		stosw
		cmp di, (%1) * vramWidth + ((%2) + (%3)) * 2
		jb %%line
%endmacro

; Draw custom border
; Args: upper corner row, left corner column, height, width,
;	horizontal line char, vertical line char, upper left corner,
;	upper right corner, lower left corner, lower right corner, color
; Spoils AX, DI
%macro tgblm_drawCustomBorder 11
%%tgblm_drawCustomBorder:
	mov ah, (%11)
	mov di, (%1) * vramWidth + (%2) * 2
	; Draw upper left corner
	mov al, (%7)
	stosw
	; Draw upper line
	mov al, (%5)
	%%upper:
		stosw
		cmp di, (%1) * vramWidth + ((%2) + (%4) - 1) * 2
		jb %%upper
	; Draw upper right corner
	mov al, (%8)
	mov word [es:di], ax
	; Draw lower left corner
	mov di, ((%1) + (%3) - 1) * vramWidth + (%2) * 2
	mov al, (%9)
	stosw
	; Draw lower line
	mov al, (%5)
	%%lower:
		stosw
		cmp di, ((%1) + (%3) - 1) * vramWidth + ((%2) + (%4) - 1) * 2
		jb %%lower
	; Draw lower right corner
	mov al, (%10)
	mov word [es:di], ax
	; Draw side lines
	mov al, (%6)
	mov di, ((%1) + 1) * vramWidth + (%2) * 2
	%%side:
		mov word [es:di], ax
		add di, ((%4) - 1) * 2
		mov word [es:di], ax
		add di, vramWidth - ((%4) - 1) * 2
		cmp di, ((%1) + (%3) - 2) * vramWidth + ((%2) + (%4)) * 2
		jb %%side
%endmacro

; Draw self border
; Args: upper corner row, left corner column, height, width, char, color
; Spoils AX, DI
%macro tgblm_drawSelfBorder 6
	tgblm_drawCustomBorder (%1), (%2), (%3), (%4), (%5), (%5), (%5), (%5), (%5), (%5), (%6)
%endmacro

; Draw single border
; Args: upper corner row, left corner column, height, width, color
; Spoils AX, DI
%macro tgblm_drawSingleBorder 5
	tgblm_drawCustomBorder (%1), (%2), (%3), (%4), 196, 179, 218, 191, 192, 217, (%5)
%endmacro

; Draw double border
; Args: upper corner row, left corner column, height, width, color
; Spoils AX, DI
%macro tgblm_drawDoubleBorder 5
	tgblm_drawCustomBorder (%1), (%2), (%3), (%4), 205, 186, 201, 187, 200, 188, (%5)
%endmacro
