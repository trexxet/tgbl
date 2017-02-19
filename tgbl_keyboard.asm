; Keyboard routines

; Just to minify source code
; %1 is key name, %2 is key code
%macro switchKey 2
	cmp ah, %2
	jne .not_%{1}_key
	call %{1}_key_handler
	jmp .end
	.not_%{1}_key:
%endmacro

keyboardHandler:
	; Get key
	mov ah, 01h
	int 16h
	jz .noKey
	switchKey A, 0x1E
	switchKey S, 0x1F
	switchKey W, 0x11
	switchKey D, 0x20
	switchKey J, 0x24
	switchKey K, 0x25
	switchKey I, 0x17
	switchKey L, 0x26
	switchKey N, 0x31
	switchKey F10, 0x44
	.end:
	; Clear key buffer
	xor ah, ah
	int 16h
	.noKey:
	ret

; Move cursor left:
A_key_handler:
	cmp byte [cursor_posx], 0
	jz .end
	dec byte [cursor_posx]
	call mapDraw
	call printInfo
	.end:
	ret

; Move cursor down:
S_key_handler:
	cmp byte [cursor_posy], mapHeight - 1
	je .end
	inc byte [cursor_posy]
	call mapDraw
	call printInfo
	.end:
	ret

; Move cursor up:
W_key_handler:
	cmp byte [cursor_posy], 0
	jz .end
	dec byte [cursor_posy]
	call mapDraw
	call printInfo
	.end:
	ret

; Move cursor right:
D_key_handler:
	cmp byte [cursor_posx], mapWidth - 1
	je .end
	inc byte [cursor_posx]
	call mapDraw
	call printInfo
	.end:
	ret

; Move map left
J_key_handler:
	cmp byte [map_posx], 0
	jz .end
	dec byte [map_posx]
	call mapDraw
	.end:
	ret

; Move map down
K_key_handler:
	cmp byte [map_posy], mapHeight - mapDrawHeight
	je .end
	inc byte [map_posy]
	call mapDraw
	.end:
	ret

; Move map up
I_key_handler:
	cmp byte [map_posy], 0
	jz .end
	dec byte [map_posy]
	call mapDraw
	.end:
	ret

; Move map right
L_key_handler:
	cmp byte [map_posx], mapWidth - mapDrawWidth
	je .end
	inc byte [map_posx]
	call mapDraw
	.end:
	ret

; Toggle city names
N_key_handler:
	xor byte [drawCityNames], 1
	call mapDraw
	ret

; Shutdown
F10_key_handler:
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
