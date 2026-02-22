; SRC\TUI\LAYOUT.ASM
; --- SalixTed LAYOUT MODULE---
TITLE SALIXTED_LAYOUT

INCLUDE SALIX.INC

.MODEL SMALL
.STACK 100H

EXTRN Vid_Txt_Draw_Box:PROC
EXTRN Vid_Txt_Draw_Panel:Panel:PROC
EXTRN Vid_Txt_Write_String:PROC


.DATA
    MsgTitle    DB " SalixTed 16 - v1.0 ", 0
    MsgFile     DB " File ", 0
    MsgEdit     DB " Edit ", 0
    MsgSearch   DB " Search ", 0
    MsgHelp     DB " Help ", 0

    ; --- Define the Slots ---
    SlotFile    Tui_Menu_Slot <OFFSET MsgFile, 'F', 1, 6>
    SlotEdit    Tui_Menu_Slot <OFFSET MsgEdit, 'E', 8, 6>
    SlotSearch  Tui_Menu_Slot <OFFSET MsgSearch, 'S', 15, 8>
    SlotHelp    Tui_Menu_Slot <OFFSET MsgHelp, 'H', 73, 6>

    ; Create a Table of pointers to these slots
    MenuTable   DW OFFSET SlotFile, OFFSET SlotEdit, OFFSET SlotSearch, OFFSET SlotHelp

    ; Define the Bar itself
    MenuBar Tui_MenuBar < 4, 0, 70H, 0FH, OFFSET MenuTable>

.CODE
PUBLIC Draw_Editor_Layout

Draw_Editor_Layout PROC
    PUSH DS                     ; Valut the caller's Data segement
    PUSH AX
    ; --- Point DX to the local  data segment
    MOV AX, @DATA
    MOV DS, AX                  ; Now SI will find MsgTitle correctly.

    ; --- 1. Drop the Titlebar (Top Row) ---

    MOV DL, 0                   ; Start at Column 0 (X)
    MOV DH, 0                   ; Start at the very top Row 0 (Y)
    MOV CL, 80                  ; Use the FULL Width of the screen
    MOV CH, 1                   ; Only 1 row high
    MOV AL, ' '                 
    MOV BL, 70H                 ; Black text on Grey background
    MOB BH, 0                   ; No Border style (Style 0)
    CALL Vid_Txt_Draw_Box

    ; --- Draw the Menu Items on Row 0 ---
    MOV DH, 0                   ; Always the top row
    MOV BL, 70H                 ; Black test on Gray

    ; File Menu
    MOV DL, 1                   ; Starting Column 1
    LEA SI, MsgFile
    CALL Vid_Txt_Write_String

    ; Edit Menu
    MOV DL, 8                   ; Column 8 give some space
    LEA SI, MsgEdit
    CALL Vid_Txt_Write_String

    ; Search Menu
    MOV DL, 15                  ; Column 15
    LEA SI, MsgSearch
    CALL Vid_Txt_Write_String

    ; Help Menu (Right-Justified-Style)
    MOV DL, 73                  ; Column 73
    LEA SI, MsgHelp
    CALL Vid_Txt_Write_String

    ; --- 2. Drop the Sidebar  (Explorer) ---
    MOV DL, 0                   ; Start at Column 0 (X)
    MOV DH, 1                   ; Start at Row 1 (Y)
    MOV CL, 16
    MOV CH, 24
    MOV AL, ' '                 ; ' ' for Sidebar
    MOV BL, 07H                 ; Gray on Black
    MOV BH, 2                   ; Style 2 (Double Line)
    CALL Vid_Txt_Draw_Box

    ; --- 3. Drop the Editor Window ---
    MOV DL, 17                  ; Start at Column 17 (X)
    MOV DH, 1                   ; Start at Row 1 (Y)
    MOV CL, 63

    MOV CH, 23
    MOV AL, ' '                 ; ' ' for Editor
    MOV BL, 17H                 ; White on Blue
    MOV BH, 1                   ; Style 1 (Single Line)
    CALL Vid_Txt_Draw_Box

    ; --- 4. Drop the Footer, Status bar ---
    MOV DL, 0                   ; Start at Column 0 (X)
    MOV DH, 24                  ; Start at Row 24 (Y)
    MOV CL, 80                  ; Use the FULL Width of the screen

    MOV CH, 1                   ; Only 1 row in height
    MOV AL, ' '                 ; No foreground character
    MOV BL, 70H                 ; Color Grey
    MOV BH, 0                   ; No border
    CALL Vid_Txt_Draw_Box

    ; --- 5. Write the Centered Title ---
    ; Title: "SalixTed 16 - v1.0 " (20 characters)
    ; (80 - 20) / 2 = Column 30
    MOV DL, 30                  ; Start at Column 30 (X)
    MOV DH, 0                   ; Start at Row (Y)
    MOV BL, 70H                 ; Match the Titlebar colors (Black on Grey)
    LEA SI, MsgTitle            ; Load the string address
    CALL Vid_Txt_Write_String

    POP AX
    POP DX
    RET
Draw_Editor_Layout ENDP

END