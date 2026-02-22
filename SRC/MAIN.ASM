; SRC\MAIN.ASM

TITLE SALIX_TED_16
INCLUDE SALIX.INC

.MODEL SMALL
.STACK 100H

; Declare our external SDK routines
EXTRN Vid_Txt_Set_Mode:PROC
EXTRN Draw_Editor_Layout:PROC

.CODE
Main:
    MOV AX, @DATA
    MOV DS, AX

    ; --- 0. Enter the Worksapce ---
    CALL Vid_Txt_Set_Mode
    ; ---------------------------------------------
    CALL Draw_Editor_Layout

    ; Wait for a key to terminate program
    MOV AH, 00H
    INT 16

    ; Exit to DOS
    MOV AX, 4C00H
    INT 21H

END Main