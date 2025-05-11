
;                    X_O BOARD
;0           106                      212
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;             ;                        ;           ;      
;             ;                        ;           ;      
;     1       ;           2            ;     3     ;  
;             ;                        ;           ;  
;             ;                        ;           ;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 80
;             ;                        ;           ;  
;       4     ;           5            ;      6    ;  
;             ;                        ;           ;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 160
;             ;                        ;           ;  
;             ;                        ;           ;  
;       7     ;           8            ;     9     ;  
;             ;                        ;           ;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

	IMPORT TFT_FillScreen
	IMPORT TFT_WriteCommand	
	IMPORT TFT_WriteData	
	IMPORT CONFIG

	AREA DATA, DATA, READWRITE

GAME_BOARD    SPACE 9    ; 3x3 board represented as 1D array
CURRENT_PLAYER SPACE 1   ; 1 = X, 2 = O
GAME_OVER     SPACE 1    ; Game over flag



    AREA MYCODE, CODE, READONLY

    EXPORT __xogame
	

;Colors
RED     EQU 0xF800  ; 11111 000000 00000
GREEN   EQU 0x07E0  ; 00000 111111 00000
BLUE    EQU 0x001F  ; 00000 000000 11111
YELLOW  EQU 0xFFE0  ; 11111 111111 00000
WHITE   EQU 0xFFFF  ; 11111 111111 11111
BLACK   EQU 0x0000  ; 00000 000000 00000 
BUN     EQU 0xCE40
BUNGER  EQU 0x9A00
LETTUCE EQU 0x0300
TOMATO  EQU 0xB800


DELAY_INTERVALL  EQU     0x150000
DELAY_LOWINTERVAL  EQU  0x20000
    LTORG


  
__xogame FUNCTION
    LTORG
    BL CONFIG

XO
    
    BL TFT_INIT2
    
    
    BL INITIALIZE_GAME

    
    LTORG
    
GAME_LOOP
    ; Check if game is over
    LDR R0, =GAME_OVER
    LDRB R0, [R0]
    CMP R0, #0
    BNE RESTART_GAME_CHECK
    LTORG
 
    LDR R11, =CURRENT_PLAYER
    LDRB R5, [R11]
    
    ; Check if current player is X (1) or O (2)
    CMP R5, #1
    BEQ GOTO_X_TURN
    B GOTO_O_TURN
    
GOTO_X_TURN
    LTORG
    B X_TURN
    
GOTO_O_TURN
    LTORG
    B O_TURN

LTORG
	
RESTART_GAME_CHECK
    ; Check if restart button is pressed (using B4/PD4)
   LDR R3, =GPIOB_BASE + GPIO_IDR
    LDR R0, [R3]
    TST R0, #(1 << 4)
    BEQ RESTART_GAME_CHECK    ; If not pressed, keep looping
    
    ; If pressed, initialize a new game
    BL INITIALIZE_GAME
    B GAME_LOOP

    ; Adding LTORG here to handle potential branch distance issues
    LTORG


FIND_EMPTY_CELL ; FIND EMPTY CELL AND RETURN X,Y COORDINATES R1-> X   R2-> Y
    PUSH {R0,R3-R12, LR}
    
	
	
    ; Load game board data
    LDR R12, =GAME_BOARD
    LDRB R3, [R12]    ; Cell 1
    LDRB R4, [R12,#1]    ; Cell 2
    LDRB R5, [R12,#2]    ; Cell 3
    LDRB R6, [R12,#3]    ; Cell 4
    LDRB R7, [R12,#4]    ; Cell 5
    LDRB R8, [R12,#5]    ; Cell 6
    LDRB R9, [R12,#6]    ; Cell 7
    LDRB R10, [R12,#7]   ; Cell 8
    LDRB R11, [R12,#8]   ; Cell 9
    
    ; Check Cell 1 (top-left)
    CMP R3, #0
    BNE CHECK_CELL_2
    MOV R1, #0            ; X = 0
    MOV R2, #0            ; Y = 0
    B FIND_EMPTY_DONE
    
CHECK_CELL_2
    ; Check Cell 2 (top-middle)
    CMP R4, #0
    BNE CHECK_CELL_3
    MOV R1, #106          ; X = 106
    MOV R2, #0            ; Y = 0
    B FIND_EMPTY_DONE
    
CHECK_CELL_3
    ; Check Cell 3 (top-right)
    CMP R5, #0
    BNE CHECK_CELL_4
    MOV R1, #212          ; X = 212
    MOV R2, #0            ; Y = 0
    B FIND_EMPTY_DONE
    
CHECK_CELL_4
    ; Check Cell 4 (middle-left)
    CMP R6, #0
    BNE CHECK_CELL_5

    MOV R1, #0            ; X = 0
    MOV R2, #80           ; Y = 80
    B FIND_EMPTY_DONE
    
CHECK_CELL_5
    ; Check Cell 5 (middle-middle)
    CMP R7, #0
    BNE CHECK_CELL_6
    MOV R1, #106          ; X = 106
    MOV R2, #80           ; Y = 80
    B FIND_EMPTY_DONE
    
CHECK_CELL_6
    ; Check Cell 6 (middle-right)
    CMP R8, #0
    BNE CHECK_CELL_7
    MOV R1, #212          ; X = 212
    MOV R2, #80           ; Y = 80
    B FIND_EMPTY_DONE
    
CHECK_CELL_7
    ; Check Cell 7 (bottom-left)
    CMP R9, #0
    BNE CHECK_CELL_8
    MOV R1, #0            ; X = 0
    MOV R2, #160          ; Y = 160
    B FIND_EMPTY_DONE
    
CHECK_CELL_8
    ; Check Cell 8 (bottom-middle)
    CMP R10, #0
    BNE CHECK_CELL_9
    MOV R1, #106          ; X = 106
    MOV R2, #160          ; Y = 160
    B FIND_EMPTY_DONE
    
CHECK_CELL_9
    ; Check Cell 9 (bottom-right)
    CMP R11, #0
    BNE FIND_EMPTY_DONE
    MOV R1, #212          ; X = 212
    MOV R2, #160          ; Y = 160
    
FIND_EMPTY_DONE
    POP {R0,R3-R12, PC}
    
    LTORG


INITIALIZE_GAME
    PUSH {R0,R3-R12, LR}
    
    ; Clear game board
    LDR R12, =GAME_BOARD
    MOV R0, #0
    STRB R0, [R12]    ; Cell 1
    STRB R0, [R12,#1]    ; Cell 2
    STRB R0, [R12,#2]    ; Cell 3
    STRB R0, [R12,#3]    ; Cell 4
    STRB R0, [R12,#4]    ; Cell 5
    STRB R0, [R12,#5]    ; Cell 6
    STRB R0, [R12,#6]    ; Cell 7
    STRB R0, [R12,#7]   ; Cell 8
    STRB R0, [R12,#8]   ; Cell 9
    
    ; Set player to X (1)
    LDR R11, =CURRENT_PLAYER
    MOV R0, #1
    STRB R0, [R11]
    
    ; Clear game over flag
    LDR R11, =GAME_OVER
    MOV R0, #0
    STRB R0, [R11]
    
    ; Initialize cursor position
    MOV R1, #0     ; Start X
    MOV R2, #0     ; Start Y
    
    ; Draw background (green)
    LDR R0, =LETTUCE
    MOV R1, #0              ; Y1
    MOV R2, #0xF0           ; Y2
    MOV R3, #0              ; X1
    MOV R4, #0x140          ; X2
    BL TFT_DRAW_RECT
    BL delay
    
    ;;;;;;DRAW LINES
    LDR R0, =WHITE
    MOV R1, #0              ; Y1
    MOV R2, #0xF0           ; Y2
    MOV R3, #0x6A           ; X1
    MOV R4, #0x6F           ; X2
    BL TFT_DRAW_RECT
    BL delay
    
    LDR R0, =WHITE
    MOV R1, #0              ; Y1
    MOV R2, #0xF0           ; Y2
    MOV R3, #0xD4           ; X1
    MOV R4, #0xDC           ; X2
    BL TFT_DRAW_RECT
    BL delay
    
    LDR R0, =WHITE
    MOV R1, #0x50           ; Y1
    MOV R2, #0x55           ; Y2
    MOV R3, #0              ; X1
    MOV R4, #0x140          ; X2
    BL TFT_DRAW_RECT
    BL delay
    
    LDR R0, =WHITE
    MOV R1, #0xA0           ; Y1
    MOV R2, #0xA5           ; Y2
    MOV R3, #0              ; X1
    MOV R4, #0x140          ; X2
    BL TFT_DRAW_RECT
    BL delay
    
    ; Reset cursor position
    MOV R1, #0     ; Start X
    MOV R2, #0     ; Start Y
    
    POP {R0,R3-R12, PC}
    
    ; Adding LTORG here to handle potential branch distance issues
    LTORG
    
X_TURN
    LDR R11, =CURRENT_PLAYER
    MOV R5, #1        ; X player
    STRB R5, [R11]
    BL GET_INPUT  ;IF SUMBIT R0->15 (INITIAL VALUE FOR TRSTON CHANGE LATER)
    BL DRAW_X_SELECTION
    CMP R0, #15
    BNE X_TURN
    BL DRAW_X_BOARD
	
    BL CHECK_WIN
    CMP R0, #1        ; Check if X won
    BEQ X_WIN
	LTORG
    BL CHECK_DRAW     ; Check for draw
    CMP R0, #1
    BEQ DRAW_GAME
	BL FIND_EMPTY_CELL
    B O_TURN

    ; Adding LTORG here to handle potential branch distance issues
    LTORG

O_TURN
    LDR R11, =CURRENT_PLAYER
    MOV R6, #2        ; O player
    STRB R6, [R11]
    BL GET_INPUT
    BL DRAW_O_SELECTION
    CMP R0, #15
    BNE O_TURN
    BL DRAW_O_BOARD   ; Now correctly draws O
    BL CHECK_WIN
    CMP R0, #2       ; Check if O won
    BEQ O_WIN
	
    LTORG
    
    BL CHECK_DRAW     ; Check for draw
    CMP R0, #1
    BEQ DRAW_GAME
	LTORG
	BL FIND_EMPTY_CELL
    B X_TURN

    ; Adding LTORG here to handle potential branch distance issues
    LTORG

X_WIN
    
    ; Set game over flag
    LDR R0, =GAME_OVER
    MOV R1, #1
    STRB R1, [R0]
    ; Display X wins message (red background)
    LDR R0, =RED
    MOV R1, #0              ; Y1
    MOV R2, #0xF0           ; Y2
    MOV R3, #0              ; X1
    MOV R4, #0x140          ; X2
    BL TFT_DRAW_RECT
    
    B GAME_LOOP

    ; Adding LTORG here to handle potential branch distance issues
    LTORG

O_WIN

    ; Set game over flag
    LDR R0, =GAME_OVER
    MOV R1, #1
    STRB R1, [R0]
    

    
    ; Display O wins message (blue background)
    LDR R0, =BLUE
    MOV R1, #0              ; Y1
    MOV R2, #0xF0           ; Y2
    MOV R3, #0              ; X1
    MOV R4, #0x140          ; X2
    BL TFT_DRAW_RECT
    

    B GAME_LOOP

DRAW_GAME
    
    ; Set game over flag
    LDR R0, =GAME_OVER
    MOV R1, #1
    STRB R1, [R0]
    
    ; Display draw message (yellow background)
    LDR R0, =YELLOW
    MOV R1, #0              ; Y1
    MOV R2, #0xF0           ; Y2
    MOV R3, #0              ; X1
    MOV R4, #0x140          ; X2
    BL TFT_DRAW_RECT
    B GAME_LOOP

    ; Adding LTORG here to handle potential branch distance issues
    LTORG

; Check if the game is a draw (board is full)
CHECK_DRAW
    PUSH {R1-R12, LR}
    
    LDR R1, =GAME_BOARD
    LDRB R3, [R1]    ; Cell 1
    LDRB R4, [R1,#1]    ; Cell 2
    LDRB R5, [R1,#2]    ; Cell 3
    LDRB R6, [R1,#3]    ; Cell 4
    LDRB R7, [R1,#4]    ; Cell 5
    LDRB R8, [R1,#5]    ; Cell 6
    LDRB R9, [R1,#6]    ; Cell 7
    LDRB R10, [R1,#7]   ; Cell 8
    LDRB R11, [R1,#8]   ; Cell 9
    
    MOV R0, #1              ; Assume it's a draw
    
    ; Check if any cell is empty (0)
    CMP R3, #0
    MOVEQ R0, #0            ; Not a draw if empty cell found
    BEQ CHECK_DRAW_DONE
    
    CMP R4, #0
    MOVEQ R0, #0
    BEQ CHECK_DRAW_DONE
    
    CMP R5, #0
    MOVEQ R0, #0
    BEQ CHECK_DRAW_DONE
    
    CMP R6, #0
    MOVEQ R0, #0
    BEQ CHECK_DRAW_DONE
    
    CMP R7, #0
    MOVEQ R0, #0
    BEQ CHECK_DRAW_DONE
    
    CMP R8, #0
    MOVEQ R0, #0
    BEQ CHECK_DRAW_DONE
    
    CMP R9, #0
    MOVEQ R0, #0
    BEQ CHECK_DRAW_DONE
    
    CMP R10, #0
    MOVEQ R0, #0
    BEQ CHECK_DRAW_DONE
    
    CMP R11, #0
    MOVEQ R0, #0
    
CHECK_DRAW_DONE
    POP {R1-R12, PC}

    ; Adding LTORG here to handle potential branch distance issues
    LTORG

GET_POS ; RETURN R0->CELL NUMBER (1-9) 
    PUSH{R1-R12,LR}

    CMP R2,#0
    BEQ CHECK_FIRST_ROWCOL
    CMP R2,#80
    BEQ CHECK_SECOND_ROWCOL
    CMP R2,#160
    BEQ CHECK_THIRD_ROWCOL
    
CHECK_FIRST_ROWCOL
    CMP R1,#0
    MOVEQ R0,#1
    
    CMP R1,#106
    MOVEQ R0,#2
    
    CMP R1,#212
    MOVEQ R0,#3
    B EXITT
    
CHECK_SECOND_ROWCOL
    CMP R1,#0
    MOVEQ R0,#4
    
    CMP R1,#106
    MOVEQ R0,#5
    
    CMP R1,#212
    MOVEQ R0,#6
    B EXITT
CHECK_THIRD_ROWCOL
    CMP R1,#0
    MOVEQ R0,#7
    
    CMP R1,#106
    MOVEQ R0,#8
    
    CMP R1,#212
    MOVEQ R0,#9
    B EXITT    

EXITT
    POP{R1-R12,PC}

    ; Adding LTORG here to handle potential branch distance issues
    LTORG



IS_FULL ;RETURNS R0=0 (EMPTY) , R0=1 (X) OR R0=2 (O) (OCCUPIED) TAKE CELL NUMBER IN R0
    PUSH {R1-R12, LR}
    
	SUB R0,R0,#1
    ; Save the cell number to check
    MOV R12, R0
    
    ; Load game board data into registers as done in original code
    LDR R1, =GAME_BOARD
    LDRB R3, [R1]    ; Cell 1
    LDRB R4, [R1,#1]    ; Cell 2
    LDRB R5, [R1,#2]    ; Cell 3
    LDRB R6, [R1,#3]    ; Cell 4
    LDRB R7, [R1,#4]    ; Cell 5
    LDRB R8, [R1,#5]    ; Cell 6
    LDRB R9, [R1,#6]    ; Cell 7
    LDRB R10, [R1,#7]   ; Cell 8
    LDRB R11, [R1,#8]   ; Cell 9
    
    ; Now process the cell number we're checking
    CMP R12, #0
    BEQ CHECK_CELL1
    CMP R12, #1
    BEQ CHECK_CELL2
    CMP R12, #2
    BEQ CHECK_CELL3
    CMP R12, #3
    BEQ CHECK_CELL4
    CMP R12, #4
    BEQ CHECK_CELL5
    CMP R12, #5
    BEQ CHECK_CELL6
    CMP R12, #6
    BEQ CHECK_CELL7
    CMP R12, #7
    BEQ CHECK_CELL8
    CMP R12, #8
    BEQ CHECK_CELL9
    
    ; Invalid cell number - return 1 (occupied)
    MOV R0, #1
    B IS_FULL_COMPAT_EXIT
    
CHECK_CELL1
    MOV R0, R3
    B CHECK_CELL_VALUE
    
CHECK_CELL2
    MOV R0, R4
    B CHECK_CELL_VALUE
    
CHECK_CELL3
    MOV R0, R5
    B CHECK_CELL_VALUE
    
CHECK_CELL4
    MOV R0, R6
    B CHECK_CELL_VALUE
    
CHECK_CELL5
    MOV R0, R7
    B CHECK_CELL_VALUE
    
CHECK_CELL6
    MOV R0, R8
    B CHECK_CELL_VALUE
    
CHECK_CELL7
    MOV R0, R9
    B CHECK_CELL_VALUE
    
CHECK_CELL8
    MOV R0, R10
    B CHECK_CELL_VALUE
    
CHECK_CELL9
    MOV R0, R11
    
CHECK_CELL_VALUE
    CMP R0, #0          ; Check if the cell is empty (0)
    MOVEQ R0, #0        ; If empty, return 0
    MOVNE R0, #1        ; If not empty, return 1
    
IS_FULL_COMPAT_EXIT
    POP {R1-R12, PC}

    ; Adding LTORG here to handle potential branch distance issues
    LTORG

DRAW_X_BOARD  ; ASSUME R0 CARRY POS R1->X R2->Y  
    PUSH {R0-R12, LR}


	
    ; Load current board state
    LDR R12, =GAME_BOARD
    LDRB R3, [R12]    ; Cell 1
    LDRB R4, [R12,#1]    ; Cell 2
    LDRB R5, [R12,#2]    ; Cell 3
    LDRB R6, [R12,#3]    ; Cell 4
    LDRB R7, [R12,#4]    ; Cell 5
    LDRB R8, [R12,#5]    ; Cell 6
    LDRB R9, [R12,#6]    ; Cell 7
    LDRB R10, [R12,#7]   ; Cell 8
    LDRB R11, [R12,#8]   ; Cell 9
	
	BL GET_POS

    ; Determine which cell to draw based on R0
    CMP R0, #1
    BEQ CELL1
    CMP R0, #2
    BEQ CELL2
    CMP R0, #3
    BEQ CELL3
    CMP R0, #4
    BEQ CELL4
    CMP R0, #5
    BEQ CELL5
    CMP R0, #6
    BEQ CELL6
    CMP R0, #7
    BEQ CELL7
    CMP R0, #8
    BEQ CELL8
    CMP R0, #9
    BEQ CELL9
    B FINISH        

CELL1
    CMP R3,#0
    LDREQ R0,=WHITE
    MOVEQ R3,#1
    BLEQ DRAW_X
    B FINISH
    
CELL2
    CMP R4,#0
    LDREQ R0,=WHITE
    MOVEQ R4,#1
    BLEQ DRAW_X
    B FINISH
    
CELL3
    CMP R5,#0
    LDREQ R0,=WHITE
    MOVEQ R5,#1
    BLEQ DRAW_X
    B FINISH
    
CELL4
    CMP R6,#0
    LDREQ R0,=WHITE
    MOVEQ R6,#1
    BLEQ DRAW_X
    B FINISH
    
CELL5
    CMP R7,#0
    LDREQ R0,=WHITE
    MOVEQ R7,#1
    BLEQ DRAW_X
    B FINISH
    
CELL6
    CMP R8,#0
    LDREQ R0,=WHITE
    MOVEQ R8,#1
    BLEQ DRAW_X
    B FINISH
    
CELL7
    CMP R9,#0
    LDREQ R0,=WHITE
    MOVEQ R9,#1
    BLEQ DRAW_X
    B FINISH
    
CELL8
    CMP R10,#0
    LDREQ R0,=WHITE
    MOVEQ R10,#1
    BLEQ DRAW_X
    B FINISH
    
CELL9
    CMP R11,#0
    MOVEQ R11,#1
    LDREQ R0,=WHITE
    BLEQ DRAW_X

FINISH
    LDR R12, =GAME_BOARD  ; Reset pointer to start of GAME_BOARD
    STRB R3, [R12]    ; Cell 1
    STRB R4, [R12,#1]    ; Cell 2
    STRB R5, [R12,#2]    ; Cell 3
    STRB R6, [R12,#3]    ; Cell 4
    STRB R7, [R12,#4]    ; Cell 5
    STRB R8, [R12,#5]    ; Cell 6
    STRB R9, [R12,#6]    ; Cell 7
    STRB R10, [R12,#7]   ; Cell 8
    STRB R11, [R12,#8]   ; Cell 9
    POP  {R0-R12, PC}
    
    LTORG    ; Place literal pool herele potential branch distance issues



DRAW_O_BOARD  ; ASSUME R0 CARRY POS R1->X R2->Y  
    PUSH{R0-R12,LR}

    LDR R12, =GAME_BOARD
    LDRB R3, [R12]       ; Cell 1
    LDRB R4, [R12,#1]    ; Cell 2
    LDRB R5, [R12,#2]    ; Cell 3
    LDRB R6, [R12,#3]    ; Cell 4
    LDRB R7, [R12,#4]    ; Cell 5
    LDRB R8, [R12,#5]    ; Cell 6
    LDRB R9, [R12,#6]    ; Cell 7
    LDRB R10, [R12,#7]   ; Cell 8
    LDRB R11, [R12,#8]   ; Cell 9
    
    BL GET_POS
    
    CMP R0,#1
    BEQ CELL_1
    
    CMP R0,#2
    BEQ CELL_2
    
    CMP R0,#3
    BEQ CELL_3
    
    CMP R0,#4
    BEQ CELL_4
    
    CMP R0,#5
    BEQ CELL_5
    
    CMP R0,#6
    BEQ CELL_6
    
    CMP R0,#7
    BEQ CELL_7
    
    CMP R0,#8
    BEQ CELL_8
    
    CMP R0,#9
    BEQ CELL_9

CELL_1
    CMP R3,#0
    LDREQ R0,=WHITE
    MOVEQ R3,#2
    BLEQ DRAW_O      
    B FINISHO
    
CELL_2
    CMP R4,#0
    LDREQ R0,=WHITE
    MOVEQ R4,#2
    BLEQ DRAW_O       
    B FINISHO
    
CELL_3
    CMP R5,#0
    LDREQ R0,=WHITE
    MOVEQ R5,#2
    BLEQ DRAW_O      
    B FINISHO
    
CELL_4
    CMP R6,#0
    LDREQ R0,=WHITE
    MOVEQ R6,#2
    BLEQ DRAW_O      
    B FINISHO
    
CELL_5
    CMP R7,#0
    LDREQ R0,=WHITE
    MOVEQ R7,#2
    BLEQ DRAW_O      
    B FINISHO
    
CELL_6
    CMP R8,#0
    LDREQ R0,=WHITE
    MOVEQ R8,#2
    BLEQ DRAW_O      
    B FINISHO
    
CELL_7
    CMP R9,#0
    LDREQ R0,=WHITE
    MOVEQ R9,#2
    BLEQ DRAW_O      
    B FINISHO
    
CELL_8
    CMP R10,#0
    LDREQ R0,=WHITE
    MOVEQ R10,#2
    BLEQ DRAW_O     
    B FINISHO
    
CELL_9
    CMP R11,#0
    MOVEQ R11,#2
    LDREQ R0,=WHITE
    BLEQ DRAW_O     
    
FINISHO
    LDR R12, =GAME_BOARD  ; Reset pointer to start of GAME_BOARD
    STRB R3, [R12]    ; Cell 1
    STRB R4, [R12,#1]    ; Cell 2
    STRB R5, [R12,#2]    ; Cell 3
    STRB R6, [R12,#3]    ; Cell 4
    STRB R7, [R12,#4]    ; Cell 5
    STRB R8, [R12,#5]    ; Cell 6
    STRB R9, [R12,#6]    ; Cell 7
    STRB R10, [R12,#7]   ; Cell 8
    STRB R11, [R12,#8]   ; Cell 9
    POP {R0-R12, PC}

    ; Adding LTORG here to handle potential branch distance issues
    LTORG
    


CHECK_WIN  ; OUTPUT: R0 = 0 (NO WIN), 1 (X WINS), 2 (O WINS) AND RETURN WINING LINE
    PUSH {R1-R7,R9-R12, LR}
    
    ; LOAD THE BOARD INTO REGISTERS FOR EASIER MANIPULATION
    LDR R12, =GAME_BOARD
    LDRB R2, [R12]    ; CELL 1
    LDRB R3, [R12,#1]    ; CELL 2
    LDRB R4, [R12,#2]    ; CELL 3
    LDRB R5, [R12,#3]    ; CELL 4
    LDRB R6, [R12,#4]    ; CELL 5
    LDRB R7, [R12,#5]    ; CELL 6
    LDRB R8, [R12,#6]    ; CELL 7
    LDRB R9, [R12,#7]   ; CELL 8
    LDRB R10,[R12,#8]   ; CELL 9
    ; LOAD CURRENT PLAYER
    LDR R11, =CURRENT_PLAYER
    LDRB R11, [R11]         ; R11 = CURRENT PLAYER (1 OR 2)
    
    MOV R0, #0              ; DEFAULT RETURN VALUE (NO WIN)
    
    ; CHECK ROWS
    ; FIRST ROW (0,1,2)
    CMP R2, R11
    BNE CHECK_ROW2
    CMP R3, R11
    BNE CHECK_ROW2
    CMP R4, R11
    BNE CHECK_ROW2
    MOV R0, R11             ; WIN FOUND
    MOV R8,#1               ; ROW 1 IS THE WIN LINE
    B CHECK_DONE
    
CHECK_ROW2
    ; SECOND ROW (3,4,5)
    CMP R5, R11
    BNE CHECK_ROW3
    CMP R6, R11
    BNE CHECK_ROW3
    CMP R7, R11
    BNE CHECK_ROW3
    MOV R0, R11             ; WIN FOUND
    MOV R8,#2              ; ROW 2 IS THE WIN LINE
    B CHECK_DONE
    
CHECK_ROW3
    ; THIRD ROW (6,7,8)
    CMP R8, R11
    BNE CHECK_COL1
    CMP R9, R11
    BNE CHECK_COL1
    CMP R10, R11
    BNE CHECK_COL1
    MOV R0, R11             ; WIN FOUND
    MOV R8,#3              ; ROW 3 IS THE WIN LINE
    B CHECK_DONE
    
CHECK_COL1
    ; FIRST COLUMN (0,3,6)
    CMP R2, R11
    BNE CHECK_COL2
    CMP R5, R11
    BNE CHECK_COL2
    CMP R8, R11
    BNE CHECK_COL2
    MOV R0, R11             ; WIN FOUND
    MOV R8,#4              ; COL 1 IS THE WIN LINE
    B CHECK_DONE
    

CHECK_COL2
    ; SECOND COLUMN (1,4,7)
    CMP R3, R11
    BNE CHECK_COL3
    CMP R6, R11
    BNE CHECK_COL3
    CMP R9, R11
    BNE CHECK_COL3
    MOV R0, R11             ; WIN FOUND
    MOV R8,#5               ; COL 2 IS THE WIN LINE
    B CHECK_DONE
    
CHECK_COL3
    ; THIRD COLUMN (2,5,8)
    CMP R4, R11
    BNE CHECK_DIAG1
    CMP R7, R11
    BNE CHECK_DIAG1
    CMP R10, R11
    BNE CHECK_DIAG1
    MOV R0, R11             ; WIN FOUND
    MOV R8,#6               ; COL 3 IS THE WIN LINE
    B CHECK_DONE
    
CHECK_DIAG1
    ; FIRST DIAGONAL (0,4,8)
    CMP R2, R11
    BNE CHECK_DIAG2
    CMP R6, R11
    BNE CHECK_DIAG2
    CMP R10, R11
    BNE CHECK_DIAG2
    MOV R0, R11             ; WIN FOUND
    MOV R8,#7              ; DIAG 1 IS THE WIN LINE
    B CHECK_DONE
    
CHECK_DIAG2
    ; SECOND DIAGONAL (2,4,6)
    CMP R4, R11
    BNE CHECK_DONE
    CMP R6, R11
    BNE CHECK_DONE
    CMP R8, R11
    BNE CHECK_DONE
    MOV R0, R11             ; WIN FOUND
    MOV R8,#8               ; DIAG 2 IS THE WIN LINE
    
CHECK_DONE
    POP {R1-R7,R9-R12, PC}
	LTORG



GET_INPUT ;ASSUME R1->CURRENT X , R2->CURRENT Y AND MOVE NEXT DIMENSION TO THEM TOO (BO->LEFT , B1->RIGHT, B2->DOWN, B3->UP,B4->SUMBIT)
    PUSH{R3-R12,LR}
    
	LDR R3,=GPIOB_BASE + GPIO_IDR
	MOV R5,R1 ;SAVE X
    MOV R6,R2 ;SAVE Y
    LDR R0,[R3]
    
    TST R0,#(1 << 5) 
    BNE MOVE_LEFT
    TST R0,#(1 << 6)
    BNE MOVE_RIGHT
    TST R0,#(1 << 8)
    BNE MOVE_DOWN
    TST R0,#(1 << 7)
    BNE MOVE_UP
	TST R0,#(1 << 4)
    BNE SUMBIT
    
    B EXIT ;NO CHANGE
    
MOVE_LEFT    
    CMP R1,#0
    MOVEQ R1,#212 ;BOUNDARY CHECK
	SUBNE R1,R1,#106
    BL delay
    B NO_CHANGE
    
MOVE_RIGHT    
    CMP R1,#212
    MOVEQ R1,#0   ;BOUNDARY CHECK    
    ADDNE R1,R1,#106  
    BL delay
    B NO_CHANGE

MOVE_DOWN
    CMP R2,#160
    MOVEQ R2,#0     ;BOUNDARY CHECK
    ADDNE R2,R2,#80  
    BL delay
    B NO_CHANGE

MOVE_UP
    CMP R2,#0
    MOVEQ R2,#160   ;BOUNDARY CHECK
    SUBNE R2,R2,#80 
    BL delay
    B NO_CHANGE
SUMBIT
	MOV R0,#15
    BL delay
    B EXIT
NO_CHANGE
    BL GET_POS
    BL IS_FULL
    CMP R0,#0
    BLNE FIND_EMPTY_CELL
    B EXIT  
EXIT    
    POP{R3-R12,PC}
	LTORG
	
DRAW_X_SELECTION ;R1=START X  R2=START Y
	PUSH{R0-R12,LR}

	LDR R0,=WHITE
	BL DRAW_X
	BL delay_LONG
	LDR R0,=LETTUCE
	BL DRAW_X
	BL delay_LONG
	
	POP{R0-R12,PC}
DRAW_O_SELECTION ;R1=START X  R2=START Y
	PUSH{R0-R12,LR}
	
	LDR R0,=WHITE
	BL DRAW_O
	BL delay_LONG
	LDR R0,=LETTUCE
	BL DRAW_O
	BL delay_LONG

	POP{R0-R12,PC}
DRAW_O
    ; R0 = Color
    ; R1 = Start X
    ; R2 = Start Y
	PUSH{R0-R12,LR}
	LTORG
	MOV R6,R1 ;SAVE X
	MOV R7,R2 ;SAVE Y
	
	ADD R3,R6,#20 ;X1
	ADD R4,R6,#85 ;X2
	ADD R1,R7,#10 ;Y1
 	ADD R2,R7,#70 ;Y2
	
	BL TFT_DRAW_RECT
	
	LDR R0,=LETTUCE
	ADD R3,R6,#25 ;X1
	ADD R4,R6,#80 ;X2
	ADD R1,R7,#15 ;Y1
 	ADD R2,R7,#65 ;Y2
	BL TFT_DRAW_RECT

	POP{R0-R12,PC}

DRAW_X
	; Inputs:
    ; R0 = Color
    ; R1 = Start X
    ; R2 = Start Y
    PUSH {R0-R12, LR}

    ; Save original values
    ADD R1,R1,#25
	ADD R2,R2,#10   
    MOV R5, R0      ; Color
    MOV R6, R1      ; StartX
    MOV R7, R2      ; StartY


    ; --------------------
    ; Draw X
    ; --------------------

    ; Diagonal 1: Top-left to bottom-right
    MOV R8, #0
X1_Loop
    ADD R3, R6, R8      ; X1 = StartX + i
    ADD R4, R3, #1      ; X2 = X1 + 1
    ADD R1, R7, R8      ; Y1 = StartY + i
    ADD R2, R1, #1      ; Y2 = Y1 + 1
    MOV R0, R5
    BL TFT_DRAW_RECT

    ADD R8, R8, #1
    CMP R8, #60
    BLT X1_Loop

    ; Diagonal 2: Top-right to bottom-left
    MOV R8, #0
X2_Loop
    ADD R3, R6, #60
    SUB R3, R3, R8      ; X1 = StartX + 4 - i
    ADD R4, R3, #1      ; X2 = X1 + 1
    ADD R1, R7, R8      ; Y1 = StartY + i
    ADD R2, R1, #1      ; Y2 = Y1 + 1
    MOV R0, R5
    BL TFT_DRAW_RECT

    ADD R8, R8, #1
    CMP R8, #60
    BLT X2_Loop

	POP{R0-R12,PC}
	LTORG


	LTORG
; *************************************************************
; TFT Initialization
; *************************************************************
	

TFT_INIT2
    PUSH {R0-R2, LR}

    ; Reset sequence
    LDR R1, =GPIOA_BASE + GPIO_ODR
    LDR R2, [R1]
    
    ; Reset low
    BIC R2, R2, #TFT_RST
    STR R2, [R1]
    BL delay
    
    ; Reset high
    ORR R2, R2, #TFT_RST
    STR R2, [R1]
    BL delay
   
    ; Set Pixel Format (16-bit)
    MOV R0, #0x3A
    BL TFT_WriteCommand
    MOV R0, #0x55
    BL TFT_WriteData
    
    ; Memory access control
    MOV R0, #0x36       ; MADCTL command
    BL TFT_WriteCommand
    MOV R0, #0xE8       ; Parameter value for orientation
    BL TFT_WriteData
    
    ; Sleep Out
    MOV R0, #0x11
    BL TFT_WriteCommand
    BL delay
    
    ; Display ON
    MOV R0, #0x29
    BL TFT_WriteCommand

    POP {R0-R2, PC}

	LTORG

; *************************************************************
; TFT Draw Rectangle (R0 = color, R1 = Y1, R2 = Y2, R3 = X1, R4 = X2)
; *************************************************************
TFT_DRAW_RECT 
    PUSH {R1-R12, LR}

    ; Save color
    MOV R5, R0
    
    ; Set Column Address (0-239)
    MOV R0, #0x2A
    BL TFT_WriteCommand
    ;HIGHER EIGHT BITS OF START COLUMN
    MOV R0, R3, LSR #8
    BL TFT_WriteData
    ;LOWER EIGHT BITS BITS OF START COLUMN
    MOV R0, R3
    BL TFT_WriteData
    ;HIGHER EIGHT BITS OF END COLUMN
    MOV R0, R4, LSR #8    
    BL TFT_WriteData
    ;LOWER EIGHT BITS OF END COLUMN
    MOV R0, R4      
    BL TFT_WriteData

    ; Set Page Address (0-319)
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, R1, LSR #8    
    BL TFT_WriteData
    ;LOWER EIGHT BITS OF START PAGE
    MOV R0, R1      
    BL TFT_WriteData
    MOV R0, R2, LSR #8    
    BL TFT_WriteData
    ;LOWER EIGHT BITS OF END PAGE
    MOV R0, R2      
    BL TFT_WriteData
    
    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; Prepare color bytes
    MOV R10, R5, LSR #8     ; High byte
    AND R9, R5, #0xFF      ; Low byte

    ; Calculate total pixels: (X2 - X1 + 1) * (Y2 - Y1 + 1)
    SUBS R7, R4, R3
    ADD R7, R7, #1    
    SUBS R8, R2, R1
    ADD R8, R8, #1    
    MUL R3, R8, R7
    
FillLoop
    ; Write high byte
    MOV R0, R10
    BL TFT_WriteData
    
    ; Write low byte
    MOV R0, R9
    BL TFT_WriteData
    
    SUBS R3, R3, #1
    BNE FillLoop

    POP {R1-R12, PC}
	

; Define register base addresses
RCC_BASE        EQU     0x40023800
GPIOA_BASE      EQU     0x40020000
GPIOB_BASE      EQU     0x40020400
; Define register offsets
RCC_AHB1ENR     EQU     0x30
GPIO_MODER      EQU     0x00
GPIO_OTYPER     EQU     0x04
GPIO_OSPEEDR    EQU     0x08
GPIO_PUPDR      EQU     0x0C
GPIO_IDR        EQU     0x10
GPIO_ODR        EQU     0x14

; Control Pins on Port A
TFT_RST         EQU     (1 << 8)
TFT_BCK         EQU     (1 << 9)
TFT_RD          EQU     (1 << 10)
TFT_WR          EQU     (1 << 11)
TFT_DC          EQU     (1 << 12)
TFT_CS          EQU     (1 << 15)


   

; *************************************************************
; Delay Functions
; *************************************************************

	LTORG
delay
    PUSH {R0, LR}
    LDR R0, =DELAY_LOWINTERVAL
delay_loop
    SUBS R0, R0, #1
    BNE delay_loop
    POP {R0, PC}
   
	
	
delay_LONG
    PUSH {R0, LR}
    LDR R0, =DELAY_INTERVALL
delay_loop_LONG
    SUBS R0, R0, #1
    BNE delay_loop_LONG
    POP {R0, PC}
   
	
	LTORG
	
    ENDFUNC
    END
