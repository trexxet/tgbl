; TGBL common functions and macros

; Setting VGA 80x25 text mode
; Spoils AX
tgbl_initVGA:
	mov ax, 0x0003
	int 10h
	; VRAM access
	mov ax, 0xb800
	mov es, ax
	ret

; Hide cursor
; Spoils: AH, CH
%macro tgblm_hideCursor 0
	mov ah, 01h
	mov ch, 0x20
	int 10h
%endmacro

; Shutdown
tgbl_shutdown:
	mov ax, 0x5301
	xor bx, bx
	int 15h
	mov ax, 0x5307
	mov bx, 0x0001
	mov cx, 0x0003
	int 15h
	; This will never return...

; Soft reboot
%define tgblm_softReboot jmp 0FFFFh:0
