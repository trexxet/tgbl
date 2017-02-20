; TGBL keyboard routines

; Just to minify source code
; %1 is key name, %2 is key code
%macro tgblm_switchKey 2
	cmp ah, %2
	jne .not_%{1}_key
	call %{1}_key_handler
	jmp .end
	.not_%{1}_key:
%endmacro

; Keyboard handler
; Spoils: AH
; Uncomment the lines with needed keys,
; then write a %KEY%_key_handler function for each of them
tgbl_keyboardHandler:
	; Get key
	mov ah, 01h
	int 16h
	jz .noKey
	;switchKey A, 0x1E
	.end:
	; Clear key buffer
	xor ah, ah
	int 16h
	.noKey:
	ret
