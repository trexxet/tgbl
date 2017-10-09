; TGBL pictures routines

; Add picture
; Args: picture name, picture file (in quotes)
%macro tgblm_addPicture 2
	%1:
		incbin %2
%endmacro

; Draw picture
; Args: picture name, upper row, left column
; Spoils: AX, CX, DX, SI, DI
%macro tgblm_drawPicture 3
	mov si, %1
	mov di, ((%2) * vramWidth) + ((%3) * 2)
	call tgbl_drawPicture
%endmacro
tgbl_drawPicture:
	mov dx, [si] ; DH contains width, DL contains height
	xor cx, cx ; CX - counter (CH - column, CL - row)
	add si, 2
	.drawLoop:
		mov ax, [si]
		test ax, ax
		jz .nextSymbol
		mov word [es:di], ax
		.nextSymbol:
		add di, 2
		add si, 2
		inc ch
		cmp ch, dh
		jb .drawLoop
		; Next line:
		add di, vramWidth
		movzx ax, dh ;
		shl ax, 1    ; DI -= DH * 2
		sub di, ax   ;
		xor ch, ch
		inc cl
		cmp cl, dl
		jb .drawLoop
	ret
