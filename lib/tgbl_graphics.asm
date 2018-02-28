; TGBL graphical functions and macros

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
	shl cx, 5
	mov di, cx
	shl di, 2
	add di, cx
	movzx cx, bl
	shl cx, 1
	add di, cx
	ret

; Draw vertical line
; Args: upper corner row, column, height, char, color
; Spoils AX, DI
%macro tgblm_drawVerticalLine 5
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
	mov al, %4
	mov ah, %5
	mov di, (%1) * vramWidth + (%2) * 2
	%%line:
		stosw
		cmp di, (%1) * vramWidth + ((%2) + (%3)) * 2
		jb %%line
%endmacro

; Draw custom char border
; Args: upper corner row, left corner column, height, width,
;	horizontal line char, vertical line char, upper left corner char,
;	upper right corner char, lower left corner char, lower right corner char, color
; Spoils AX, DI
%macro tgblm_drawCustomBorder 11
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

; Draw single-line border
; Args: upper corner row, left corner column, height, width, color
; Spoils AX, DI
%macro tgblm_drawSingleBorder 5
	tgblm_drawCustomBorder (%1), (%2), (%3), (%4), 196, 179, 218, 191, 192, 217, (%5)
%endmacro

; Draw double-line border
; Args: upper corner row, left corner column, height, width, color
; Spoils AX, DI
%macro tgblm_drawDoubleBorder 5
	tgblm_drawCustomBorder (%1), (%2), (%3), (%4), 205, 186, 201, 187, 200, 188, (%5)
%endmacro
