; TGBL bootsector

; Args: number of sectors to load
%macro tgblm_boot 1
boot:
	cli
	; Overlap CS and DS
	mov ax, cs
	mov ds, ax
	mov es, ax
	; Setup 4K stack before this bootloader
	mov ax, 0x07c0
	mov ss, ax
	mov sp, 4096
	; Load next sectors
	mov si, 0x7a00
	mov byte [si + 0], 10h
	mov byte [si + 1], 0
	mov byte [si + 2], %1
	mov byte [si + 3], 0
	mov dword [si + 4], bootend
	mov dword [si + 8], 1
	mov dword [si + 12], 0
	mov ah, 42h
	int 13h
	; Start
	jmp bootend

; Fill the rest of bootsector with zeroes and end it
times 510 - ($ - boot) db 0
dw 0xAA55
bootend:
%endmacro
