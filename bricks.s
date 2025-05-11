
    EXPORT bricks
	IMPORT TFT_FillScreen
	IMPORT TFT_WriteCommand	
	IMPORT TFT_WriteData	
	IMPORT CONFIG
	IMPORT 	TFT_Init
        AREA    MyData, DATA, READWRITE

; BALL DATA
BALL_X               SPACE    2
BALL_Y               SPACE    2
BALL_VELOCITY_X      SPACE    2
BALL_VELOCITY_Y      SPACE    2
BALL_COLOR           SPACE    2

; SCORE COUNT
LIVES             SPACE    2

SCORE 			  SPACE    2

; PADDLE DATA
PADDLE_COLOR        SPACE    2

PADDLE_X1          SPACE    2
PADDLE_X2          SPACE    2
PADDLE_Y1          SPACE    2
PADDLE_Y2          SPACE    2
	
GRID 			   SPACE  96 




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

DELAY_INTERVAL  EQU     0x90000 
	
	
		AREA MYCODE, CODE, READONLY
bricks FUNCTION
	
	
    BL CONFIG
    ; Initialize TFT
    BL TFT_Init
	

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
        MOV     R1, #Red        
        STRH    R1, [R0]

        ; SCORE
        LDR     R0, =LIVES
        MOV     R1, #3
        STRH    R1, [R0]

        LDR     R0, =SCORE
        MOV     R1, #0
        STRH    R1, [R0]

        ; COLORS
        LDR     R0, =PADDLE_COLOR
        MOV     R1, #Green       
        STRH    R1, [R0]

        ; PADDLE
        LDR     R0, =PADDLE_X1
        MOV     R1, #120
        STRH    R1, [R0]

        LDR     R0, =PADDLE_X2
        MOV     R1, #200
        STRH    R1, [R0]

        LDR     R0, =PADDLE_Y1
        MOV     R1, #30
        STRH    R1, [R0]

        LDR     R0, =PADDLE_Y2
        MOV     R1, #40
        STRH    R1, [R0]			
	
	
	    LDR     R0, =BALL_X
        MOV     R1, #160
        STRH    R1, [R0]

        LDR     R0, =BALL_Y
        MOV     R1, #60
        STRH    R1, [R0]
		
	B SKIP_THIS2
		LTORG
SKIP_THIS2
	
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
	
	
GRID_INIT
	MOV R2,#0
	MOV R1,#Red
	MOV R6,#20  ;; INITAIL X
	MOV R5,#200 ;; INITIAL Y
	LDR R0,=GRID
ROW_1
	BL TFT_DrawSquare
	MOV 	R9,R6
	MOV		R8,R2
	MOV 	R8,R8,LSL #2
	ADD 	R8,R8,#2
	STRH 	R5,[R0,R8] ;; STORE Y
	SUB		R8,R8,#2
	STRH	R6,[R0,R8] ;; STORE X
	ADD     R9, R9, #40
	MOV 	R6,R9
    ADD     R2, R2, #1
    CMP     R2, #8 
	BLT	    ROW_1

	MOV R1,#Yellow
	MOV R6,#20
	MOV R5,#160
ROW_2
	MOV R1,#Yellow
	BL TFT_DrawSquare
	MOV		R8,R2
	MOV 	R8,R8,LSL #2
	ADD 	R8,R8,#2
	STRH 	R5,[R0,R8] ;; STORE Y
	SUB		R8,R8,#2
	STRH	R6,[R0,R8] ;; STORE X
	ADD     R6, R6, #40
    ADD     R2, R2, #1
    CMP     R2, #16 
    BLT    ROW_2

	MOV R1,#Green
	MOV R6,#20
	MOV R5,#120
	LDR R0,=GRID
ROW_3
	MOV R1,#Green
	BL TFT_DrawSquare
	MOV		R8,R2
	MOV 	R8,R8,LSL #2
	ADD 	R8,R8,#2
	STRH 	R5,[R0,R8] ;; STORE Y
	SUB		R8,R8,#2
	STRH	R6,[R0,R8] ;; STORE X
	ADD     R6, R6, #40
    ADD     R2, R2, #1
    CMP     R2, #24 
    BLT     ROW_3
	
	; DRAWS PLAYER
	LDR R5, =PADDLE_COLOR
	LDRH R0, [R5]
	LDR R5,=PADDLE_X1
	LDRH R1, [R5]
	LDR R6, =PADDLE_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_Y1
	LDRH R3 ,[R5]
	;MOV R4, R3
	LDR R6, =PADDLE_Y2
	LDRH R4, [R6]
	BL Draw_Rectangle
	
	; DRAW BALL
    MOV R1, #Red
	LDR R5, =BALL_Y
    LDRH R5, [R5]
	LDR R6, =BALL_X
    LDRH R6, [R6]
    BL TFT_DrawBall

	B SKIP
		LTORG
SKIP

MAIN_LOOP	
	BL BALL_CHECK_MOVE
	BL delay
	BL MOVE_PLAYER
	BL CHECK_WIN
	BL CHECK_LOSE
	
		
	B MAIN_LOOP	
	
END_BRICKS_GAME	
	B .


;***********************************
; THIS FUNCTION HANDELS MOVEMENT FOR PLAYER
;***********************************
MOVE_PLAYER
	PUSH {R0-R12, LR}
	; Read Key Inputs (Returns in R0: 0=none, R0 = 1=key5, R0 = 2=key6)
	BL BRICKS_BREAKER_READ_KEYS  
	
	CMP R0, #1 			; CHECK IF PLAYER IS MOVING RIGHT
	BNE PLAYER_LEFT		; IF NOT, CHECK LEFT
	;TODO: CHECK IF THE PLAYER REACHED X = 320 (END OF SCREEN)
	LDR R5, =PADDLE_X2	;TODO: CHECK IF THE PLAYER REACHED X2 = 320 (END OF SCREEN)
    MOV R1, #0
	LDRH R1, [R5]
	CMP R1, #320
	BGE END_MOVE_PLAYER
	; ERASES PLAYER 1 AND REDRAWS PLAYER 1 RIGHT 20 PIXELS

	MOV R0, #Black
	LDR R5,=PADDLE_X1
	LDRH R1, [R5]
	LDR R6, =PADDLE_X2
	LDRH R2, [R6]
	LDR R5,=PADDLE_Y1
	LDRH R3 ,[R5]
	LDR R6, =PADDLE_Y2
	LDRH R4, [R6]
	BL Draw_Rectangle 
	; DONE ERASING PLAYER 1

	;NOW REDRAWING BUT X1/X2 IS INCREASED BY 20
	LDR R5,=PADDLE_COLOR
	LDRH R0, [R5]
	LDR R5,=PADDLE_X1
	LDRH R1, [R5]
	ADD R1, R1,#20	;ADDING 20 DECIMAL TO X1
	STRH R1, [R5]	;STORING THE NEW POSITION OF PLAYER 1
	LDR R6, =PADDLE_X2
	LDRH R2, [R6]
	ADD R2, R2, #20
	STRH R2, [R6]
	LDR R5,=PADDLE_Y1
	LDRH R3 ,[R5]
	LDR R6, =PADDLE_Y2
	LDRH R4, [R6]	
	BL Draw_Rectangle
	
	B END_MOVE_PLAYER
	
	
PLAYER_LEFT			    ; CHECK UP FOR PLAYER 1
	CMP R0, #2 			; CHECK IF PLAYER 1 IS MOVING LEFT
	BNE END_MOVE_PLAYER; IF NOT, DO NOTHING TO PLAYER
	
	LDR R5, =PADDLE_X1	;TODO: CHECK IF THE PLAYER REACHED X = 0 (END OF SCREEN)
    MOV R1, #0
	LDRH R1, [R5]
	CMP R1, #1
	BLE END_MOVE_PLAYER
	; ERASES PLAYER AND REDRAWS PLAYER LEFT 20 PIXELS

	MOV R0, #Black
	LDR R5,=PADDLE_X1
	LDRH R1, [R5]
	;MOV R2, R1
	LDR R6, =PADDLE_X2
	LDRH R2, [R6]
	;ADD R2, R5
	LDR R5,=PADDLE_Y1
	LDRH R3 ,[R5]
	;MOV R4, R3
	LDR R6, =PADDLE_Y2
	LDRH R4, [R6]
	;ADD R4, R5
	BL Draw_Rectangle 
	; DONE ERASING PLAYER 1

	;NOW REDRAWING BUT X1 IS DECREASED BY 20
	LDR R5,=PADDLE_COLOR
	LDRH R0, [R5]
	LDR R5,=PADDLE_X1
	LDRH R1, [R5]
	SUB R1, R1, #20	;SUBTRACTING 20 DECIMAL TO X1 
	STRH R1, [R5]		;STORING THE NEW POSITION OF PLAYER 1
	LDR R6, =PADDLE_X2
	LDRH R2, [R6]
	SUB R2, R2, #20
	STRH R2, [R6]	
	LDR R5,=PADDLE_Y1
	LDRH R3 ,[R5]
	LDR R6, =PADDLE_Y2
	LDRH R4, [R6]
	BL Draw_Rectangle
	
END_MOVE_PLAYER	
	
	POP {R0-R12, PC}		


	B SKIP2
		LTORG
SKIP2




CHECK_WIN
	PUSH{R0-R12,LR}
	LDR R0,=SCORE
	MOV R1,#0
	LDRH R1,[R0]
	CMP R1,#24
	BLT END_CHECK
	;;;;;;;
	MOV R0, #Green
	BL TFT_FillScreen
	B END_BRICKS_GAME
	;;;;;;
END_CHECK

	POP{R0-R12,PC}
	
CHECK_LOSE
	PUSH{R0-R12,LR}
	LDR R0,=LIVES
	MOV R1,#0
	LDRH R1,[R0]
	CMP R1,#0
	BGT END_CHECK_LOSE
	;;;;;;;;;
	MOV R0, #Red
	BL TFT_FillScreen
	B END_BRICKS_GAME
	;;;;;;;;
END_CHECK_LOSE

    POP{R0-R12,PC}



BALL_CHECK_MOVE
        PUSH {R0-R12, LR}

        ; === Erase old ball ===
        MOV R1, #Black
		LDR R2, =BALL_Y
        LDRH R5, [R2]
		LDR R2, =BALL_X
        LDRH R6, [R2]
        BL TFT_DrawBall

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
        BL TFT_DrawBall

		MOV R4,#0
		MOV R5,#0
        ; === Load BALL X into R4 and BALL Y into R5 ===
        LDR     R0, =BALL_X
        LDRH    R4, [R0]        ; R4 = X_BALL
        LDR     R0, =BALL_Y
        LDRH    R5, [R0]        ; R5 = Y_BALL

	B SKIP3
		LTORG
SKIP3

	
CHECK_PADDLE
       ; === Load PADDLE coordinates ===
        LDR     R0, =PADDLE_X2
        LDRH    R7, [R0]        ; R7 = X2
        LDR     R0, =PADDLE_Y2
        LDRH    R9, [R0]        ; R9 = Y2

	; === Paddle Collision Check ===
		MOV R6,#0
		SUB R5,R5,#5
		SUB R6,R9,R5
        ADD R5,R5,#5
		CMP R6,#10
		BGT CHECK_WALL_UP
		CMP R6,#0
		BLT CHECK_WALL_UP                               
		
		MOV R6,#0
		SUB R4,R4,#5
		SUB R6,R7,R4
        ADD R4,R4,#5
		CMP R6,#70
		BGT CHECK_WALL_UP
		CMP R6,#0
		BLT CHECK_WALL_UP
	
        ; Invert Y_VELOCITY
        LDR R0, =BALL_VELOCITY_Y
        LDRH R1, [R0]
        RSBS R1, R1, #0
        STRH R1, [R0]
		
	
		B done

CHECK_WALL_UP  
        ; === Top Wall Bounce ===	
        CMP R5, #240
        BGE invert_y
        B CHECK_WALL_SIDES
invert_y
        LDR R0, =BALL_VELOCITY_Y
        LDRH R1, [R0]
        RSBS R1, R1, #0
        STRH R1, [R0]
CHECK_WALL_SIDES  
        ; === Left/Right Wall Bounce ===	
        CMP R4, #1
        BLE invert_x
        CMP R4, #320
        BGE invert_x
        B CHECK_WALL_DOWN
invert_x
        LDR R0, =BALL_VELOCITY_X
        LDRH R1, [R0]
        RSBS R1, R1, #0
        STRH R1, [R0]
CHECK_WALL_DOWN
        ; === Top Wall Bounce ===	
        CMP R5, #0
		BGT   CHECK_HIT_BRICKS     ; Skip if R5 > 0

		; LIVES--
        LDR     R0, =LIVES
        LDRH    R1, [R0]
        SUB     R1, R1,#1
        STRH    R1, [R0]
        B RESET_BALL

CHECK_HIT_BRICKS
	LDR   R0, =GRID
    MOV   R1, #0
LOOP_GRID
    MOV   R2, R1
    LSL   R2, R2, #2
    MOV   R3, #0
    MOV   R4, #0
    ADD   R2, R2, #2
    LDRH  R4, [R0, R2]       ; R4 = GRID[i].Y
    SUB   R2, R2, #2
    LDRH  R3, [R0, R2]       ; R3 = GRID[i].X
    
    CMP R3, #0
    BEQ.W CONTINUE
    CMP R4, #0
    BEQ.W CONTINUE

    ; Load ball position
    LDR   R11, =BALL_X
    LDRH  R6, [R11]        ; R6 = ball_x
    
    LDR   R11, =BALL_Y
    LDRH  R5, [R11]        ; R5 = ball_y

    ; Calculate brick boundaries (with radius 10)
    MOV   R7, R3
    SUB   R7, R7, #10      ; R7 = brick_x1
    
    MOV   R8, R3
    ADD   R8, R8, #10      ; R8 = brick_x2
    
    MOV   R9, R4
    SUB   R9, R9, #10      ; R9 = brick_y1
    
    MOV   R10, R4
    ADD   R10, R10, #10    ; R10 = brick_y2
    
    ; Ball radius = 5, so check if ball overlaps with brick
    ; Check if ball's right edge is left of brick's left edge
    ADD   R11, R6, #5      ; ball_x + radius
    CMP   R11, R7
    BLT   CONTINUE         ; No collision if ball is to left
    
    ; Check if ball's left edge is right of brick's right edge
    SUB   R11, R6, #5      ; ball_x - radius
    CMP   R11, R8
    BGT   CONTINUE         ; No collision if ball is to right
    
    ; Check if ball's bottom edge is above brick's top edge
    ADD   R11, R5, #5      ; ball_y + radius
    CMP   R11, R9
    BLT   CONTINUE         ; No collision if ball is above
    
    ; Check if ball's top edge is below brick's bottom edge
    SUB   R11, R5, #5      ; ball_y - radius
    CMP   R11, R10
    BGT   CONTINUE         ; No collision if ball is below
    
    
    ; Save register R1 for later
    MOV   R11, R1
    
    ; Delete the brick (draw black)
    MOV   R1, #Black
    MOV   R6, R3           ; brick center x
    MOV   R5, R4           ; brick center y
    BL    TFT_DrawSquare
    
    ; Restore R1
    MOV   R1, R11
    
    ; Increment score
    LDR   R11, =SCORE
    LDRH  R12, [R11]
    ADD   R12, R12, #1
    STRH  R12, [R11]
    
    ; Determine collision direction and bounce
    ; For simplicity, just invert Y velocity for now
    LDR   R11, =BALL_VELOCITY_Y
    LDRH  R12, [R11]
    RSBS  R12, R12, #0
    STRH  R12, [R11]
    
    ; Mark this brick as deleted
    MOV   R4, #0
    ADD   R2, R2, #2
    STRH  R4, [R0, R2]     ; Clear GRID[i].Y
    SUB   R2, R2, #2
    MOV   R3, #0
    STRH  R3, [R0, R2]     ; Clear GRID[i].X
    
    B     done
    
CONTINUE
    ADD   R1, R1, #1
    CMP   R1, #24
    BLT   LOOP_GRID
	B done
	

RESET_BALL

	; === Erase old ball ===
        MOV R1, #Black
		LDR R5, =BALL_Y
        LDRH R5, [R5]
		LDR R6, =BALL_X
        LDRH R6, [R6]
        BL TFT_DrawBall
        ; Reset ball to center
        LDR R0, =BALL_Y
        MOV R1, #60
        STRH R1, [R0]

        LDR R0, =BALL_X
        MOV R1, #160
        STRH R1, [R0]
		
		MOV R1, #Red
		LDR R5, =BALL_Y
        LDRH R5, [R5]
		LDR R6, =BALL_X
        LDRH R6, [R6]
        BL TFT_DrawBall	

done
        POP {R0-R12, PC}









; *************************************************************
; Draw Square Center at (y=R5, x=R6 ,Color=R1)
; *************************************************************
TFT_DrawSquare
    PUSH {R0-R12,LR}
    ;TODO
	MOV R8, R5
    SUB R8, R8, #10     ; x_start
    ADD R10, R5, #10     ; x_end

    MOV R9, R6
    SUB R9, R9, #10     ; y_start
    ADD R11, R6, #10     ; y_end

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

    ; Write pixels (width = 20, height = 20)
    MOV R4, #400
DrawSquare_Loop
    MOV R0, R2
    BL TFT_WriteData
    MOV R0, R3
    BL TFT_WriteData
    SUBS R4, R4, #1
    BNE DrawSquare_Loop
	POP {R0-R12,LR}
    BX LR
	
	
TFT_DrawBall
    PUSH {R0-R12,LR}
    ;TODO
	MOV R8, R5
    SUB R8, R8, #5     ; x_start
    ADD R10, R5, #5     ; x_end

    MOV R9, R6
    SUB R9, R9, #5     ; y_start
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

    ; Write pixels (width = 20, height = 20)
    MOV R4, #100
DrawBall_Loop
    MOV R0, R2
    BL TFT_WriteData
    MOV R0, R3
    BL TFT_WriteData
    SUBS R4, R4, #1
    BNE DrawBall_Loop
	POP {R0-R12,LR}
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
	



;****************************************
;THIS FUNCTION READS KEYS FOR PINGPONG GAME
; R0 --> PADDLE, 0 NO KEY PRESSED, 1 WHEN KEY 5 IS PRESSED, 2 WHEN 6
;****************************************
BRICKS_BREAKER_READ_KEYS
    PUSH {R1-R12, LR}              ; Save registers
    
    LDR R1, =GPIOB_BASE + GPIO_IDR  ; Load GPIOB input data register address
    LDR R2, [R1]               ; Read the value from GPIOB input data register

    ; Check each key pin (PB5-PB8)
    TST R2, #(1 << 5)         ; Test key5 (PB0) bit
    BEQ PING_PONG_CheckKey2              ; If key5 is not pressed, check key6
    MOV R0, #1                 ; If key5 is pressed, return 1
    B END_READ_KEYS               ; Return
;***************************************************
; Read Key Inputs For Ping  Pong Game (Returns in R0 and R1: 0=none, R0 = 1=key1, R0 = 2=key2, R1 = 1=key3, R1 = 2=key4)
;***************************************************
PING_PONG_CheckKey2
    TST R2, #(1 << 6)        ; Test key6 (PB1) bit
    BEQ NoKeyPressedForPlayer1 ; If key6 is not pressed, check key7
    MOV R0, #2                 ; If key6 is pressed, return 2
    B   END_READ_KEYS              ; Return

NoKeyPressedForPlayer1
    MOV R0, #0                 ; Return 0 if no key is pressed
END_READ_KEYS	
    POP {R1-R12, LR}              ; Restore registers
    BX LR 
	
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