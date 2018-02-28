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
	test al, al
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

; Convert unsigned integer in memory to decimal ASCII string
; Args: integer address, string address
; Spoils AX, BX, DX, SI, DI
%macro tgblm_uintWordToStr 2
	mov si, %1
	mov di, %2
	mov ax, [si]
	call tgbl_uintToStr
%endmacro
%macro tgblm_uintByteToStr 2
	mov si, %1
	mov di, %2
	movzx ax, byte [si]
	call tgbl_uintToStr
%endmacro
%macro tgblm_uintSetOffset 1
	cmp ax, %1
	jb .offsetSet
	inc di
%endmacro
tgbl_uintToStr:
	; Set offset for printing
	tgblm_uintSetOffset 10
	tgblm_uintSetOffset 100
	tgblm_uintSetOffset 1000
	tgblm_uintSetOffset 10000
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
		test ax, ax
		jnz .convertLoop
	pop di
	ret
