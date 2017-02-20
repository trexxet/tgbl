; TGBL time functions and macros

; Milliseconds to sleep
; Spoils: AX, CX, DX
%macro tgblm_sleep 1
	mov cx, ((%1) * 1000) / 0xFFFF
	mov dx, ((%1) * 1000) % 0xFFFF
	mov ah, 86h
	int 15h
%endmacro

; Shutdown
tgbl_shutdown:
	mov ax, 0x5301
	xor bx, bx
	int 15h
	mov ax, 0x530E
	xor bx, bx
	mov cx, 0x0102
	int 15h
	mov ax, 0x5307
	mov bx, 0x0001
	mov cx, 0x0003
	int 15h
	ret
