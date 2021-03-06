.486                        ; force 32 bit code
.model flat, stdcall        ; memory model & calling convention
option casemap :none        ; case sensitive

include windows.inc

include user32.inc
includelib user32.lib

include kernel32.inc
includelib kernel32.lib

include Listview.inc

_LVFindItemInStringSearch           PROTO :DWORD, :DWORD, :DWORD
_LVFindItemUpperString              PROTO :DWORD


EXTERNDEF ListViewGetColumnCount    :PROTO :DWORD
EXTERNDEF ListViewGetItemCount      :PROTO :DWORD
EXTERNDEF ListViewDeselectAll       :PROTO :DWORD
EXTERNDEF ListViewGetItemText       :PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
EXTERNDEF ListViewEnsureVisible     :PROTO :DWORD, :DWORD
EXTERNDEF ListViewSetSelected       :PROTO :DWORD, :DWORD

.data
IFDEF DEBUG32
DbgVar1 dd 0 
DbgVar2 dd 0
ENDIF

.code


;**************************************************************************	
; ListViewFindItem
;
; LVM_FINDITEM can only find a string in the first Column
;
; This function search a string in all Column
;
; Return set cursel on all found items
;
; http://www.winasm.net/forum/index.php?showtopic=3934
;
;**************************************************************************	
ListViewFindItem PROC USES EBX hListview:HWND, lpszFindString:DWORD, dwStartCol:DWORD, dwEndCol:DWORD, bShowFoundItem:DWORD, bCaseSensitive:DWORD
    LOCAL lvi:LV_ITEM
    LOCAL buffer[256]:DWORD
    LOCAL findstring[256]:DWORD
    LOCAL nRows:DWORD
    LOCAL nColumns:DWORD
    LOCAL nItem:DWORD
    LOCAL nSubItem:DWORD
    LOCAL LenFindString:DWORD
    LOCAL LenBufferString:DWORD
    LOCAL nStartCol:DWORD
    LOCAL nEndCol:DWORD
    
    Invoke lstrlen, lpszFindString
    .IF eax == 0
        mov eax, -1
        ret
    .ENDIF
    mov LenFindString, eax
    
    Invoke ListViewGetColumnCount, hListview
    mov nColumns, eax
    .IF nColumns != 0
        ; 0 base the column count
        dec nColumns
        dec eax
    .ENDIF
    .IF dwEndCol == -1
        mov nEndCol, eax
    .ELSE
        mov eax, dwEndCol
        mov nEndCol, eax
    .ENDIF
    
    .IF dwStartCol == -1
        mov nStartCol, 0
    .ELSE
        mov eax, dwStartCol
        mov nStartCol, eax
    .ENDIF
    
    mov eax, nStartCol
    .IF eax > nEndCol
        mov eax, -1
        ret
    .ENDIF

    Invoke lstrcpy, Addr findstring, lpszFindString
    .IF bCaseSensitive == FALSE
        Invoke _LVFindItemUpperString, Addr findstring
    .ENDIF
    
    Invoke ListViewGetItemCount, hListview
    mov nRows, eax
    
    ;mov lvi.imask, LVIF_TEXT
    ;mov lvi.cchTextMax,256
    ;lea eax,buffer
    ;mov lvi.pszText,eax
    ;-- Delete the current focus
    ;mov lvi.stateMask, LVIS_SELECTED + LVIS_FOCUSED
    ;mov lvi.state,0
    ;invoke SendMessage, hListview, LVM_SETITEMSTATE, -1, Addr lvi
    
    Invoke ListViewDeselectAll, hListview
    
    mov nItem, 0
    mov eax, 0
    .while eax < nRows
        
        mov eax, nStartCol
        mov nSubItem, eax
        mov ebx, nStartCol
        .while ebx <= nEndCol
            
            Invoke ListViewGetItemText, hListview, nItem, nSubItem, Addr buffer, SIZEOF buffer
            .IF eax == 0
                inc nSubItem
                mov ebx, nSubItem
                .continue
            .ENDIF 
            ;invoke SendMessage, hListview, LVM_GETITEM, 0, Addr lvi
            
            Invoke lstrlen, Addr buffer
            mov LenBufferString, eax
            .IF eax == 0
                inc nSubItem
                mov ebx, nSubItem            
                .continue
            .ENDIF
            
            .IF bCaseSensitive == FALSE
                Invoke _LVFindItemUpperString, Addr buffer
            .ENDIF
            
            
            IFDEF DEBUG32
            lea eax, buffer
            mov DbgVar1, eax
            
            mov eax, lpszFindString
            mov DbgVar2, eax
            
            PrintStringByAddr DbgVar1
            PrintStringByAddr DbgVar2
            
            ENDIF
            
            mov eax, LenFindString
            .IF eax == LenBufferString ; if same do str compare
            
                Invoke lstrcmpi, Addr buffer, Addr findstring ;lpszFindString
                .IF eax == 0
                    .IF bShowFoundItem == TRUE
                        ;// Set the focus
                        ;mov eax,LVIS_SELECTED + LVIS_FOCUSED
                        ;mov lvi.stateMask,eax
                        ;mov lvi.state,eax
                        ;invoke SendMessage, hListview, LVM_SETITEMSTATE, ebx, Addr lvi
                        ;invoke SendMessage, hListview, LVM_ENSUREVISIBLE , ebx, TRUE
                        Invoke ListViewSetSelected, hListview, nItem
                        Invoke ListViewEnsureVisible, hListview, nItem
                        ;invoke SetFocus, hListview
                        mov eax, nItem
                        ret
                    .ELSE
                        mov eax, nItem
                        ret
                    .ENDIF
                    
                .ENDIF

            .ELSEIF eax < LenBufferString
                
                Invoke _LVFindItemInStringSearch, 1, Addr buffer, Addr findstring ;lpszFindString
                IFDEF DEBUG32
                PrintDec eax
                ENDIF
                .IF eax > 0
                
                ;invoke lstrcmpi, Addr buffer, lpszFindString
                ;.if eax == 0 ;==0
                    .IF bShowFoundItem == TRUE
                        ;// Set the focus
                        ;mov eax,LVIS_SELECTED + LVIS_FOCUSED
                        ;mov lvi.stateMask,eax
                        ;mov lvi.state,eax
                        ;invoke SendMessage, hListview, LVM_SETITEMSTATE, ebx, Addr lvi
                        ;invoke SendMessage, hListview, LVM_ENSUREVISIBLE , ebx, TRUE
                        Invoke ListViewSetSelected, hListview, nItem
                        Invoke ListViewEnsureVisible, hListview, nItem
                        ;invoke SetFocus, hListview
                        mov eax, nItem
                        ret
                    .ELSE
                        mov eax, nItem
                        ret
                    .ENDIF
                .ENDIF
            
            .ELSE ; do nothing as findstring > than buffer string
                
            .ENDIF
            inc nSubItem
            mov ebx, nSubItem            
        .endw
        inc nItem
        mov eax, nItem
    .endw
    
    ;xor eax,eax
    mov eax, -1
    ret
ListViewFindItem endp



_LVFindItemInStringSearch PROC PRIVATE startpos:DWORD,lpSource:DWORD,lpPattern:DWORD

  ; ------------------------------------------------------------------
  ; InString searches for a substring in a larger string and if it is
  ; found, it returns its position in eax. 
  ;
  ; It uses a one (1) based character index (1st character is 1,
  ; 2nd is 2 etc...) for both the "StartPos" parameter and the returned
  ; character position.
  ;
  ; Return Values.
  ; If the function succeeds, it returns the 1 based index of the start
  ; of the substring.
  ;  0 = no match found
  ; -1 = substring same length or longer than main string
  ; -2 = "StartPos" parameter out of range (less than 1 or longer than
  ; main string)
  ; ------------------------------------------------------------------

    LOCAL sLen:DWORD
    LOCAL pLen:DWORD

    push ebx
    push esi
    push edi

    invoke lstrlen,lpSource
    mov sLen, eax           ; source length
    invoke lstrlen,lpPattern
    mov pLen, eax           ; pattern length

    cmp startpos, 1
    jge @F
    mov eax, -2
    jmp isOut               ; exit if startpos not 1 or greater
  @@:

    dec startpos            ; correct from 1 to 0 based index

    cmp  eax, sLen
    jl @F
    mov eax, -1
    jmp isOut               ; exit if pattern longer than source
  @@:

    sub sLen, eax           ; don't read past string end
    inc sLen

    mov ecx, sLen
    cmp ecx, startpos
    jg @F
    mov eax, -2
    jmp isOut               ; exit if startpos is past end
  @@:

  ; ----------------
  ; setup loop code
  ; ----------------
    mov esi, lpSource
    mov edi, lpPattern
    mov al, [edi]           ; get 1st char in pattern

    add esi, ecx            ; add source length
    neg ecx                 ; invert sign
    add ecx, startpos       ; add starting offset

    jmp Scan_Loop

    align 16

  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  Pre_Scan:
    inc ecx                 ; start on next byte

  Scan_Loop:
    cmp al, [esi+ecx]       ; scan for 1st byte of pattern
    je Pre_Match            ; test if it matches
    inc ecx
    js Scan_Loop            ; exit on sign inversion

    jmp No_Match

  Pre_Match:
    lea ebx, [esi+ecx]      ; put current scan address in EBX
    mov edx, pLen           ; put pattern length into EDX

  Test_Match:
    mov ah, [ebx+edx-1]     ; load last byte of pattern length in main string
    cmp ah, [edi+edx-1]     ; compare it with last byte in pattern
    jne Pre_Scan            ; jump back on mismatch
    dec edx
    jnz Test_Match          ; 0 = match, fall through on match

  ; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  Match:
    add ecx, sLen
    mov eax, ecx
    inc eax
    jmp isOut
    
  No_Match:
    xor eax, eax

  isOut:
    pop edi
    pop esi
    pop ebx

    ret

_LVFindItemInStringSearch endp



OPTION PROLOGUE:NONE 
OPTION EPILOGUE:NONE 

align 4

_LVFindItemUpperString proc text:DWORD

  ; -----------------------------
  ; converts string to upper case
  ; invoke szUpper,ADDR szString
  ; -----------------------------

    mov eax, [esp+4]
    dec eax

  @@:
    add eax, 1
    cmp BYTE PTR [eax], 0
    je @F
    cmp BYTE PTR [eax], "a"
    jb @B
    cmp BYTE PTR [eax], "z"
    ja @B
    sub BYTE PTR [eax], 32
    jmp @B
  @@:

    mov eax, [esp+4]

    ret 4

_LVFindItemUpperString endp

OPTION PROLOGUE:PrologueDef 
OPTION EPILOGUE:EpilogueDef 



END