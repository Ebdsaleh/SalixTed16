; SRC\MAIN.ASM

TITLE SALIX_TED_16

.MODEL SMALL

.STACK 100H

INCLUDE SALIX.INC

; Declare our external SDK routines
EXTRN Draw_Editor_Layout:PROC

.CODE
Main:
    MOV AX, @DATA
    MOV DS, AX

    ; --- 0. Enter the Workspace ---
    CALL Vid_Txt_Set_Mode
    ; ---------------------------------------------
    CALL Draw_Editor_Layout
Main_Loop:
    ; Wait for a key to terminate program
    CALL Kbd_Await_Keystroke
    CMP AH, 01H                 ; 01H did the escape key get pressed?
    JNE Main_Loop
    
    JMP Exit_Program

Exit_Program:
    ; Exit to DOS
    MOV AX, 4C00H
    INT 21H
    RET
END Main