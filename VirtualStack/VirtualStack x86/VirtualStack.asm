.686
.MMX
.XMM
.model flat,stdcall
option casemap:none
include \masm32\macros\macros.asm

;DEBUG32 EQU 1

IFDEF DEBUG32
    PRESERVEXMMREGS equ 1
    includelib M:\Masm32\lib\Debug32.lib
    DBG32LIB equ 1
    DEBUGEXE textequ <'M:\Masm32\DbgWin.exe'>
    include M:\Masm32\include\debug32.inc
ENDIF

include windows.inc

include user32.inc
includelib user32.lib

include kernel32.inc
includelib kernel32.lib

include VirtualStack.inc


_VirtualStackAddToUniqueList        PROTO :DWORD, :DWORD


IFNDEF STACK
STACK                       STRUCT
    StackMaxHeight          DD 0
    StackMaxDepth           DD 0
    StackPointer            DD 0
    StackNoItems            DD 0
    StackData               DD 0
    StackUniqueMaxHeight    DD 0
    StackUniqueNoItems      DD 0
    StackUniqueData         DD 0
STACK                       ENDS
ENDIF

.CODE

;-----------------------------------------------------------------------------------------
; VirtualStackCreate. Returns hVirtualStack in eax if succesful or NULL if failed. 
; dwStackSize is the size (max amount of stack items) to create on the virtual stack
;-----------------------------------------------------------------------------------------
VirtualStackCreate PROC USES EBX dwStackSize:DWORD, dwStackOptions:DWORD
    LOCAL nSize:DWORD
    LOCAL hStack:DWORD
    LOCAL hStackData:DWORD
    
    ; Create virtual stack
    Invoke GlobalAlloc, GMEM_FIXED+GMEM_ZEROINIT, SIZEOF STACK
    .IF eax == NULL
        ret
    .ENDIF
    mov hStack, eax

    ; Assign max height to virtual stack and calc space required for stack data size
    .IF dwStackSize == NULL
        mov ebx, VIRTUALSTACK_SIZE_MEDIUM
    .ELSE
        mov ebx, dwStackSize
    .ENDIF
    mov [eax].STACK.StackMaxHeight, ebx    
    mov eax, SIZEOF DWORD
    mul ebx
    mov nSize, eax
    
    ; Alloc space for stack data size
    Invoke GlobalAlloc, GMEM_FIXED+GMEM_ZEROINIT, nSize
    .IF eax == NULL
        Invoke GlobalFree, hStack
        mov eax, NULL
        ret
    .ENDIF
    mov hStackData, eax
    
    ; Store information into virtual stack header struct
    mov ebx, hStack
    mov [ebx].STACK.StackData, eax
    mov [ebx].STACK.StackPointer, -1
    mov [ebx].STACK.StackNoItems, 0
    mov [ebx].STACK.StackMaxDepth, 0
    mov [ebx].STACK.StackUniqueMaxHeight, 0 ; use StackUniqueSize to check if user specified this option later in VirtualStackPush (>0)
    
    ; Create unique list of stack items if option is specified
    mov eax, dwStackOptions
    .IF eax == VIRTUALSTACK_OPTION_UNIQUE
        mov eax, nSize
        shl eax, 4d ; x16
        ;mov ebx, 2d ; set size of unique list to 2 x existing virtual stack size
        ;mul ebx
        mov nSize, eax
        Invoke GlobalAlloc, GMEM_FIXED+GMEM_ZEROINIT, nSize
        .IF eax != NULL
            mov ebx, hStack
            mov [ebx].STACK.StackUniqueData, eax
            ;mov eax, nSize
            mov eax, [ebx].STACK.StackMaxHeight
            shl eax, 4d ; x16
            mov [ebx].STACK.StackUniqueMaxHeight, eax
        .ENDIF
    .ENDIF
    
    mov eax, hStack 

    ret
VirtualStackCreate ENDP


;-----------------------------------------------------------------------------------------
; VirtualStackDelete. Deletes a virtual stack
;
; lpdwVirtualDeleteCallbackProc is address of callback (optional)
; Callback is defined as having following parameters:
; <VirtualDeleteCallbackProc> hVirtualStack:DWORD, ptrStackItem:DWORD
; Consider the callback experimental for the moment.
; Calls VirtualDeleteCallbackProc with only unique items in stack
; so user can free up resources allocated
;
;-----------------------------------------------------------------------------------------
VirtualStackDelete PROC USES EBX hVirtualStack:DWORD, lpdwVirtualDeleteCallbackProc:DWORD
    LOCAL nStackMaxDepth:DWORD
    LOCAL hStackData:DWORD
    LOCAL hStackUniqueData:DWORD
    LOCAL nStackUniqueNoItems:DWORD
    LOCAL hStackUniqueItem:DWORD
    LOCAL nStackUniqueItem:DWORD
    
    ;LOCAL nChkStackItem:DWORD
    ;LOCAL bUniqueStackItem:DWORD
    
    .IF hVirtualStack == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF
    
    .IF lpdwVirtualDeleteCallbackProc == NULL    
    
        mov ebx, hVirtualStack
        mov eax, [ebx].STACK.StackData
        .IF eax != NULL
            Invoke GlobalFree, eax
        .ENDIF
        mov eax, [ebx].STACK.StackUniqueData
        .IF eax != NULL
            Invoke GlobalFree, eax
        .ENDIF        
        mov eax, hVirtualStack
        Invoke GlobalFree, eax
        
    .ELSE    
        
        
        ; load up unique list if its not 0 and loop through items
        mov ebx, hVirtualStack
        mov eax, [ebx].STACK.StackUniqueNoItems
        .IF sdword ptr eax > 0 ; if there is unique stack items to process
            mov nStackUniqueNoItems, eax
            mov eax, [ebx].STACK.StackUniqueData
            mov hStackUniqueData, eax        
            
            mov nStackUniqueItem, 0
            mov eax, 0
            .WHILE eax < nStackUniqueNoItems
                mov eax, nStackUniqueItem
                mov ebx, hStackUniqueData
                mov eax, [ebx+eax*4]
                .IF eax != NULL
                    push eax
                    push hVirtualStack
                    call lpdwVirtualDeleteCallbackProc
                .ENDIF
                
                inc nStackUniqueItem
                mov eax, nStackUniqueItem
            .ENDW
        .ENDIF
        
        mov ebx, hVirtualStack
        mov eax, [ebx].STACK.StackData
        .IF eax != NULL
            Invoke GlobalFree, eax
        .ENDIF
        mov eax, [ebx].STACK.StackUniqueData
        .IF eax != NULL
            Invoke GlobalFree, eax
        .ENDIF        
        mov eax, hVirtualStack
        Invoke GlobalFree, eax      
        
    .ENDIF
    
    mov eax, TRUE
    ret

VirtualStackDelete endp


;-----------------------------------------------------------------------------------------
; VirtualStackPush. eax returns TRUE if succesful or FALSE otherwise. dwPushValue is the 
; value to 'push' onto the virtual stack
;-----------------------------------------------------------------------------------------
VirtualStackPush PROC USES EBX hVirtualStack:DWORD, dwPushValue:DWORD
    LOCAL hStackData:DWORD
    LOCAL nStackNoItems:DWORD
    LOCAL nStackMaxHeight:DWORD
    LOCAL nStackMaxDepth:DWORD
    LOCAL nStackPointer:DWORD
    
    .IF hVirtualStack == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF
    
    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackData
    mov hStackData, eax
    mov eax, [ebx].STACK.StackPointer
    mov nStackPointer, eax    
    mov eax, [ebx].STACK.StackMaxHeight
    mov nStackMaxHeight, eax
    mov eax, [ebx].STACK.StackMaxDepth
    mov nStackMaxDepth, eax
    mov eax, [ebx].STACK.StackNoItems
    inc eax
    mov nStackNoItems, eax
    .IF eax > nStackMaxHeight
        mov eax, VIRTUALSTACK_STACKFULL
        ret
    .ENDIF
    
   
;    inc nStackPointer
;    mov eax, nStackPointer
;    mov ebx, SIZEOF DWORD
;    mul ebx
;    mov ebx, hStackData
;    add ebx, eax
;    mov eax, dwPushValue
;    mov [ebx], eax ; save value to stack item address
    
    inc nStackPointer
    mov eax, nStackPointer
    mov ebx, hStackData
    lea eax, [ebx+eax*4] ; current stack item address in eax
    mov ebx, eax
    mov eax, dwPushValue
    mov [ebx], eax ; save value to stack item address
    
    ; Add value to unique list
    Invoke _VirtualStackAddToUniqueList, hVirtualStack, dwPushValue
    .IF eax == VIRTUALSTACK_UNIQUEFULL
        mov eax, VIRTUALSTACK_UNIQUEFULL
        ret
    .ENDIF
    
    ; save pointer and item count back to stack header
    mov ebx, hVirtualStack
    mov eax, nStackPointer 
    mov [ebx].STACK.StackPointer, eax
    mov eax, nStackNoItems   
    mov [ebx].STACK.StackNoItems, eax
    .IF eax > nStackMaxDepth
        mov [ebx].STACK.StackMaxDepth, eax
    .ENDIF    

    mov eax, TRUE

    ret
VirtualStackPush ENDP


;-----------------------------------------------------------------------------------------
; VirtualStackPop. eax returns TRUE if succesful and lpdwPopValue contains the 'popped'
; value from the virtual stack, or FALSE otherwise. If stack is empty (no more items on it)
; then eax returns -1
;-----------------------------------------------------------------------------------------
VirtualStackPop PROC USES EBX hVirtualStack:DWORD, lpdwPopValue:DWORD
    LOCAL hStackData:DWORD
    LOCAL nStackNoItems:DWORD
    LOCAL nStackPointer:DWORD
    
    .IF hVirtualStack == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF

    ;.IF lpdwPopValue == NULL
    ;    xor eax, eax ; FALSE
    ;    ret
    ;.ENDIF

    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackData
    mov hStackData, eax
    mov eax, [ebx].STACK.StackPointer
    mov nStackPointer, eax    
    mov eax, [ebx].STACK.StackNoItems
    mov nStackNoItems, eax
    
    .IF nStackNoItems == 0
        mov eax, VIRTUALSTACK_STACKEMPTY ; stack empty    
        ret
    .ENDIF

;    .IF lpdwPopValue != NULL ; in case user wants to pop stack and not care about value ?
;        mov eax, nStackPointer
;        mov ebx, SIZEOF DWORD
;        mul ebx
;        mov ebx, hStackData
;        add ebx, eax
;        mov eax, [ebx]
;        mov ebx, lpdwPopValue
;        mov [ebx], eax ; save current stack item value to pop address variable
;    .ENDIF
    
    .IF lpdwPopValue != NULL ; in case user wants to pop stack and not care about value ?
        mov eax, nStackPointer
        mov ebx, hStackData
        mov eax, [ebx+eax*4] ; current stack item value in eax
        mov ebx, lpdwPopValue
        mov [ebx], eax ; save current stack item value to pop address variable
    .ENDIF
    
;    ; reset data at stack item to null
;    mov eax, nStackPointer
;    mov ebx, hStackData
;    lea eax, [ebx+eax*4] ; current stack item address in eax
;    mov ebx, eax
;    mov eax, NULL
;    mov [ebx], eax ; save value to stack item address    
    
    ; save pointer and item count back to stack header
    dec nStackPointer
    dec nStackNoItems
    mov ebx, hVirtualStack
    mov eax, nStackPointer 
    mov [ebx].STACK.StackPointer, eax
    mov eax, nStackNoItems   
    mov [ebx].STACK.StackNoItems, eax

    mov eax, TRUE
    
    ret
VirtualStackPop ENDP


;-----------------------------------------------------------------------------------------
; VirtualStackPeek. eax returns TRUE if succesful and lpdwPeekValue contains the 'peeked'
; value from the virtual stack, or FALSE otherwise. If stack is empty (no more items on it)
; then eax returns -1
;-----------------------------------------------------------------------------------------
VirtualStackPeek PROC USES EBX hVirtualStack:DWORD, lpdwPeekValue:DWORD
    LOCAL hStackData:DWORD
    LOCAL nStackNoItems:DWORD
    LOCAL nStackPointer:DWORD
    
    .IF hVirtualStack == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF

    .IF lpdwPeekValue == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF

    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackData
    mov hStackData, eax
    mov eax, [ebx].STACK.StackPointer
    mov nStackPointer, eax    
    mov eax, [ebx].STACK.StackNoItems
    mov nStackNoItems, eax
    
    .IF nStackNoItems == 0
        mov eax, VIRTUALSTACK_STACKEMPTY ; stack empty    
        ret
    .ENDIF

;    mov eax, nStackPointer
;    mov ebx, SIZEOF DWORD
;    mul ebx
;    mov ebx, hStackData
;    add ebx, eax    
;    mov eax, [ebx]
;    mov ebx, lpdwPeekValue
;    mov [ebx], eax ; save current stack item value to pop address variable
    
    mov eax, nStackPointer
    mov ebx, hStackData
    mov eax, [ebx+eax*4] ; current stack item value in eax
    mov ebx, lpdwPeekValue
    mov [ebx], eax ; save current stack item value to pop address variable

    mov eax, TRUE

    ret

VirtualStackPeek endp


;-----------------------------------------------------------------------------------------
; VirtualStackPeer. eax returns TRUE if succesful and lpdwPeerValue contains the 'peered'
; value (peek +1 stack item), from the virtual stack, or FALSE otherwise. 
; If stack is empty (no more items on it) then eax returns -1
;-----------------------------------------------------------------------------------------
VirtualStackPeer PROC USES EBX hVirtualStack:DWORD, lpdwPeerValue:DWORD
    LOCAL hStackData:DWORD
    LOCAL nStackNoItems:DWORD
    LOCAL nStackPointer:DWORD
    LOCAL nStackMaxHeight:DWORD
    
    .IF hVirtualStack == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF

    .IF lpdwPeerValue == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF

    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackData
    mov hStackData, eax
    mov eax, [ebx].STACK.StackPointer
    mov nStackPointer, eax
    mov eax, [ebx].STACK.StackMaxHeight
    mov nStackMaxHeight, eax
    mov eax, [ebx].STACK.StackNoItems
    mov nStackNoItems, eax
    
    .IF nStackNoItems == 0
        mov eax, VIRTUALSTACK_STACKEMPTY ; stack empty    
        ret
    .ELSE
        mov eax, nStackNoItems
        inc eax
        .IF eax > nStackMaxHeight
            mov eax, VIRTUALSTACK_STACKFULL
            ret
        .ENDIF        
    .ENDIF

;    mov eax, nStackPointer
;    mov ebx, SIZEOF DWORD
;    mul ebx
;    mov ebx, hStackData
;    add ebx, eax    
;    mov eax, [ebx]
;    mov ebx, lpdwPeerValue
;    mov [ebx], eax ; save current stack item value to pop address variable
    
    mov eax, nStackPointer
    inc eax ; peer = peek plus one
    mov ebx, hStackData
    mov eax, [ebx+eax*4] ; current stack item value in eax
    mov ebx, lpdwPeerValue
    mov [ebx], eax ; save current stack item value to pop address variable

    mov eax, TRUE

    ret

VirtualStackPeer endp


;-----------------------------------------------------------------------------------------
; VirtualStackZero. Zeros the entire stack and resets it back to 0, clearing all data
;-----------------------------------------------------------------------------------------
VirtualStackZero PROC USES EBX hVirtualStack:DWORD
    LOCAL nSize:DWORD
    
    .IF hVirtualStack == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF
    
    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackNoItems
    .IF eax == 0 ; nStackNoItems
        mov eax, TRUE ; stack already empty
        ret
    .ENDIF

    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackMaxHeight 
    .IF sdword ptr eax > 0
        mov ebx, SIZEOF DWORD
        mul ebx
        mov nSize, eax
        
        mov ebx, hVirtualStack
        mov eax, [ebx].STACK.StackData
        
        .IF nSize != 0 && eax != NULL
            Invoke RtlZeroMemory, eax, nSize
        .ENDIF
    .ENDIF

    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackUniqueMaxHeight
    .IF sdword ptr eax > 0
        mov ebx, SIZEOF DWORD
        mul ebx
        mov nSize, eax
        
        mov ebx, hVirtualStack
        mov eax, [ebx].STACK.StackUniqueData

        .IF nSize != 0 && eax != NULL
            Invoke RtlZeroMemory, eax, nSize
        .ENDIF        
    .ENDIF
    
    mov ebx, hVirtualStack
    mov [ebx].STACK.StackPointer, -1
    mov [ebx].STACK.StackNoItems, 0
    mov [ebx].STACK.StackMaxDepth, 0
    mov [ebx].STACK.StackUniqueNoItems, 0
    
    
    mov eax, TRUE
    ret
VirtualStackZero ENDP


;-----------------------------------------------------------------------------------------
; VirtualStackCount. eax returns number of items on the stack
;-----------------------------------------------------------------------------------------
VirtualStackCount PROC USES EBX hVirtualStack:DWORD
    .IF hVirtualStack == NULL
        xor eax, eax ; 0
        ret
    .ENDIF
    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackNoItems
    ret
VirtualStackCount ENDP


;-----------------------------------------------------------------------------------------
; VirtualStackUniqueCount. eax returns number of unique items on the stack
;-----------------------------------------------------------------------------------------
VirtualStackUniqueCount PROC USES EBX hVirtualStack:DWORD
    .IF hVirtualStack == NULL
        xor eax, eax ; 0
        ret
    .ENDIF
    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackUniqueNoItems
    dec eax ; as unique is
    ret
VirtualStackUniqueCount ENDP


;-----------------------------------------------------------------------------------------
; VirtualStackCount. eax returns size of virtual stack (max number of items) on the stack
;-----------------------------------------------------------------------------------------
VirtualStackSize PROC USES EBX hVirtualStack:DWORD
    .IF hVirtualStack == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF
    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackMaxHeight
    ret
VirtualStackSize ENDP


;-----------------------------------------------------------------------------------------
; VirtualStackDepth. eax returns max depth of virtual stack (max number of items ever) on the stack
;-----------------------------------------------------------------------------------------
VirtualStackDepth PROC USES EBX hVirtualStack:DWORD
    .IF hVirtualStack == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF
    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackMaxDepth
    ret
VirtualStackDepth ENDP


;-----------------------------------------------------------------------------------------
; VirtualStackData. eax returns pointer to StackData
;-----------------------------------------------------------------------------------------
VirtualStackData PROC USES EBX hVirtualStack:DWORD
    LOCAL hStackData:DWORD
    .IF hVirtualStack == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF
    
    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackData
    
    ;.IF eax == NULL
    ;    xor eax, eax
    ;    ret
    ;.ENDIF
    
    ;mov hStackData, eax
    ;mov ebx, hStackData
    ;lea eax, [ebx]
    
    ret
VirtualStackData ENDP


;-----------------------------------------------------------------------------------------
; _VirtualStackAddToUniqueList. True if unique, False if not unique, or eax contains
; VIRTUALSTACK_UNIQUEFULL if GlobalRealloc failed and unique list is at max capacity now
;-----------------------------------------------------------------------------------------
_VirtualStackAddToUniqueList PROC PRIVATE USES EBX hVirtualStack:DWORD, dwUniqueValue:DWORD
    LOCAL hStackUniqueData:DWORD
    LOCAL nStackUniqueMaxHeight:DWORD
    LOCAL nStackUniqueNoItems:DWORD
    LOCAL nStackUniqueItem:DWORD
    LOCAL bUnique:DWORD
    LOCAL nSize:DWORD
    
    .IF hVirtualStack == NULL
        xor eax, eax ; FALSE
        ret
    .ENDIF
    
    mov ebx, hVirtualStack
    mov eax, [ebx].STACK.StackUniqueMaxHeight
    .IF sdword ptr eax > 0
        mov nStackUniqueMaxHeight, eax
        mov eax, [ebx].STACK.StackUniqueData
        mov hStackUniqueData, eax
        mov eax, [ebx].STACK.StackUniqueNoItems
        mov nStackUniqueNoItems, eax
        
        ; check if dwUniqueValue is actually unique and hasnt been stored before in list
        mov bUnique, TRUE
        mov nStackUniqueItem, 0
        mov eax, 0
        .WHILE eax < nStackUniqueNoItems
            
            mov eax, nStackUniqueItem
            mov ebx, hStackUniqueData
            mov eax, [ebx+eax*4] ; current stack item value in eax
            .IF eax == dwUniqueValue || dwUniqueValue == NULL
                mov bUnique, FALSE
                .BREAK
            .ENDIF
            
            inc nStackUniqueItem
            mov eax, nStackUniqueItem
        .ENDW
        
        ; if unique we then add it to our list
        .IF bUnique == TRUE
            
            mov eax, nStackUniqueNoItems
            .IF eax == nStackUniqueMaxHeight ; realloc memory if we are at max of list
                
                mov ebx, hVirtualStack
                mov eax, [ebx].STACK.StackMaxHeight
                shl eax, 4d ; x16
                .IF nStackUniqueMaxHeight > eax
                    Invoke GlobalUnlock, hStackUniqueData
                .ENDIF
                mov eax, nStackUniqueMaxHeight
                add eax, nStackUniqueMaxHeight
                mov nStackUniqueMaxHeight, eax
                mov ebx, SIZEOF DWORD
                mul ebx
                mov nSize, eax
                
                Invoke GlobalReAlloc, hStackUniqueData, nSize, GMEM_ZEROINIT + GMEM_MOVEABLE ; resize memory for structure
                .IF eax == NULL
                    mov eax, VIRTUALSTACK_UNIQUEFULL
                    ret
                .ENDIF
                
                ; save realloc data and updated max height back
                Invoke GlobalLock, eax
                mov hStackUniqueData, eax
                mov ebx, hVirtualStack
                mov [ebx].STACK.StackUniqueData, eax
                mov eax, nStackUniqueMaxHeight
                mov [ebx].STACK.StackUniqueMaxHeight, eax
            .ENDIF
            
            ; save data to list
            mov eax, nStackUniqueNoItems
            mov ebx, hStackUniqueData
            lea eax, [ebx+eax*4] ; current stack item address in eax
            mov ebx, eax
            mov eax, dwUniqueValue
            mov [ebx], eax ; save value to stack item address        
            
            ; Update unique items count
            inc nStackUniqueNoItems
            mov ebx, hVirtualStack
            mov eax, nStackUniqueNoItems
            mov [ebx].STACK.StackUniqueNoItems, eax
            
            mov eax, TRUE
            ret
            
        .ELSE
            xor eax, eax ; FALSE
            ret
        .ENDIF
        
    .ELSE
        xor eax, eax ; FALSE
        ret
    .ENDIF
    
    ret

_VirtualStackAddToUniqueList ENDP


END







