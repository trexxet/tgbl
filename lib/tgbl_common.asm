; TGBL common functions and macros

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
