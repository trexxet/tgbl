; TGBL bootsector

; Args: number of sectors to load
%macro tgblm_boot 1

BPB:
	jmp boot
    times 3 - ($ - BPB) db 0x90   ; Support 2 or 3 byte encoded JMPs before BPB.

    ; Dos 3.4 EBPB 1.44MB floppy
    OEMname:           db    "mkfs.fat"  ; mkfs.fat is what OEMname mkdosfs uses
    bytesPerSector:    dw    512
    sectPerCluster:    db    1
    reservedSectors:   dw    1
    numFAT:            db    2
    numRootDirEntries: dw    224
    numSectors:        dw    2880
    mediaType:         db    0xf0
    numFATsectors:     dw    9
    sectorsPerTrack:   dw    18
    numHeads:          dw    2
    numHiddenSectors:  dd    0
    numSectorsHuge:    dd    0
    driveNum:          db    0
    reserved:          db    0
    signature:         db    0x29
    volumeID:          dd    0x2d7e5a1a
    volumeLabel:       db    "NO NAME    "
    fileSysType:       db    "FAT12   "

boot:
	cli
	; Overlap CS and DS
	xor ax, ax
	mov ds, ax
	mov es, ax
	; Setup stack before this bootloader
	mov ss, ax
	mov sp, 0x7c00
	; Load next sectors
	mov si, DAP
	mov ah, 42h
	int 13h
	; Start
	jmp bootend

; Disk address packet
DAP:
	db 10h, 0
	dw %1
	dd bootend
	dq 1

; Fill the rest of bootsector with zeroes and end it
times 510 - ($ - BPB) db 0
dw 0xAA55
bootend:
%endmacro
