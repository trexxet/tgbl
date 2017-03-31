; TGBL keyboard routines

; Set keystroke handler
; Args: key, handler
%macro tgblm_initKey 2
	mov word [tgbl_kbd_table + (%1) * 2], (%2)
%endmacro

; Keyboard handler
; Spoils: AH, BX
; Uncomment the lines with needed keys,
; then write a %KEY%_key_handler function for each of them
tgbl_keyboardHandler:
	; Get key
	mov ah, 01h
	int 16h
	jz .noKey
	; Get handler
	movzx bx, ah
	shl bx, 1
	add bx, tgbl_kbd_table
	mov bx, [bx]
	; If handler exists, call it
	test bx, bx
	jz .end
	call bx
	.end:
	; Clear key buffer
	xor ah, ah
	int 16h
	.noKey:
	ret

; Keystroke handlers table pointer
tgbl_kbd_table equ 0x6b54	; 0x7c00 - 4096 bytes stack - 2 * 0x86

; Keyboard scan codes
KEY_A           equ 0x1E
KEY_B           equ 0x30
KEY_C           equ 0x2E
KEY_D           equ 0x20
KEY_E           equ 0x12
KEY_F           equ 0x21
KEY_G           equ 0x22
KEY_H           equ 0x23
KEY_I           equ 0x17
KEY_J           equ 0x24
KEY_K           equ 0x25
KEY_L           equ 0x26
KEY_M           equ 0x32
KEY_N           equ 0x31
KEY_O           equ 0x18
KEY_P           equ 0x19
KEY_Q           equ 0x10
KEY_R           equ 0x13
KEY_S           equ 0x1F
KEY_T           equ 0x14
KEY_U           equ 0x16
KEY_V           equ 0x2F
KEY_W           equ 0x11
KEY_X           equ 0x2D
KEY_Y           equ 0x15
KEY_Z           equ 0x2C
KEY_1           equ 0x02
KEY_2           equ 0x03
KEY_3           equ 0x04
KEY_4           equ 0x05
KEY_5           equ 0x06
KEY_6           equ 0x07
KEY_7           equ 0x08
KEY_8           equ 0x09
KEY_9           equ 0x0A
KEY_0           equ 0x0B
KEY_MINUS       equ 0x0C
KEY_EQUAL       equ 0x0D
KEY_SQBRKT_OP   equ 0x1A
KEY_SQBRKT_CL   equ 0x1B
KEY_SEMICOLON   equ 0x27
KEY_APOSTROPH   equ 0x28
KEY_GRAVIS      equ 0x29
KEY_BACKSLASH   equ 0x2B
KEY_COMMA       equ 0x33
KEY_DOT         equ 0x34
KEY_SLASH       equ 0x35
KEY_F1          equ 0x3B
KEY_F2          equ 0x3C
KEY_F3          equ 0x3D
KEY_F4          equ 0x3E
KEY_F5          equ 0x3F
KEY_F6          equ 0x40
KEY_F7          equ 0x41
KEY_F8          equ 0x42
KEY_F9          equ 0x43
KEY_F10         equ 0x44
KEY_F11         equ 0x85
KEY_F12         equ 0x86
KEY_BKSP        equ 0x0E
KEY_DEL         equ 0x53
KEY_DOWN_ARR    equ 0x50
KEY_END         equ 0x4F
KEY_ENTER       equ 0x1C
KEY_ESC         equ 0x01
KEY_HOME        equ 0x47
KEY_INS         equ 0x52
KEY_KPD_5       equ 0x4C
KEY_KPD_MUL     equ 0x37
KEY_KPD_MINUS   equ 0x4A
KEY_KPD_PLUS    equ 0x4E
KEY_KPD_SLASH   equ 0x35
KEY_LEFT_ARR    equ 0x4B
KEY_PGDN        equ 0x51
KEY_PGUP        equ 0x49
KEY_RIGHT_ARR   equ 0x4D
KEY_SPACE       equ 0x39
KEY_TAB         equ 0x0F
KEY_UP_ARR      equ 0x48
