; File: HA8-main.s
;-------------------Abhinav Jonnada---------------------------------


; This file needs to be in a Keil version 5 project, together with file init.s

; This is an initial demo program for HA4, which you need to change to complete HA4

; All future CS 238 Home Assignments, will have similar but different files,
; like HA5-main.s, HA6-main.s, etc.

; Executable code in HAx-main.s files should start at label main

	EXPORT	main		; this line is needed to interface with init.s

; Usable utility functions defined in file init.s
; Importing any label from another source file is necessary
; in order to use that label in this source file

	IMPORT	GetCh		; Input one ASCII character from the UART #1 window (from keyboard)
	IMPORT	PutCh		; Output one ASCII character to the UART #1 window
	IMPORT	PutCRLF		; Output CR and LF to the UART #1 window
        IMPORT	UDivMod		; Perform unsigned division to obtain quotient and remainder
	IMPORT	GetDec		; Input a signed number from the UART #1 window
	IMPORT	PutDec		; Output a signed number to the UART #1 window
	IMPORT	GetStr		; Input a CR-terminated ASCII string from the UART #1 window
	IMPORT	PutStr		; Output null-terminated ASCII string to the UART #1 window

	AREA    MyCode, CODE, READONLY

	ALIGN			; highly recommended to start and end any area with ALIGN

; Start of executable code is at following label: main

main

;-------------------- START OF MODIFIABLE CODE ----------------------

	PUSH	{LR}		; save return address of caller in init.s
NEXT    LDR     R0, =Msg1
	BL      PutStr
		   BL		PutCRLF
	BL      GETNUM
	LDR     R0, =Msg4
	BL      PutStr
	BL      GETOP
	LDR     R0, =Msg11
	BL      PutStr
	BL      MATH
	LDR     R0, =PROMPT1
	BL      PutStr
	LDR     R0, =STR1
	MOV     R1, #MaxSTR1
	BL      GetStr
	LDR     R3, =STR1
	LDRB     R3, [R3]
	CMP     R3, #'Y'
	BEQ     NEXT
	BAL     END1
END1    LDR     R0,=Msg10
        BL      PutStr
	POP	{PC}		; return from main (our last executable instruction)
	
	
	
;----------------------TO GETNUM CODE IS BELOW------------


GETNUM  PUSH    {LR}
        LDR     R0, =Msg2
	BL      PutStr
	BL      GetDec
	LDR     R1, =VALUE1
	STR     R0, [R1]
	LDR     R0, =Msg3
	BL      PutStr
	BL      GetDec
	LDR     R2, =VALUE2
	STR     R0, [R2]
	POP     {PC}
	
;----------------------TO GETOP CODE IS BELOW--------------


GETOP   PUSH    {LR}
        
	LDR     R3, =OPER
	MOV     R2, #MaxOPER
	BL      GetCh
	STR		R0, [R3] 
	LDR     R3, [R3]
	CMP     R3, #'+'
	BEQ     OPERAT
	CMP     R3, #'-'
	BEQ     OPERAT
	CMP     R3, #'*'
	BEQ     OPERAT
	CMP     R3, #'/'
	BEQ     OPERAT
OPERAT  LDR     R1, =OPER
        STR     R0, [R1]
	POP     {PC}
	
	
;----------------------TO MATH CODE IS BELOW--------------


MATH   PUSH     {R1-R8, LR}
       LDR      R2, =VALUE1
       LDR      R2, [R2]
       LDR      R3, =VALUE2
       LDR      R3, [R3]
       LDR      R4, =OPER
       LDR      R4, [R4]
       CMP      R4, #'+'
       BEQ      MATH1
       CMP      R4, #'-'
       BEQ      MATH2
       CMP      R4, #'*'
       BEQ      MATH3
       CMP      R4, #'/'
       BEQ      MATH4

MATH1  ADD      R5, R2, R3
       LDR      R0, =Msg5
       BL       PutStr
       MOV      R0, R5
       BL       PutDec
			BL		PutCRLF
       BAL      END2
  
MATH2  SUB      R5, R2, R3
       LDR      R0, =Msg5
       BL       PutStr
       MOV      R0, R5
       BL       PutDec
	   	   BL		PutCRLF
       BAL      END2
 
MATH3  MUL      R5, R2, R3
       LDR      R0, =Msg5
       BL       PutStr
       MOV      R0, R5
       BL       PutDec
	   	   BL		PutCRLF
       BAL      END2

MATH4  MOV      R0, R2
       MOV      R1, R3
       CMP      R1, #0
       BEQ      ERROR
       BL       UDivMod
       LDR      R0, =Msg8
       BL       PutStr
       MOV      R0, R1
       BL       PutDec
	   	   BL		PutCRLF
       BAL      END2
	   
ERROR  LDR      R0, =Msg9
       BL       PutStr
       BAL      END2
	   
END2   POP      {R1-R8, PC}
    
       
	
	
	
; Some commonly used ASCII codes

CR	EQU	0x0D	; Carriage Return (to move cursor to beginning of current line)
LF	EQU	0x0A	; Line Feed (to move cursor to same column of next line)
MaxSTR1 EQU 1000
MaxOPER EQU 1000
; The following data items are in the CODE area,
; so they are all READONLY (i.e. cannot be modified at run-time),
; but they can be initialized at assembly-time to any value
Msg1     DCB "HELLO AND WELCOME:",0
Msg2     DCB "PLEASE ENTER YOUR FIRST INTEGER:",0
Msg3     DCB "PLEASE ENTER YOUR SECOND INTEGER:",0
Msg4     DCB "PLEASE ENTER YOUR DESRIED OPERATION TO BE PERFORMED:",0
Msg5     DCB "THE SUM OF VALUE1 AND VALUE2:",0
Msg6     DCB "THE DIFFERENCE OF VALUE1 AND VALUE2:",0
Msg7     DCB "THE PRODUCT OF VALUE1 AND VALUE2:",0
Msg8     DCB "THE REMAINDER OF VALUE1 AND VALUE2:",0
Msg9     DCB "INVALID OPERATION:",0
PROMPT1  DCB "WOULD YOU LIKE TO CONTINUE (Y/N):",0
Msg10    DCB "Thank You, See You Again",0
Msg11    DCB     "  ", CR, LF, 0


	ALIGN
		
; The following data items are in the DATA area,
; so they are all READWRITE (i.e. can be modified at run-time),
; but are automatically initialized at assembly-time to zeroes 

	AREA    MyData, DATA, READWRITE
		
	ALIGN

VALUE1   SPACE   4
VALUE2   SPACE   4
OPER     SPACE   MaxOPER   +   1000
STR1     SPACE   MaxSTR1   +   1000
;-------------------- END OF MODIFIABLE CODE ----------------------

	ALIGN

	END			; end of source program in this file
