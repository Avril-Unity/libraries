;=========================================================================================
;
; LICENSE
;
; LTLI TreeView x64 Library v1.0.0.0
;
; Copyright (c) 2017 by KSR aka fearless
;
; All Rights Reserved
;
; http://www.LetTheLight.in
;
;
; This software is provided 'as-is', without any express or implied warranty. In no
; event will the author be held liable for any damages arising from the use of this
; software.
;
; Permission is granted to anyone to use this software for any non-commercial program.
; If you use the library in an application, an acknowledgement in the application or
; documentation is appreciated but not required. 
;
; You are allowed to make modifications to the source code, but you must leave the
; original copyright notices intact and not mispresent the origin of the software.
; It is not allowed to claim you wrote the original software. Modified files must have
; a clear notice that the files are modified, and not in the original state. This includes
; the name of the person(s) who modified the code. 
;
; If you want to distribute or redistribute any portion of this package, you will need
; to include the full package in it's original state, including this license and all
; the copyrights. 
;
; While distributing this package (in it's original state) is allowed, it is not allowed
; to charge anything for this. You may not sell or include the package in any commercial
; package without having permission of the author. Neither is it allowed to redistribute
; any of the package's components with commercial applications.
;
;=========================================================================================

;-----------------------------------------------------------------------------------------
; LTLI TreeView LIB Prototypes
;-----------------------------------------------------------------------------------------

TreeViewClearAll		    PROTO :QWORD                                                    ; hTreeview
TreeViewDeleteAll           EQU TreeViewClearAll                                            ; hTreeview

TreeViewGetSelectedImage    PROTO :QWORD                                                    ; hTreeview, hItem
TreeViewGetSelectedItem     PROTO :QWORD                                                    ; hTreeview, hItem
TreeViewGetSelectedParam    PROTO :QWORD                                                    ; hTreeview, hItem
TreeViewGetSelectedText     PROTO :QWORD,:QWORD,:QWORD                                      ; hTreeview, hItem
TreeViewSetSelectedItem     PROTO :QWORD,:QWORD,:QWORD                                      ; hTreeview, hItem, bEnsureVisible

TreeViewGetItemText         PROTO :QWORD,:QWORD,:QWORD,:QWORD                               ; hTreeview, hItem
TreeViewGetItemImage        PROTO :QWORD,:QWORD                                             ; hTreeview, hItem
TreeViewGetItemParam        PROTO :QWORD,:QWORD                                             ; hTreeview, hItem
TreeViewSetItemText         PROTO :QWORD,:QWORD,:QWORD                                      ; hTreeview, hItem
TreeViewSetItemImage        PROTO :QWORD,:QWORD,:QWORD                                      ; hTreeview, hItem
TreeViewSetItemParam        PROTO :QWORD,:QWORD,:QWORD                                      ; hTreeview, hItem


TreeViewItemDelete          PROTO :QWORD,:QWORD                                             ; hTreeview, hItem
TreeViewItemHasChildren     PROTO :QWORD,:QWORD                                             ; hTreeview, hItem
TreeViewItemInsert          PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD   ; hTreeview, hNodeParent, lpszNodeText, nNodeIndex, NodePosition, nImage, nImageSelected, qwParam
TreeViewItemToggle          PROTO :QWORD,:QWORD                                             ; hTreeview, hItem


TreeViewSubClassProc        PROTO :QWORD,:QWORD                                             ; hTreeview, lpqwTVSubClassProc
TreeViewSubClassData        PROTO :QWORD,:QWORD                                             ; hTreeview, lpqwTVSubClassData

TreeViewLinkImageList       PROTO :QWORD,:QWORD,:QWORD                                      ; hTreeview

TreeViewDrawSelectedItem    PROTO :QWORD                                                    ; hTreeview
TreeViewDrawSelectedItemDlg PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD                 ; hWin, lParam, qwBackColor, qwTextColor, qwSelBackColor, qwSelTextColor

TreeViewCountItems          PROTO :QWORD                                                    ; hTreeview
TreeViewCountChildren       PROTO :QWORD,:QWORD,:QWORD                                      ; hTreeview, hItem, bRecurse

TreeViewFindItem            PROTO :QWORD,:QWORD,:QWORD,:QWORD                               ; hTreeview, hItem, lpszFindText, bCaseSensitive


TreeViewRootCollapse        PROTO :QWORD                                                    ; hTreeview
TreeViewRootExpand          PROTO :QWORD                                                    ; hTreeview
TreeViewBranchCollapse      PROTO :QWORD,:QWORD                                             ; hTreeview, hItem
TreeViewBranchExpand        PROTO :QWORD,:QWORD                                             ; hTreeview, hItem
TreeViewItemCollapse        PROTO :QWORD,:QWORD                                             ; hTreeview, hItem
TreeViewItemExpand          PROTO :QWORD,:QWORD                                             ; hTreeview, hItem

TreeViewBranchDepth         PROTO :QWORD,:QWORD                                             ; hTreeview, hItem

TreeViewWalk                PROTO :QWORD,:QWORD,:QWORD,:QWORD                               ; hTreeview, hItem, lpTreeViewWalkCallback, lpCustomData
;TreeViewWalkCallback       PROTO :QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD,:QWORD          ; hTreeview, hItem, qwStatus, qwTotalItems, qwItemNo, qwLevel, qwCustomData


;-----------------------------------------------------------------------------------------
; LTLI TreeView LIB Constants
;-----------------------------------------------------------------------------------------
.CONST
; TreeView Walk Callback Status (dwStatus):
TREEVIEWWALK_NULL              EQU 0
TREEVIEWWALK_ITEM              EQU 1
TREEVIEWWALK_ITEM_START        EQU 2
TREEVIEWWALK_ITEM_FINISH       EQU 3
TREEVIEWWALK_ROOT_START        EQU 4
TREEVIEWWALK_ROOT_FINISH       EQU 5
