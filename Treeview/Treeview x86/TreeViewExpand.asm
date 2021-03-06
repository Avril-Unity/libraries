.486                        ; force 32 bit code
.model flat, stdcall        ; memory model & calling convention
option casemap :none        ; case sensitive

include windows.inc

include user32.inc
includelib user32.lib

include TreeView.inc

TreeViewExpandBranch        PROTO :DWORD, :DWORD


.CODE


;**************************************************************************
; 
;**************************************************************************
TreeViewRootExpand PROC PUBLIC hTreeview:DWORD
    LOCAL hRoot:DWORD

    Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_ROOT, hRoot
    .IF eax == 0
        ret
    .ENDIF
    mov hRoot, eax

    Invoke SendMessage, hTreeview, TVM_EXPAND, TVE_EXPAND, hRoot
    Invoke TreeViewBranchExpand, hTreeview, hRoot
    ;Invoke SendMessage, hTreeview, WM_SETREDRAW, FALSE, 0
    ;Invoke TreeViewExpandBranch, hTreeview, hRoot
    ;Invoke SendMessage, hTreeview, WM_SETREDRAW, TRUE, 0
    ret
TreeViewRootExpand ENDP


;**************************************************************************
; 
;**************************************************************************
TreeViewBranchExpand PROC PUBLIC hTreeview:DWORD, hItem:DWORD
    LOCAL hCurrentItem:DWORD
    
    .IF hItem == 0
        Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_ROOT, 0 
    .ELSE
        mov eax, hItem
    .ENDIF
    mov hCurrentItem, eax

    .IF eax == 0
        ret
    .ENDIF
    
    Invoke SendMessage, hTreeview, WM_SETREDRAW, FALSE, 0
    Invoke TreeViewExpandBranch, hTreeview, hCurrentItem
;    Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_CHILD, hCurrentItem
;    .WHILE eax != NULL
;        mov hCurrentItem, eax      
;        Invoke SendMessage, hTreeview, TVM_EXPAND, TVE_EXPAND, hCurrentItem
;        ;Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_NEXT, hCurrentItem
;        
;        mov eax, hCurrentItem
;        .WHILE eax != NULL        
;            Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_NEXT, hCurrentItem
;            .IF eax != NULL
;                mov hCurrentItem, eax
;                mov eax, hCurrentItem
;                .BREAK
;            .ELSE
;                 Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_PARENT, hCurrentItem
;                .IF eax != NULL ; current item has no sibling so we goto parent, check that first
;                    ;.IF eax == hItem
;                    ;    mov eax, NULL ; found original starting branch node, so exit at this point
;                    ;    .BREAK
;                    ;.ENDIF
;                    mov hCurrentItem, eax
;                    mov eax, hCurrentItem
;                    .CONTINUE ; didnt find our item in parent, so get parents sibling to check for
;                 .ELSE
;                    mov eax, NULL ; no more parents to check
;                    .BREAK
;                .ENDIF
;            .ENDIF
;            ; eax contains next sibling to check for or null (no sibling)
;        .ENDW        
;        
;    .ENDW
    Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_CARET, hCurrentItem
    Invoke SendMessage, hTreeview, TVM_SELECTITEM, TVGN_FIRSTVISIBLE, hCurrentItem
    Invoke SendMessage, hTreeview, WM_SETREDRAW, TRUE, 0
    ret
TreeViewBranchExpand ENDP


;**************************************************************************
; TreeViewExpandBranch
;**************************************************************************
TreeViewExpandBranch PROC PRIVATE hTreeview:DWORD, hItem:DWORD
    LOCAL hCurrentItem:DWORD
    mov eax, hItem
    mov hCurrentItem, eax
    Invoke SendMessage, hTreeview, TVM_EXPAND, TVE_EXPAND, hCurrentItem
    Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_CHILD, hCurrentItem
    .WHILE eax != NULL
        mov hCurrentItem, eax
        Invoke TreeViewExpandBranch, hTreeview, hCurrentItem
        Invoke SendMessage, hTreeview, TVM_GETNEXTITEM, TVGN_NEXT, hCurrentItem
    .ENDW
    ret
TreeViewExpandBranch ENDP


end

