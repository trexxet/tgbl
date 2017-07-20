; TGBL time functions and macros

; Time periods in sysclock ticks
t_second   equ 18
t_minute   equ 1092
t_hour     equ 65543

; Sleep
; Args: milliseconds to sleep
; Spoils: AX, CX, DX
%macro tgblm_sleep 1
	mov cx, ((%1) * 1000) / 0xFFFF
	mov dx, ((%1) * 1000) % 0xFFFF
	mov ah, 86h
	int 15h
%endmacro

; Get system time (in clock ticks)
; Returns: 	CX:DX = number of clock ticks since midnight
;			AL = midnight flag, nonzero if midnight passed since time last read
; ~18.2 clock ticks per second, 0xFFFF ticks per hour
; Spoils: AH
%macro tgblm_getSysTime 0
	xor ah, ah
	int 1Ah
%endmacro
tgbl_getSysTime:
	tgblm_getSysTime
	ret

; Save system time (without hours) in word variable
; Args: address where to store ticks count (2 bytes)
; Spoils: AH, CX, DX
%macro tgblm_saveSysTimeMS 1
	tgblm_getSysTime
	mov [%1], dx
%endmacro

; Save system time (with hours) in dword variable
; Args: address where to store ticks count (4 bytes)
; Spoils: AH, CX, DX
%macro tgblm_saveSysTimeHMS 1
	tgblm_saveSysTimeMS %1
	mov [%1 + 2], cx
%endmacro


; Get number of ticks passed from last system time save
; Spoils: AH, CX, DX
; WITHOUT HOURS:
; Args: address of ticks count stored (2 bytes)
; Returns: DX = number of clock ticks since last systime save
%macro tgblm_getDeltaTimeMS 1
	tgblm_getSysTime
	sub dx, [%1]
%endmacro
; WITH HOURS:
; Args: address of ticks count stored (4 bytes)
; Returns: CX:DX = number of clock ticks since last systime save
%macro tgblm_getDeltaTimeHMS 1
	tgblm_getDeltaTimeMS %1
	sbb cx, [%1 + 2]
%endmacro

; Simple timer implementation: call X every Y ticks (Y < 0xFFFF)
; Args: function to call, period (in ticks, ~18.2 ticks per second, 0xFFFF ticks per hour),
;	address of ticks count stored
; Spoils: AH, CX, DX
%macro tgblm_timer 3
	tgblm_getDeltaTimeMS %3
	cmp dx, %2
	jb %%endIteration
	call %1
	tgblm_saveSysTimeMS %3
	%%endIteration:
%endmacro
