
    EXPORT PingPong

	IMPORT TFT_FillScreen
	IMPORT TFT_WriteCommand	
	IMPORT TFT_WriteData	
	IMPORT CONFIG
	IMPORT 	TFT_Init

        AREA    MyData, DATA, READWRITE

PADDLE_WIDTH         SPACE    2
PADDLE_HEIGHT        SPACE    2

; BALL DATA
BALL_X               SPACE    2
BALL_Y               SPACE    2
BALL_VELOCITY_X      SPACE    2
BALL_VELOCITY_Y      SPACE    2
BALL_COLOR           SPACE    2

; SCORE COUNT
P1_SCORE             SPACE    2
P2_SCORE             SPACE    2

; TWO PLAYER MODE PADDLE DATA
PADDLE_COLOR1        SPACE    2
PADDLE_COLOR2        SPACE    2

PADDLE_1_X1          SPACE    2
PADDLE_1_X2          SPACE    2
PADDLE_1_Y1          SPACE    2
PADDLE_1_Y2          SPACE    2

PADDLE_2_X1          SPACE    2
PADDLE_2_X2          SPACE    2
PADDLE_2_Y1          SPACE    2
PADDLE_2_Y2          SPACE    2
	

;Colors
Red     	EQU 0xF800  ; 11111 000000 00000
Green   	EQU 0x2d20  ; 00000 111111 00000
Blue    	EQU 0x001F  ; 00000 000000 11111
Yellow  	EQU 0xFFE0  ; 11111 111111 00000
White   	EQU 0xFFFF  ; 11111 111111 11111
Black   	EQU 0x0000  ; 00000 000000 00000 
BabyBlue    EQU 0x8ef9
Pink		EQU 0xfe59
Mario		EQU 0xc241

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

DELAY_INTERVAL  EQU     0x90000 
	AREA MyCode, CODE, READONLY
PingPong  FUNCTION

START_PING_PONG
 ; Initialize values
        LDR     R0, =PADDLE_WIDTH
        MOV     R1, #10
        STRH    R1, [R0]

        LDR     R0, =PADDLE_HEIGHT
        MOV     R1, #60
        STRH    R1, [R0]

        ; BALL
        LDR     R0, =BALL_X
        MOV     R1, #160
        STRH    R1, [R0]

        LDR     R0, =BALL_Y
        MOV     R1, #120
        STRH    R1, [R0]

        LDR     R0, =BALL_VELOCITY_X
        MOV     R1, #10
        STRH    R1, [R0]

        LDR     R0, =BALL_VELOCITY_Y
        MOV     R1, #10
        STRH    R1, [R0]

        LDR     R0, =BALL_COLOR
        MOV     R1, #Red         ; Make sure Red is defined with EQU
        STRH    R1, [R0]

        ; SCORE
        LDR     R0, =P1_SCORE
        MOV     R1, #0
        STRH    R1, [R0]

        LDR     R0, =P2_SCORE
        STRH    R1, [R0]         ; Already 0

        ; COLORS
        LDR     R0, =PADDLE_COLOR1
        MOV     R1, #Green       
        STRH    R1, [R0]

        LDR     R0, =PADDLE_COLOR2
        STRH    R1, [R0]

        ; PADDLE 1
        LDR     R0, =PADDLE_1_X1
        MOV     R1, #50
        STRH    R1, [R0]

        LDR     R0, =PADDLE_1_X2
        MOV     R1, #60
        STRH    R1, [R0]

        LDR     R0, =PADDLE_1_Y1
        MOV     R1, #100
        STRH    R1, [R0]

        LDR     R0, =PADDLE_1_Y2
        MOV     R1, #160
        STRH    R1, [R0]

        ; PADDLE 2
        LDR     R0, =PADDLE_2_X1
        MOV     R1, #260
        STRH    R1, [R0]

        LDR     R0, =PADDLE_2_X2
        MOV     R1, #270
        STRH    R1, [R0]

        LDR     R0, =PADDLE_2_Y1
        MOV     R1, #100
        STRH    R1, [R0]

        LDR     R0, =PADDLE_2_Y2
        MOV     R1, #160
        STRH    R1, [R0]

   BL CONFIG
    ; Initialize TFT
    BL TFT_Init

	
	;CLEAR THE SCREEN
	MOV R0, #Black
	BL TFT_FillScreen
	MOV R0, #0
	MOV R1, #0
	MOV R2, #0
	MOV R3, #0
	MOV R4, #0
	MOV R5, #0
	MOV R6, #0
	MOV R7, #0
	MOV R8, #0
	MOV R9, #0
	MOV R10, #0
	MOV R11, #0
	MOV R12, #0
	MOV R0, #Blue
	LDR R5,=PADDLE_1_X1
	LDRH R1, [R5]
	LDR R6, =PADDLE_1_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_1_Y1
	LDRH R3 ,[R5]
	;MOV R4, R3
	LDR R6, =PADDLE_1_Y2
	LDRH R4, [R6]
	BL Draw_Rectangle
	
	MOV R0, #Green
	LDR R5,=PADDLE_2_X1
	LDRH R1, [R5]
	LDR R6, =PADDLE_2_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_2_Y1
	LDRH R3 ,[R5]
	LDR R6, =PADDLE_2_Y2
	LDRH R4, [R6]
	BL Draw_Rectangle

MAIN_LOOP	
	BL PING_PONG_MOVE_PLAYERS
	BL delay

	BL BALL_CHECK_MOVE
	BL delay

	
CHECK_PLAYER_1_WIN
	LDR R2, =P1_SCORE
    LDRH R3, [R2]
    CMP R3,#3
	BGE.W PLAYER_1_WIN
	
CHECK_PLAYER_2_WIN
	LDR R2, =P2_SCORE
    LDRH R3, [R2]
    CMP R3,#3
	BGE.W PLAYER_2_WIN	
	B MAIN_LOOP
	
END_PING_GAME

    B .


	
	; *************************************************************
; Draw Square Center at (y=R5, x=R6 ,Color=R1)
; *************************************************************


TFT_DrawSquare
    PUSH {LR}
    ;TODO
	MOV R8, R5
    SUB R8, R8, #5      ; x_start
    ADD R10, R5, #5     ; x_end

    MOV R9, R6
    SUB R9, R9, #5      ; y_start
    ADD R11, R6, #5     ; y_end

    ; Set Column Address
    MOV R0, #0x2A
    BL TFT_WriteCommand
    MOV R0, R8, LSR #8
    BL TFT_WriteData
    MOV R0, R8
    BL TFT_WriteData
    MOV R0, R10, LSR #8
    BL TFT_WriteData
    MOV R0, R10
    BL TFT_WriteData

    ; Set Page Address
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, R9, LSR #8
    BL TFT_WriteData
    MOV R0, R9
    BL TFT_WriteData
    MOV R0, R11, LSR #8
    BL TFT_WriteData
    MOV R0, R11
    BL TFT_WriteData

    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; Prepare color bytes
    MOV R2, R1, LSR #8  ; High byte
    AND R3, R1, #0xFF   ; Low byte

    ; Write pixels (width = 10, height = 10)
    MOV R4, #100
DrawSquare_Loop
    MOV R0, R2
    BL TFT_WriteData
    MOV R0, R3
    BL TFT_WriteData
    SUBS R4, R4, #1
    BNE DrawSquare_Loop
	POP {LR}
    BX LR
	
	B SKIP_THIS
		LTORG
SKIP_THIS
	
delay
    PUSH {R0, LR}
    LDR R0, =DELAY_INTERVAL
delay_loop
    SUBS R0, R0, #1
    BNE delay_loop
    POP {R0, LR}
    BX LR
;*******************************************
;THIS FUNCTION STARTS THE GAME BY DRAWING THE PLAYER AND THE BALL
;*******************************************
	
PING_PONG_MODE

	PUSH {R0-R12, LR}
	
	;CLEAR THE SCREEN
	MOV R0, #Black
	BL TFT_FillScreen

	
	MOV R0, #Blue
	LDR R5,=PADDLE_1_Y1
	LDRH R1, [R5]
	LDR R6, =PADDLE_1_Y2
	LDRH R2, [R6]
	LDR R5,=PADDLE_1_X1
	LDRH R3 ,[R5]
	LDR R6, =PADDLE_1_X2
	LDRH R4, [R6]
	BL Draw_Rectangle
	

	;DARWS PLAYER 2
	MOV R0, #Green
	LDR R5,=PADDLE_2_Y1
	LDRH R1, [R5]
	LDR R6, =PADDLE_2_Y2
	LDRH R2, [R6]
	LDR R5,=PADDLE_2_X1
	LDRH R3 ,[R5]
	LDR R6, =PADDLE_2_X2
	LDRH R4, [R6]
	BL Draw_Rectangle
	
	;DRAW THE BALL
	MOV R0, #Red
	LDR R5,=BALL_Y
	LDRH R1, [R5]
	MOV R2, R1
	ADD R2, #0x10 
	LDR R5,=BALL_X
	LDRH R3, [R5]
	MOV R4, R3
	ADD R4, #0x10
	BL Draw_Rectangle
	
	POP {R0-R12, PC}
	
			B SKIP2
		LTORG
SKIP2

;***********************************
; THIS FUNCTION HANDELS MOVEMENT FOR PLAYERS
;***********************************
PING_PONG_MOVE_PLAYERS
	PUSH {R0-R12, LR}
	; Read Key Inputs (Returns in R0 and R1: 0=none, R0 = 1=key5, R0 = 2=key6, R1 = 1=key7, R1 = 2=key8)
	BL PING_PONG_READ_KEYS 
	
	MOV R7, R1			; STORE THE VALUE OF R1 BECAUSE R1 WILL BE USED IN DRAW_RECT 
	
	CMP R0, #1 			; CHECK IF PLAYER 1 IS MOVING DOWN
	BNE PLAYER_1_DOWN		; IF NOT, CHECK UP
	;TODO: CHECK IF THE PLAYER REACHED Y = 240 (END OF SCREEN)
	LDR R5, =PADDLE_1_Y2	;TODO: CHECK IF THE PLAYER REACHED Y = 200 (END OF SCREEN)
	LDRH R1, [R5]
	CMP R1, #240
	BGE END_MOVE_PLAYER_1

	
	MOV R0, #Black
	LDR R5,=PADDLE_1_X1
	LDRH R1, [R5]
	LDR R6, =PADDLE_1_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_1_Y1
	LDRH R3 ,[R5]
	LDR R6, =PADDLE_1_Y2
	LDRH R4, [R6]
	BL Draw_Rectangle 
	
	MOV R0, #Blue
	LDR R5,=PADDLE_1_X1
	LDRH R1, [R5]
	LDR R6, =PADDLE_1_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_1_Y1
	LDRH R3 ,[R5]
	ADD R3, R3,#20	;ADDING 10 DECIMAL TO Y1
	STRH R3, [R5]	;STORING THE NEW POSITION OF PLAYER 1
	LDR R6, =PADDLE_1_Y2
	LDRH R4, [R6]
	ADD R4, R4, #20
	STRH R4, [R6]	
	BL Draw_Rectangle
	B END_MOVE_PLAYER_1
	

PLAYER_1_DOWN		
	CMP R0, #2 			; CHECK IF PLAYER 1 IS MOVING UP
	BNE END_MOVE_PLAYER_1; IF NOT, DO NOTHING TO PLAYER 1 AND CHECK PLAYER 2
	
	LDR R5, =PADDLE_1_Y1	;TODO: CHECK IF THE PLAYER REACHED Y = 0 (END OF SCREEN)
	LDRH R1, [R5]
	CMP R1, #0
	BLE END_MOVE_PLAYER_1
						; ERASES PLAYER 1 AND REDRAWS PLAYER 1 UP 10 PIXELS

	MOV R0, #Black
	LDR R5,=PADDLE_1_X1
	LDRH R1, [R5]
	LDR R6, =PADDLE_1_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_1_Y1
	LDRH R3 ,[R5]
	LDR R6, =PADDLE_1_Y2
	LDRH R4, [R6]
	BL Draw_Rectangle 
	; DONE ERASING PLAYER 1

	;NOW REDRAWING BUT Y1 IS DECREASED BY 10
	MOV R0, #Blue
	LDR R5,=PADDLE_1_X1
	LDRH R1, [R5]
	;TODO: CHECK IF PLAYER 1 REACHED TOP OF SCREEN Y1 = 0 (IT ISN'T REALLY Y = 0)
	LDR R6, =PADDLE_1_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_1_Y1
	LDRH R3 ,[R5]
	SUB R3, R3, #20	;SUBTRACTING 10 DECIMAL TO Y1 
	STRH R3, [R5]		;STORING THE NEW POSITION OF PLAYER 1	
	LDR R6, =PADDLE_1_Y2
	LDRH R4, [R6]
	SUB R4, R4, #20
	STRH R4, [R6]	
	BL Draw_Rectangle

END_MOVE_PLAYER_1
	
	CMP R7, #1 			; CHECK IF PLAYER 1 IS MOVING DOWN
	BNE PLAYER_2_DOWN		; IF NOT, CHECK UP
	
	LDR R5, =PADDLE_2_Y2	;TODO: CHECK IF THE PLAYER REACHED Y = 200 (END OF SCREEN)
	LDRH R1, [R5]
	CMP R1, #240
	BGE END_MOVE_PLAYER_2
	
	MOV  R1,#0
	MOV  R2,#0
	MOV  R3,#0
	MOV  R4,#0
	MOV R0, #Black
	LDR R5,=PADDLE_2_X1
	LDRH R1, [R5]
	LDR R6, =PADDLE_2_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_2_Y1
	LDRH R3 ,[R5]
	LDR R6, =PADDLE_2_Y2
	LDRH R4, [R6]
	BL Draw_Rectangle 
	; DONE ERASING PLAYER 1

	MOV R0, #Green
	LDR R5,=PADDLE_2_X1
	LDRH R1, [R5]	 
	LDR R6, =PADDLE_2_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_2_Y1
	LDRH R3 ,[R5]
	ADD R3, R3,#20	;ADDING 10 DECIMAL TO Y1
	STRH R3, [R5]	;STORING THE NEW POSITION OF PLAYER 2	
	LDR R6, =PADDLE_2_Y2
	LDRH R4, [R6]
	ADD R4 , R4, #20
	STRH R4, [R6]	
	BL Draw_Rectangle
	
	B END_MOVE_PLAYER_2
	
	
PLAYER_2_DOWN				; CHECK UP FOR PLAYER 2
	CMP R1, #2 			; CHECK IF PLAYER 2 IS MOVING UP
	BNE END_MOVE_PLAYER_2; IF NOT, DO NOTHING TO PLAYER 1 AND CHECK PLAYER 2
	
	LDR R5, =PADDLE_2_Y1	;TODO: CHECK IF THE PLAYER REACHED Y = 0 (END OF SCREEN)
	LDRH R1, [R5]
	CMP R1, #0
	BLE END_MOVE_PLAYER_2
	
						; ERASES PLAYER 2 AND REDRAWS PLAYER 2 UP 10 PIXELS

	MOV R0, #Black
	LDR R5,=PADDLE_2_X1
	LDRH R1, [R5]
	LDR R6, =PADDLE_2_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_2_Y1
	LDRH R3 ,[R5]
	LDR R6, =PADDLE_2_Y2
	LDRH R4, [R6]
	BL Draw_Rectangle 
	
	MOV R0, #Green
	LDR R5,=PADDLE_2_X1
	LDRH R1, [R5]
	;TODO: CHECK IF PLAYER 1 REACHED TOP OF SCREEN Y1 = 0 (IT ISN'T REALLY Y = 0)
	LDR R6, =PADDLE_2_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_2_Y1
	LDRH R3 ,[R5]
	SUB R3, R3, #20	;SUBTRACTING 10 DECIMAL TO Y1 
	STRH R3, [R5]		;STORING THE NEW POSITION OF PLAYER 1	
	LDR R6, =PADDLE_2_Y2
	LDRH R4, [R6]
	SUB R4, R4, #20
	STRH R4, [R6]
	BL Draw_Rectangle
	
END_MOVE_PLAYER_2	
	
	POP {R0-R12, PC}	
;****************************************
;THIS FUNCTION READS KEYS FOR PINGPONG GAME
; R0 --> PLAYER 1, 0 NO KEY PRESSED, 1 WHEN KEY 5 IS PRESSED, 2 WHEN 6
; R1 --> PLAYER 2, 0 NO KEY PRESSED, 1 WHEN KEY 7 IS PRESSED, 2 WHEN 8 
;****************************************
PING_PONG_READ_KEYS
    PUSH {R2, LR}              ; Save registers
    
    LDR R1, =GPIOB_BASE + GPIO_IDR  ; Load GPIOB input data register address
    LDR R2, [R1]               ; Read the value from GPIOB input data register

    ; Check each key pin (PB5-PB8)
    TST R2, #(1 << 5)         ; Test key5 (PB0) bit
    BEQ PING_PONG_CheckKey2              ; If key5 is not pressed, check key6
    MOV R0, #1                 ; If key5 is pressed, return 1
    B PING_PONG_CheckKey3                ; Return
;***************************************************
; Read Key Inputs For Ping  Pong Game (Returns in R0 and R1: 0=none, R0 = 1=key1, R0 = 2=key2, R1 = 1=key3, R1 = 2=key4)
;***************************************************
PING_PONG_CheckKey2
    TST R2, #(1 << 6)        ; Test key6 (PB1) bit
    BEQ NoKeyPressedForPlayer1 ; If key6 is not pressed, check key7
    MOV R0, #2                 ; If key6 is pressed, return 2
    B PING_PONG_CheckKey3                ; Return

NoKeyPressedForPlayer1
    MOV R0, #0                 ; Return 0 if no key is pressed
    ;POP {R1, LR}              ; Restore registers
    ;BX LR 

PING_PONG_CheckKey3
    TST R2, #(1 << 7)          ; Test key7 (PB2) bit
    BEQ PING_PONG_CheckKey4              ; If key7 is not pressed, check key8
    MOV R1, #1                  ; If key7 is pressed, return 1
    B END_PING_PONG_READ_KEYS   ; Return

PING_PONG_CheckKey4
    TST R2, #(1 << 8)          ; Test key8 (PB3) bit
    BEQ NoKeyPressedForPlayer2           ; If key8 is not pressed, no key is pressed
    MOV R1, #2                 ; If key4 is pressed, return 2
    B END_PING_PONG_READ_KEYS  ; Return

NoKeyPressedForPlayer2
    MOV R1, #0                 ; Return 0 if no key is pressed
END_PING_PONG_READ_KEYS	
    POP {R2, LR}               ; Restore registers
    BX LR                      ; Return
;************************************
;************************************
BALL_CHECK_MOVE
        PUSH {R0-R12, LR}

        ; === Erase old ball ===
        MOV R1, #Black
		LDR R2, =BALL_Y
        LDRH R5, [R2]
		LDR R2, =BALL_X
        LDRH R6, [R2]
        BL TFT_DrawSquare

        ; === Update Ball Position ===
        ; X_BALL += VELOCITY_X
        LDR     R0, =BALL_X
        LDRH    R1, [R0]
        LDR     R2, =BALL_VELOCITY_X
        LDRH    R3, [R2]
        ADD     R1, R1, R3
        STRH    R1, [R0]

        ; Y_BALL += VELOCITY_Y
        LDR     R0, =BALL_Y
        LDRH    R1, [R0]
        LDR     R2, =BALL_VELOCITY_Y
        LDRH    R3, [R2]
        ADD     R1, R1, R3
        STRH    R1, [R0]


        ; === Draw updated ball ===
        MOV R1, #Red
		LDR R5, =BALL_Y
        LDRH R5, [R5]
		LDR R6, =BALL_X
        LDRH R6, [R6]
        BL TFT_DrawSquare

		MOV R4,#0
		MOV R5,#0
        ; === Load BALL X into R4 and BALL Y into R5 ===
        LDR     R0, =BALL_X
        LDRH    R4, [R0]        ; R4 = X_BALL
        LDR     R0, =BALL_Y
        LDRH    R5, [R0]        ; R5 = Y_BALL

CHECK_PADDLE_1
		MOV R6,#0
		MOV R7,#0
		MOV R8,#0
		MOV R9,#0
        ; === Load PADDLE 1 coordinates ===
        LDR     R0, =PADDLE_1_X2
        LDRH    R7, [R0]        ; R7 = X2
        LDR     R0, =PADDLE_1_Y2
        LDRH    R9, [R0]        ; R9 = Y2

	; === Paddle 1 Collision Check ===
		ADD R8,R4,#5
		SUB R6,R7,R8
		CMP R6,#10
		BGT CHECK_PADDLE_2
		CMP R6,#-10
		BLT CHECK_PADDLE_2
		ADD R8,R5,#5
		SUB R6,R9,R8
		CMP R6,#-10
		BLT CHECK_PADDLE_2
		CMP R6,#60
        BGT CHECK_PADDLE_2
 
        ; Invert X_VELOCITY
        LDR R0, =BALL_VELOCITY_X
        LDRH R1, [R0]
        RSBS R1, R1, #0
        STRH R1, [R0]
		MOV R0, #Blue
		LDR R5,=PADDLE_1_X1
		LDRH R1, [R5]
		LDR R6, =PADDLE_1_X2
		LDRH R2, [R6]
		LDR R5,=PADDLE_1_Y1
		LDRH R3 ,[R5]
		LDR R6, =PADDLE_1_Y2
		LDRH R4, [R6]
		BL Draw_Rectangle
		B done


CHECK_PADDLE_2
        ; === Load PADDLE 2 coordinates ===
        LDR     R0, =PADDLE_2_X2
        LDRH    R7, [R0]        ; R7 = X2
        LDR     R0, =PADDLE_2_Y2
        LDRH    R9, [R0]        ; R9 = Y2

	; === Paddle 2 Collision Check ===
		ADD R8,R4,#5
		SUB R6,R7,R8
		CMP R6,#10
		BGT CHECK_WALL
		CMP R6,#-10
		BLT CHECK_WALL
		ADD R8,R5,#5
		SUB R6,R9,R8
		CMP R6,#-10
		BLT CHECK_WALL
		CMP R6,#60
        BGT CHECK_WALL
	
        ; Invert X_VELOCITY
        LDR R0, =BALL_VELOCITY_X
        LDRH R1, [R0]
        RSBS R1, R1, #0
        STRH R1, [R0]
		MOV R0, #Green
		LDR R5,=PADDLE_2_X1
		LDRH R1, [R5]
		LDR R6, =PADDLE_2_X2
		LDRH R2, [R6]
		LDR R5,=PADDLE_2_Y1
		LDRH R3 ,[R5]
		LDR R6, =PADDLE_2_Y2
		LDRH R4, [R6]
		BL Draw_Rectangle
		B done

CHECK_WALL
        ; === Top/Bottom Wall Bounce ===	
        CMP R5, #0
        BLE invert_y
        CMP R5, #240
        BGE invert_y
        B CHECK_GOAL
invert_y
        LDR R0, =BALL_VELOCITY_Y
        LDRH R1, [R0]
        RSBS R1, R1, #0
        STRH R1, [R0]

CHECK_GOAL
        ; === IF X = 0: Player 2 Scores ===
        CMP R4, #1
        BLE PLAYER_2_GOAL
	
	; === IF X = 320: Player 1 Scores ===
        CMP R4, #320
        BGE PLAYER_1_GOAL
	
	B done
	
PLAYER_1_GOAL

        LDR R2, =P1_SCORE
        LDRH R3, [R2]
        ADD R3, R3, #1
        STRH R3, [R2]
		B RESET_BALL
	
PLAYER_2_GOAL	

        LDR R2, =P2_SCORE
        LDRH R3, [R2]
        ADD R3, R3, #1
        STRH R3, [R2]
        B RESET_BALL

RESET_BALL

	; === Erase old ball ===
        MOV R1, #Black
		LDR R5, =BALL_Y
        LDRH R5, [R5]
		LDR R6, =BALL_X
        LDRH R6, [R6]
        BL TFT_DrawSquare
        ; Reset ball to center
        LDR R0, =BALL_Y
        MOV R1, #120
        STRH R1, [R0]

        LDR R0, =BALL_X
        MOV R1, #160
        STRH R1, [R0]
		
		MOV R1, #Red
		LDR R5, =BALL_Y
        LDRH R5, [R5]
		LDR R6, =BALL_X
        LDRH R6, [R6]
        BL TFT_DrawSquare
		

done
        POP {R0-R12, PC}
		
PLAYER_1_WIN
	MOV R0, #Blue
    BL TFT_FillScreen
	B END_PING_GAME
	
PLAYER_2_WIN

	MOV R0, #Green
    BL TFT_FillScreen
	B END_PING_GAME
	
	
	B SKIP3
		LTORG
SKIP3

	
	

; *************************************************************
; draw_rectangle: Draw a rectangle between 4 lines (x1, x2) to (y1, y2) with the given color
; R0 = color ,R1 = Y1 ,R2 = Y2 ,R3 = X1 ,R4 = X2
; *************************************************************
Draw_Rectangle
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
    MOV R0, R4, LSR #8    ;TODO
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
    
FillLoop_RECT
    ; Write high byte
    MOV R0, R10
    BL TFT_WriteData
    
    ; Write low byte
    MOV R0, R9
    BL TFT_WriteData
    
    SUBS R3, R3, #1
    BNE FillLoop_RECT

    POP {R1-R12, PC}
	
    ENDFUNC
	ALIGN
    END