
	IMPORT 	TFT_Init
	IMPORT TFT_FillScreen
	IMPORT TFT_WriteCommand	
	IMPORT TFT_WriteData
	IMPORT  TFT_DrawImage
	IMPORT  apple
	IMPORT CONFIG
	IMPORT  GAME_BOY_LOOP


	AREA MYDATA, DATA, READWRITE
		
SNAKE SPACE 48
TAIL SPACE 1
FRUIT_ARRAY SPACE 40
	
	

    AREA MYCODE, CODE, READONLY
;Colors
Red     	EQU 0xF800  ; 11111 000000 00000
Green   	EQU 0x2d20  ; 00000 111111 00000
Blue    	EQU 0x001F  ; 00000 000000 11111
Yellow  	EQU 0xFFE0  ; 11111 111111 00000
White   	EQU 0xFFFF  ; 11111 111111 11111
Black   	EQU 0x0000  ; 00000 000000 00000 

; Define register base addresses
RCC_BASE        EQU     0x40023800
GPIOA_BASE      EQU     0x40020000 ; CHANGE THE ADDRESS TO THE CORRECT ONE (FOR: IBRAHIM ABOHOLA)
GPIOB_BASE      EQU     0x40020400

; Define register offsets
RCC_AHB1ENR     EQU     0x30
GPIO_MODER      EQU     0x00
GPIO_OTYPER     EQU     0x04
GPIO_OSPEEDR    EQU     0x08
GPIO_PUPDR      EQU     0x0C
GPIO_IDR        EQU     0x10
GPIO_ODR        EQU     0x14

; Control Pins on Port E
TFT_RST         EQU     (1 << 8)
TFT_RD          EQU     (1 << 10)
TFT_WR          EQU     (1 << 11)
TFT_DC          EQU     (1 << 12)
TFT_CS          EQU     (1 << 15)

DELAY_INTERVAL  EQU     0x18604


    EXPORT snake
	
			

snake FUNCTION
	
	
    BL CONFIG
    ; Initialize TFT
    BL TFT_Init
	
	
    ; Fill screen with color 
    MOV R0, #Black
    BL TFT_FillScreen
	
		B SKIP_THIS1
	LTORG
SKIP_THIS1




	
FRUIT_INIT
    LDR R0, =FRUIT_ARRAY     ; R0 = base address of fruit_array
	
    MOV R1, #20     ; (320,240)
	MOV R2,#320
    STRH R1, [R0,#2]
	STRH R2, [R0]

    MOV R1, #60     ; (50,50)
	MOV R2,#40
    STRH R1, [R0,#6]
	STRH R2, [R0,#4]

    MOV R1, #200     ; (70,200)
	MOV R2,#80
    STRH R1, [R0,#10]
	STRH R2, [R0,#8]

    MOV R1, #60     ; (250,60)
	MOV R2,#260
    STRH R1, [R0,#14]
	STRH R2, [R0,#12]

    MOV R1, #220     ; (170,229)
	MOV R2,#180
    STRH R1, [R0,#18]
	STRH R2, [R0,#16]
	
	MOV R1, #20     ; (20,20)
	MOV R2,#20
    STRH R1, [R0,#22]
	STRH R2, [R0,#20]
	
	MOV R1, #200     ; (300,200)
	MOV R2,#300
    STRH R1, [R0,#26]
	STRH R2, [R0,#24]
	
	MOV R1, #120     ; (150,120)
	MOV R2,#140
    STRH R1, [R0,#30]
	STRH R2, [R0,#28]
	
	MOV R1, #220     ; (10,220)
	MOV R2,#20
    STRH R1, [R0,#34]
	STRH R2, [R0,#32]
	
	MOV R1, #200     ; (300,200)
	MOV R2, #320
    STRH R1, [R0,#38]
	STRH R2, [R0,#36]
	
	;;;;;;;;;;;;;;;
	;; TAIL INIT ;;
	;;;;;;;;;;;;;;;
	LDR R1, =TAIL
	MOV R2,#0
	STRB R2,[R1]
	;;;;;;;;;;;;;
	B SKIP_THIS
	LTORG
SKIP_THIS

	LDR R0, = FRUIT_ARRAY
	LDRB R2,[R1]
	MOV R2,R2, LSL #2
	ADD R2,R2,#2
	MOV R5,#0
	LDRH R5,[R0,R2]
	SUB R2,R2,#2
	MOV R6,#0
	LDRH R6,[R0,R2]
	SUB R1,R5,#20
	SUB R2,R6,#20
	LDR R3,=apple
	BL TFT_DrawImage
	
	; need to move that to green square

	MOV R1,#Yellow
	LDR R0, =SNAKE
	LDR R2,=0x00140014
	STR R2,[R0]
	MOV R5, #0
	LDRH R5, [R0, #2]
	MOV  R6, #0
	LDRH R6,[R0]
	MOV R2,#20  ; LENGTH
	BL TFT_DrawSquare

	MOV R7,#0
	
MAIN_LOOP	
	
	MOV R3,#Yellow
	MOV R1,#Black
	BL GET_state
	MOV R2,#20
	BL TFT_ReDrawSquare
	BL delay
	BL CHECK_BOUNDRY
	BL CHECK_FRUIT
	BL delay

WIN_CHECK
	LDR R1, =TAIL
	MOV R2,#0
	LDRB R2,[R1]
	CMP R2,#10
	BEQ.W WIN
CHECK_LOSE
	LDR R1, =TAIL
	MOV R2,#0
	LDRB R2,[R1]
	CMP R2,#2
	BLT RETURN 
	BL GET_HEAD
 	LDR R0,=SNAKE
CHECK_COLLISION_LOOP
	MOV R8,#0
	MOV R9,#0
	MOV R10,R2
	SUB R2,R2,#1
	MOV R10,R10,LSL #2
	ADD R10,R10,#2
	LDRH R8,[R0,R10]  ;; Y OF THE CURRENT SQUARE
	SUB R10,R10,#2
	LDRH R9,[R0,R10]  ;; X OF THE CURRENT SQUARE
	CMP R5,R8
	BNE NOT
	CMP R6,R9
	BNE NOT
	BEQ.W LOSE

NOT
	CMP R2,#2
	BGT CHECK_COLLISION_LOOP
	
RETURN
	BL delay
	B MAIN_LOOP
END_GAME
	BL delay
	BL delay
	BL delay
	BL delay
	BL delay
	BL delay
	BL delay
	BL delay
	BL delay
	BL delay
	
	B GAME_BOY_LOOP
    B .





; *************************************************************
; Draw Square at (Y=R5, X=R6 ,Color=R1 , LENGTH = R2)
; *************************************************************
TFT_DrawSquare
    PUSH {R0-R12, LR}
    
	 MOV R8, R1
    ; Set Column Address (0-239)
    MOV R0, #0x2A
	SUBS R5,R5,R2
    BL TFT_WriteCommand
	MOV R0, R5, LSR #8
    BL TFT_WriteData
	MOV R0, R5
    BL TFT_WriteData
	ADDS R5,R5,R2
    MOV R0, R5, LSR #8
    BL TFT_WriteData
    MOV R0, R5    ; 239
    BL TFT_WriteData

	SUBS R6,R6,R2
    ; Set Page Address (0-319)
    MOV R0, #0x2B
    BL TFT_WriteCommand
	MOV R0, R6, LSR #8
    BL TFT_WriteData
	MOV R0, R6
    BL TFT_WriteData
	ADDS R6,R6,R2
    MOV R0, R6, LSR #8
    BL TFT_WriteData
    MOV R0, R6    ; 239
    BL TFT_WriteData

    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand
	
	MOV R3,R2
    ; Prepare color bytes
    MOV R1, R8, LSR #8     ; High byte
    AND R4, R8, #0xFF      ; Low byte
	
    MUL R3,R3,R3
FillLoop2
    ; Write high byte
    MOV R0, R1
    BL TFT_WriteData
    
    ; Write low byte
    MOV R0, R4
    BL TFT_WriteData
    
    SUBS R3, R3, #1
    BNE FillLoop2

    POP {R0-R12, LR}
    BX LR



; *************************************************************
; ReDraw Square Centered at (Y = R5, X = R6, LENGTH = R2 ,ColorBackground=R1, ColorSquare=R3,Direction=R7 (4->Up 3->Down 2->Left 1->right))
; *************************************************************
TFT_ReDrawSquare
	PUSH{R0-R3,LR}
	
	MOV R2,#20  ; LENGTH
	CMP R7,#0
	BEQ.W SKIP
	CMP R7,#1
	BEQ.W MOVE_RIGHT
	CMP R7,#2
	BEQ.W MOVE_LEFT
	CMP R7,#3
	BEQ.W MOVE_DOWN
	CMP R7,#4
	BEQ.W MOVE_UP
MOVE_RIGHT
	BL REMOVE_TAIL
	BL delay
	BL delay
	BL delay
	BL delay
	BL GET_HEAD
	ADD R6,R6,#20
	MOV R1,R3
	BL MOVE
	BL MODIFY_HEAD
	BL TFT_DrawSquare
	BL delay
	BL delay
	BL delay
	BL delay
	B SKIP
MOVE_LEFT
	BL REMOVE_TAIL
	BL delay
	BL delay
	BL delay
	BL delay
	BL GET_HEAD
	SUB R6,R6,#20
	MOV R1,R3
	BL MOVE
	BL MODIFY_HEAD
	BL TFT_DrawSquare
	 BL delay
	 BL delay
	 BL delay
	 BL delay
	B SKIP
MOVE_DOWN
	BL REMOVE_TAIL
	BL delay
	BL delay
	BL delay
	BL delay
	BL GET_HEAD
	SUB R5,R5,#20
	MOV R1,R3
	BL MOVE
	BL MODIFY_HEAD
	BL TFT_DrawSquare
	BL delay
	BL delay
	BL delay
	BL delay
	B SKIP
MOVE_UP
	BL REMOVE_TAIL
	BL delay
	BL delay
	BL delay
	BL delay
	BL GET_HEAD
	ADD R5,R5,#20
	MOV R1,R3
	BL MOVE
	BL MODIFY_HEAD
	BL TFT_DrawSquare
	BL delay
	BL delay
	BL delay
	B SKIP

SKIP
	
	pop{R0-R3,PC}

  LTORG
; *************************************************************
; Win screen 
; *************************************************************
WIN
	MOV R0, #Yellow
    BL TFT_FillScreen
	B END_GAME

; *************************************************************
; Lose screen with Red Color
; *************************************************************
LOSE 
	; Fill screen with color 
    MOV R0, #Red
    BL TFT_FillScreen
	
	B END_GAME


REMOVE_TAIL
	PUSH{R0,R4,R8,LR}
	LDR R4, =TAIL
	LDR R0, =SNAKE
	MOV R8,#0
	LDRB R8,[R4] ; GET THE CURRENT TAIL
	MOV R8,R8, LSL #2  ; MULTIPLY THE TAIL BY 4 TO GET ITS LOCATION IN THE SNAKE ARRAY
	ADD R8,R8,#2
	MOV R5, #0
	LDRH R5,[R0,R8]
	SUB R8,R8,#2
	MOV  R6, #0
	LDRH R6,[R0,R8]
	BL TFT_DrawSquare
	POP {R0,R4,R8,PC}
GET_HEAD
	PUSH{R0,LR}
	LDR R0,=SNAKE
	MOV R5, #0
	LDRH R5, [R0, #2]
	MOV  R6, #0
	LDRH R6,[R0]	
	POP {R0,PC}

MODIFY_HEAD
	PUSH{R0,LR}
	LDR R0,=SNAKE
	STRH R5, [R0, #2]
	STRH R6,[R0]	
	POP {R0,PC}


MOVE
	PUSH{R0-R12,LR}
	LDR R0,=SNAKE
	LDR R1,=TAIL
	MOV R2,#0
	LDRB R2,[R1]
	CMP R2,#0
	BEQ END_MOVE
	
MOVE_LOOP
	SUB R2,R2,#1
	MOV R8,R2
	MOV R8,R8,LSL #2
	MOV R3,#0
	MOV R4,#0
	MOV R5,#0
	MOV R6,#0
	ADD R8,R8,#2
	LDRH R3,[R0,R8]  ;;; Y OF THE PREVIOUS SQUARE
	SUB R8,R8,#2
	LDRH R4,[R0,R8]  ;;; X OF THE PREVIOUS SQUARE
	ADD R8,R8,#6
	STRH R3,[R0,R8]  ;;; Y OF CURRENT = Y OF PREVIOUS
	SUB R8,R8,#2
	STRH R4,[R0,R8]  ;;; X OF CURRENT = X OF PREVIOUS
	CMP R2,#0
	BNE MOVE_LOOP
END_MOVE

	POP{R0-R12,PC}

; *************************************************************
; GET STATE  (4->Up 3->Down 2->Left 1->right) In R7
; *************************************************************
GET_state
	PUSH {R0-R2,R8,R9,LR}
	LDR R0, =GPIOB_BASE + GPIO_IDR
    LDR R1, [R0]
	
	MOV R8,#0
	
	TST R1,#(1 << 5)
	MOVNE R8,#1
	BNE CHECK_STATE
	TST R1,#(1 << 6)
	MOVNE R8,#2
	BNE CHECK_STATE
	TST R1,#(1 << 7)
	MOVNE R8,#3
	BNE CHECK_STATE
	TST R1,#(1 << 8)
	MOVNE R8,#4
	;;;;;;;;;;;;;;;;
CHECK_STATE
	ADD R9,R8,R7
	CMP R9,#3
	BEQ END_STATE
	CMP R9,#7
	BEQ END_STATE
	CMP R8,#0
	BEQ END_STATE
	MOV R7,R8
	;;;;;;;;;;;;;;;;
	
END_STATE
	
    POP {R0-R2,R8,R9, PC}    

CHECK_BOUNDRY
	PUSH {R0-R3,LR}
	CMP R5,#20
	BLT OUT_Y
	CMP R5,#240
	BGT OUT_Y2 
	CMP R6,#20
	BLT OUT_X
	CMP R6,#320
	BGT OUT_X2
	B ENDCHECK
OUT_Y
	BL TFT_DrawSquare
	MOV R5,#240
	MOV R1,R3
	BL TFT_DrawSquare
	B ENDCHECK
OUT_Y2
	BL TFT_DrawSquare
	MOV R5,#1
	MOV R1,R3
	BL TFT_DrawSquare
	B ENDCHECK
OUT_X
	BL TFT_DrawSquare
	MOV R6,#320
	MOV R1,R3
	BL TFT_DrawSquare
	B ENDCHECK
OUT_X2
	BL TFT_DrawSquare
	MOV R6,#1
	MOV R1,R3
	BL TFT_DrawSquare
ENDCHECK
	BL MODIFY_HEAD
	POP{R0-R3,LR}
	BX LR
	
ADD_NEWSQUARE
	PUSH {R0-R12,LR}
	LDR R4, =TAIL
	LDR R0, =SNAKE
	MOV R8,#0
	LDRB R8,[R4] ; GET THE CURRENT TAIL
	MOV R9,R4
	MOV R10,R8
	MOV R8,R8, LSL #2  ; MULTIPLY THE TAIL BY 4 TO GET ITS LOCATION IN THE SNAKE ARRAY
	MOV R1, #0
	ADDS R8,R8,#2
	LDRH R1,[R0,R8] ;;; Y OF TAIL
	MOV  R2, #0
	SUBS R8,R8,#2
	LDRH R2,[R0,R8]     ;;; X OF TAIL
	BL GET_HEAD
	MOV R3,R6 ;;; X OF HEAD
	MOV R4,R5 ;;; Y OF HEAD
	CMP R3,R2
	BGT ADD_LEFT
	BLT ADD_RIGHT
	CMP R4,R1
	BGT ADD_DOWN
	BLT ADD_UP

SECOND_SQUARE
	CMP R7,#1
	BEQ ADD_RIGHT
	CMP R7,#2
	BEQ ADD_LEFT
	CMP R7,#3
	BEQ ADD_UP
	CMP R7,#4
	BEQ ADD_DOWN
	B END_ADD

ADD_LEFT
	MOV R5,R1  ;;; Y = Y OF TAIL
	SUBS R6,R2,#20 ;;; X = X OF TAIL - 20
	B END_ADD
ADD_RIGHT
	MOV R5,R1  ;;; Y = Y OF TAIL
	ADDS R6,R2,#20 ;;; X = X OF TAIL - 20
	B END_ADD
ADD_UP
	MOV R6,R2  ;;; X = X OF TAIL
	ADDS R5,R1,#20 ;;; Y = Y OF TAIL + 20 
	B END_ADD
ADD_DOWN
	MOV R6,R2  ;;; X = X OF TAIL
	SUBS R5,R1,#20 ;;; Y = Y OF TAIL - 20
	B END_ADD
END_ADD	
	MOV R1,#Yellow
	MOV R2,#20
	BL TFT_DrawSquare
	ADD R10,R10,#1
	STRB R10,[R9]
	ADD R8,R8,#6
	STRH R5, [R0,R8]
	SUBS R8,R8,#2
	STRH R6, [R0,R8]
	POP {R0-R12,PC}
	
	
CHECK_FRUIT
	PUSH{R0-R12,LR}
	
	
	;;; R5 = Y OF HEAD
	;;; R6 = X OF HEAD
	LDR R0,=FRUIT_ARRAY
	LDR R1,=TAIL
	MOV R2,#0
	LDRB R2,[R1]
	MOV R2,R2,LSL #2
	ADD R2,R2,#2
	MOV R3,#0
	LDRH R3,[R0,R2]  ;;; Y OF THE CURRENT FRUIT
	SUB R2,R2,#2
	MOV R4,#0
	LDRH R4,[R0,R2]   ;;; X OF THE CURRENT FRUIT

	BL GET_HEAD
	SUBS R8,R5,R3
	CMP R8,#19
	BGT Continue
	CMP R8,#-19
	BLT Continue
	SUBS R9,R6,R4
	CMP R9,#19
	BGT Continue
	CMP R9,#-19
	BLT Continue
 
EAT
    MOV R5,R3
	MOV R6,R4
	MOV R2,#20
	MOV R1,#Black
	BL TFT_DrawSquare
	   
	BL ADD_NEWSQUARE
	   
	LDR R0,=FRUIT_ARRAY
	LDR R1,=TAIL
	MOV R2,#0
	LDRB R2,[R1]
	MOV R2,R2, LSL #2
	ADD R2,R2,#2
	MOV R5,#0
	LDRH R5,[R0,R2]
	SUB R2,R2,#2
	MOV R6,#0
	LDRH R6,[R0,R2]
	SUB R1,R5,#20
	SUB R2,R6,#20
	LDR R3,=apple
	BL TFT_DrawImage
	   
Continue
    
	POP {R0-R12,PC}
	
; *************************************************************


; *************************************************************
; Delay Functions
; *************************************************************
delay
    PUSH {R0, LR}
    LDR R0, =DELAY_INTERVAL
delay_loop
    SUBS R0, R0, #1
    BNE delay_loop
    POP {R0, LR}
    BX LR

    ENDFUNC
    END
