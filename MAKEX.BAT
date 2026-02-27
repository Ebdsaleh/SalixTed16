@ECHO OFF
ECHO Building SalixTed16 using Salix16 SDK with Full Symbols...

REM --- SDK Paths ---
SET INC_DIR=c:\SALIX16\INC
SET SALIX_LIB=C:\SALIX16\LIB\SALIX16.LIB
:: SET ICE16=PathToSoftIceInstallation\Util16
REM --- 1. Assemble ---
REM /i tells TASM where the "INCLUDE" path is, /zi is for debug symbols 
TASM /zi /i%INC_DIR% SRC\MAIN.ASM, BUILD\MAIN.OBJ
TASM /zi /i%INC_DIR% SRC\TUI\LAYOUT.ASM, BUILD\LAYOUT.OBJ

REM --- 2. Link ---
REM Syntax: TLINK [obj], [Exe], [Map], [Lib]
TLINK /v /s +BUILD\MAIN.OBJ +BUILD\LAYOUT.OBJ, BIN\SALIXTED.EXE,  , %SALIX_LIB%

IF NOT EXIST BIN\SALIXTED.EXE GOTO FAIL

REM --- 3. Generate SoftICE Symbols ---
ECHO Generating SoftICE Symbols...
IF EXIST BIN\SALIXTED.EXE 
REM Make sure to 'SET' the SoftICE Util16 path first.
%ICE16%MSYM BIN\SALIXTED.MAP
IF ERRORLEVEL 1 GOTO FAIL

ECHO Build Success!
GOTO END

:FAIL
ECHO Build Failed!
:END