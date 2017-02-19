; Example bootsector

boot:
	cli
	; Overlap CS and DS to save space
	mov ax, cs
	mov ds, ax
	mov es, ax
	; Setup 4K stack
	xor ax, ax
	mov ss, ax
	mov sp, 0x7C00
	; Save disk number (DL) in stack
	xor dh, dh
	push dx
	; Setting VGA 80x25 text mode
	mov al, 0x03 ; ah == 0
	int 10h
	; Hide cursor
	mov ah, 01h
	mov ch, 0x20
	int 10h

	; Load next 3 sectors
	mov ax, 0x0203
	mov cx, 0x0002
	pop dx
	mov bx, bootend
	int 13h
	; VRAM access
	mov ax, 0xb800
	mov es, ax
	; Start
	jmp bootend

; Fill the rest of bootsector with zeroes and end it
times 510 - ($ - sector1) db 0
dw 0xAA55
bootend:
