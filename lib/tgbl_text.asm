; TGBL text functions and macros

; Add constant string
; Args: name, string (w/o 0-terminator)
; Creates a name string and a name_len constant containig the length of string
%macro tgblm_addConstString 2
	%1 db %2, 0
	%1_len equ $ - %1
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
; Spoils: AX, DI
%macro tgblm_clearString 3
	xor ax, ax
	mov di, ((%1) * vramWidth) + ((%2) * 2)
	%%line:
		stosw
		cmp di, (%1) * vramWidth + ((%2) + (%3)) * 2
		jb %%line
%endmacro

; Convert integer in memory to decimal ASCII string
; Args: integer address, string address
; Spoils AX, BX, DX, SI, DI
%macro tgblm_intWordToStr 2
	mov si, %1
	mov di, %2
	mov ax, [si]
	call tgbl_intToStr
%endmacro
%macro tgblm_intByteToStr 2
	mov si, %1
	mov di, %2
	movzx ax, byte [si]
	call tgbl_intToStr
%endmacro
%macro setOffset 1
	cmp ax, %1
	jb .offsetSet
	inc di
%endmacro
tgbl_intToStr:
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
