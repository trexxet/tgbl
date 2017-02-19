; Graphical functions and macros

; Width and height of screen
scrWidth equ 80
scrHeight equ 25
vramWidth equ 160

; Milliseconds to sleep
; Spoils: AX, CX, DX
%macro sleep 1
	mov cx, ((%1) * 1000) / 0xFFFF
	mov dx, ((%1) * 1000) % 0xFFFF
	mov ah, 86h
	int 15h
%endmacro

; DI = BH * 160 + BL * 2
; Spoils CX
getVRAMAddr:
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

; String, color, row, column
; Spoils: AX, SI, DI
%macro printString 4
	mov si, %1
	mov ah, %2
	mov di, ((%3) * vramWidth) + ((%4) * 2)
	call _printString
%endmacro
_printString:
	mov al, [si]
	or al, al
	jz .printed
	stosw
	inc si
	jmp _printString
	.printed:
	ret

; Char, color, row, column
; Spoils: AX, DI
%macro printChar 4
	mov al, %1
	mov ah, %2
	mov di, ((%3) * vramWidth) + ((%4) * 2)
	mov [es:di], ax
%endmacro

; Convert Hex to Dec ASCII
; Source address, destination address
%macro hexWordToDecASCII 2
	mov si, %1
	mov di, %2
	mov ax, [si]
	call _hexToDecASCII
%endmacro
%macro hexByteToDecASCII 2
	mov si, %1
	mov di, %2
	movzx ax, byte [si]
	call _hexToDecASCII
%endmacro
%macro setOffset 1
	cmp ax, %1
	jb .offsetSet
	inc di
%endmacro
_hexToDecASCII:
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

; Draw border
%macro createBorder 0
	mov ax, borderChar
	; Draw top line
	xor di, di
	.top:
		stosw
		cmp di, vramWidth
		jb .top
	; Draw bottom line
	mov di, vramWidth * (scrHeight - 1)
	.bottom:
		stosw
		cmp di, vramWidth * scrHeight
		jb .bottom
	; Draw side lines
	mov di, vramWidth
	.side:
		mov word [es:di], ax
		add di, vramWidth - 2
		stosw
		cmp di, vramWidth * (scrHeight - 1)
		jb .side
	printString header, borderColor, 0, (scrWidth - lHeader) / 2
%endmacro
