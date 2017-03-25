; TGBL text functions and macros

; Hide cursor
; Spoils: AH, CH
%macro tgblm_hideCursor 0
	mov ah, 01h
	mov ch, 0x20
	int 10h
%endmacro

; Print string
; Args: string, color, row, column
; Spoils: AX, SI, DI
%macro tgblm_printString 4
	mov si, %1
	mov ah, %2
	mov di, ((%3) * vramWidth) + ((%4) * 2)
	call tgbl_printString
%endmacro
tgbl_printString:
	mov al, [si]
	or al, al
	jz .printed
	stosw
	inc si
	jmp tgbl_printString
	.printed:
	ret

; Print one char
; Args: char, color, row, column
; Spoils: AX, DI
%macro tgblm_printChar 4
	mov al, %1
	mov ah, %2
	mov di, ((%3) * vramWidth) + ((%4) * 2)
	stosw
%endmacro

; Clear string on screen
; Args: row, column, width
; Spois: AX, DI
%macro tgblm_clearString 3
	xor ax, ax
	mov di, ((%1) * vramWidth) + ((%2) * 2)
	%%line:
		stosw
		cmp di, (%1) * vramWidth + ((%2) + (%3)) * 2
		jb %%line
%endmacro

; Convert number in memory to decimal ASCII string
; Args: source address, destination address
; Spoils AX, BX, DX, SI, DI
%macro tgblm_numWordToDecASCII 2
	mov si, %1
	mov di, %2
	mov ax, [si]
	call tgbl_numToDecASCII
%endmacro
%macro tgblm_numByteToDecASCII 2
	mov si, %1
	mov di, %2
	movzx ax, byte [si]
	call tgbl_numToDecASCII
%endmacro
%macro setOffset 1
	cmp ax, %1
	jb .offsetSet
	inc di
%endmacro
tgbl_numToDecASCII:
	; Set offset for printing
	setOffset 10
	setOffset 100
	setOffset 1000
	setOffset 10000
	.offsetSet:
	mov byte [di + 1], 0
	push di
	mov bx, 10
 	.convertLoop:
		; Divide DX:AX by BX = 10
		xor dx, dx
		div bx
		; Write modulo
		or dl, 0x30 ; ASCII
		mov [di], dl
		dec di
		or ax, ax
		jnz .convertLoop
	pop di
	ret
