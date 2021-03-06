.686
.MMX
.XMM
.x64

option casemap : none
option win64 : 11
option frame : auto
option stackbase : rsp

_WIN64 EQU 1
WINVER equ 0501h

include windows.inc
include commctrl.inc
;include user32.inc
includelib user32.lib

include TreeView.inc

.code

;**************************************************************************
; 
;**************************************************************************
TreeViewSetSelectedItem PROC FRAME hTreeview:QWORD, hItem:QWORD, bVisible:QWORD
    Invoke SendMessage, hTreeview, TVM_SELECTITEM, TVGN_CARET, hItem	
    .IF bVisible == TRUE
        Invoke SendMessage, hTreeview, TVM_SELECTITEM, TVGN_FIRSTVISIBLE, hItem
    .ENDIF
    ret
TreeViewSetSelectedItem ENDP

end