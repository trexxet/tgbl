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

; Convert Hex to Dec ASCII
; Args: source address, destination address
; Spoils AX, BX, DX, SI, DI
%macro tgblm_hexWordToDecASCII 2
	mov si, %1
	mov di, %2
	mov ax, [si]
	call tgbl_hexToDecASCII
%endmacro
%macro tgblm_hexByteToDecASCII 2
	mov si, %1
	mov di, %2
	movzx ax, byte [si]
	call tgbl_hexToDecASCII
%endmacro
%macro setOffset 1
	cmp ax, %1
	jb .offsetSet
	inc di
%endmacro
tgbl_hexToDecASCII:
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
