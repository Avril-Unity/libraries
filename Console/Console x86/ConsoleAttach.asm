.486                        ; force 32 bit code
.model flat, stdcall        ; memory model & calling convention
option casemap :none        ; case sensitive

include windows.inc

include kernel32.inc
includelib kernel32.lib

include Console.inc


.CODE

;**************************************************************************
; ConsoleAttach
;**************************************************************************
ConsoleAttach PROC
    Invoke AttachConsole, ATTACH_PARENT_PROCESS
    ret
ConsoleAttach ENDP


END




