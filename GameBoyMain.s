
	IMPORT fbirdR
	IMPORT brickR
	IMPORT X_OR
	IMPORT snakeR
	IMPORT pingR	
	IMPORT __xogame	
	IMPORT snake	
	IMPORT titleR
	IMPORT bricks
	IMPORT PingPong	
	IMPORT FlappyBird	
	
			
		
	AREA DATA, DATA, READWRITE




	AREA MYCODE,CODE,READONLY
	EXPORT __main
	EXPORT TFT_Init
	EXPORT TFT_FillScreen
	EXPORT TFT_WriteCommand	
	EXPORT TFT_WriteData	
	EXPORT CONFIG
	EXPORT TFT_DrawImage
	EXPORT GAME_BOY_LOOP

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
DARKBLUE EQU 0x3256
ORANGE   EQU 0xFCA1	

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

; Control Pins on Port E
TFT_RST         EQU     (1 << 8)
TFT_RD          EQU     (1 << 10)
TFT_WR          EQU     (1 << 11)
TFT_DC          EQU     (1 << 12)
TFT_CS          EQU     (1 << 15)
DELAY_INTERVAL  EQU     0X90000	

__main FUNCTION

	BL CONFIG
	
    


GAME_BOY_LOOP
	
	BL TFT_Init
	LDR R0,=ORANGE
	BL TFT_FillScreen
	
	LDR R3,=titleR
	MOV R1,#209
	MOV R2,#0
	BL TFT_DrawImage
	
	LDR R3,=snakeR
	MOV R1,#150
	MOV R2,#50
	BL TFT_DrawImage
	
	LDR R3,=pingR
	MOV R1,#150
	MOV R2,#220
	BL TFT_DrawImage
	
	LDR R3,=brickR
	MOV R1,#80
	MOV R2,#220
	BL TFT_DrawImage
	
	LDR R3,=fbirdR
	MOV R1,#80
	MOV R2,#50
	BL TFT_DrawImage
	
	LDR R3,=X_OR
	MOV R1,#20
	MOV R2,#150
	BL TFT_DrawImage
	
	LDR R0,=WHITE
	MOV R1,#150
	MOV R2,#50
	BL DRAW_SEL_LINE
		
GAME

	BL MOV_SEL
	BL delay
	BL delay
	BL delay
	
	B GAME
	
	
MOV_SEL
	PUSH {R0,R3-R12,LR}
	
	LDR R3,=GPIOB_BASE+GPIO_IDR
	LDR R4,[R3]

	
	TST R4,#8
	BNE MOVE
	
	TST R4,#16
	BNE SUBMIT
	
	B NOCHANGE
	
MOVE
	CMP R1,#150
	BEQ FIRSTLINE
	CMP R1,#80
	BEQ SECONDLINE
	CMP R1,#20
	BEQ THIRD
	
FIRSTLINE
	LDR R0,=ORANGE
	BL  DRAW_SEL_LINE
	LDR R0,=WHITE
	CMP   R2,#50
	ADDEQ R2,R2,#170
	SUBNE R1,R1,#70
	SUBNE R2,R2,#170
	
	BL DRAW_SEL_LINE

	B NOCHANGE
SECONDLINE
	LDR R0,=ORANGE
	BL  DRAW_SEL_LINE
	LDR R0,=WHITE
	CMP R2,#50
	ADDEQ R2,R2,#170
	SUBNE R1,R1,#60
	SUBNE R2,R2,#70

	BL DRAW_SEL_LINE

	B NOCHANGE

THIRD
	 LDR R0,=ORANGE
	 BL  DRAW_SEL_LINE
	 LDR R0,=WHITE
	 MOV R1,#150
	 MOV R2,#50	
	
	 BL DRAW_SEL_LINE
 
	 B NOCHANGE
	
SUBMIT

	CMP R1,#150
	BEQ FIRSTLINEG
	CMP R1,#80
	BEQ SECONDLINEG
	CMP R1,#20
	BEQ THIRDG
	
FIRSTLINEG
	
	CMP   R2,#50
	BLEQ snake
	BLNE PingPong

	B NOCHANGE
SECONDLINEG

	CMP R2,#50
	BLEQ FlappyBird
	BLNE bricks
	B NOCHANGE

THIRDG
	BL __xogame
 
	 B NOCHANGE

		
NOCHANGE	
	
	POP {R0,R3-R12,PC}
	
	
DRAW_SEL_LINE
    ;R0 = COLOUR
    ; R1 = Start Y
    ; R2 = Start X
	PUSH{R0-R12,LR}
	
	MOV R6,R1 ;SAVE Y
	MOV R7,R2 ;SAVE X
	
	MOV R4,R6  ;Y1
	SUB R3,R6,#5 ;Y2
	MOV R1,R7     ;X1
 	ADD R2,R7,#50 ;X2
	
	BL Draw_Rectangle

	POP{R0-R12,PC}	
	
; *************************************************************
; TFT Fill Screen (R0 = 16-bit color)
; *************************************************************
TFT_FillScreen
    PUSH {R1-R5, LR}

    ; Save color
    MOV R5, R0

    ; Set Column Address (0-239)
    MOV R0, #0x2A
    BL TFT_WriteCommand
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0xEF      ; 239 
    BL TFT_WriteData

    ; Set Page Address (0-319)
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0x00
    BL TFT_WriteData
    MOV R0, #0x01      ; High byte of 0x013F (319)
    BL TFT_WriteData
    MOV R0, #0x3F      ; Low byte of 0x013F (319)
    BL TFT_WriteData

    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; Prepare color bytes
    MOV R1, R5, LSR #8     ; High byte
    AND R2, R5, #0xFF      ; Low byte

    ; Fill screen with color (320x240 = 76800 pixels)
    LDR R3, =76800
FillLoop
    ; Write high byte
    MOV R0, R1
    BL TFT_WriteData
    
    ; Write low byte
    MOV R0, R2
    BL TFT_WriteData
    
    SUBS R3, R3, #1
    BNE FillLoop

    POP {R1-R5, LR}
    BX LR	
; *************************************************************
; draw_rectangle: Draw a rectangle between 4 lines (x1, x2) to (y1, y2) with the given color
; R0 = color ,R1 = X1 ,R2 = X2 ,R3 = Y1 ,R4 = Y2
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
	
	
	
; *************************************************************
; TFT Write Command (R0 = command)
; *************************************************************
TFT_WriteCommand
    PUSH {R1-R2, LR}

    ; Set CS low
    LDR R1, =GPIOA_BASE + GPIO_ODR
    LDR R2, [R1]
    BIC R2, R2, #TFT_CS
    STR R2, [R1]

    ; Set DC (RS) low for command
    BIC R2, R2, #TFT_DC
    STR R2, [R1]

    ; Set RD high (not used in write operation)
    ORR R2, R2, #TFT_RD
    STR R2, [R1]

    ; Send command (R0 contains command)
    BIC R2, R2, #0xFF   ; Clear data bits PE0-PE7
    AND R0, R0, #0xFF   ; Ensure only 8 bits
    ORR R2, R2, R0      ; Combine with control bits
    STR R2, [R1]

    ; Generate WR pulse (low > high)
    BIC R2, R2, #TFT_WR
    STR R2, [R1]
    ORR R2, R2, #TFT_WR
    STR R2, [R1]

    ; Set CS high
    ORR R2, R2, #TFT_CS
    STR R2, [R1]
    POP {R1-R2, LR}
    BX LR

; *************************************************************
; TFT Write Data (R0 = data)
; *************************************************************
TFT_WriteData
    PUSH {R1-R2, LR}

    ; Set CS low
    LDR R1, =GPIOA_BASE + GPIO_ODR
    LDR R2, [R1]
    BIC R2, R2, #TFT_CS
    STR R2, [R1]

    ; Set DC (RS) high for data
    ORR R2, R2, #TFT_DC
    STR R2, [R1]

    ; Set RD high (not used in write operation)
    ORR R2, R2, #TFT_RD
    STR R2, [R1]

    ; Send data (R0 contains data)
    BIC R2, R2, #0xFF   ; Clear data bits PE0-PE7
    AND R0, R0, #0xFF   ; Ensure only 8 bits
    ORR R2, R2, R0      ; Combine with control bits
    STR R2, [R1]

    ; Generate WR pulse
    BIC R2, R2, #TFT_WR
    STR R2, [R1]
    ORR R2, R2, #TFT_WR
    STR R2, [R1]

    ; Set CS high
    ORR R2, R2, #TFT_CS
    STR R2, [R1]

    POP {R1-R2, LR}
    BX LR


	
	
	
TFT_DrawImage
    PUSH {R0-R12, LR}

    ; Load image width and height
    LDR R4, [R3], #4  ; Load width  (R3 = Width)
    LDR R5, [R3], #4  ; Load height (R4 = Height)

    ; =====================
    ; Set Column Address (X Start, X End)
    ; =====================
    MOV R0, #0x2A
    BL TFT_WriteCommand

    MOV R0, R1, LSR #8
    BL TFT_WriteData

    MOV R0, R1  ; X Start
    BL TFT_WriteData

    ADD R0, R1, R4
    SUB R0, R0, #1  ; X End = X + Width - 1
    MOV R9, R0

    MOV R0, R9, LSR #8
    BL TFT_WriteData
    MOV R0, R9
    BL TFT_WriteData

    ; =====================
    ; Set Page Address (Y Start, Y End)
    ; =====================
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, R2, LSR #8
    BL TFT_WriteData
    MOV R0, R2  ; Y Start
    BL TFT_WriteData

    ADD R0, R2, R5
    SUB R0, R0, #1  ; Y End = Y + Height - 1
    MOV R9, R0

    MOV R0, R9, LSR #8
    BL TFT_WriteData
    MOV R0, R9
    BL TFT_WriteData

    ; =====================
    ; Start Writing Pixels
    ; =====================
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; =====================
    ; Send Pixel Data (BGR565)
    ; =====================
    MUL R6, R4, R5  ; Total pixels = Width × Height
TFT_ImageLoop
    LDRH R0, [R3], #2  ; Load one pixel (16-bit BGR565)
    MOV R1, R0, LSR #8 ; Extract high byte
    AND R2, R0, #0xFF  ; Extract low byte


    MOV R0, R1         ; Send High Byte first
    BL TFT_WriteData
    MOV R0, R2         ; Send Low Byte second
    BL TFT_WriteData

    SUBS R6, R6, #1
    BNE TFT_ImageLoop

    POP {R0-R12, LR}
    BX LR

CONFIG
	PUSH{R0-R12,LR}
	LDR R0, =RCC_BASE + RCC_AHB1ENR
    LDR R1, [R0]
    ORR R1, R1,#0x1F 
    STR R1, [R0]

	; Configure GPIOB as General Purpose INput Mode
    LDR R0, =GPIOB_BASE + GPIO_MODER
    LDR R1, =0x00000000 
    STR R1, [R0]

    ; Configure input speed for GPIOB (High Speed)
    LDR R0, =GPIOB_BASE + GPIO_OSPEEDR
    LDR R1, =0xFFFFFFFF  
    STR R1, [R0]
	
	; Configure output speed for GPIOB (PULL Down)
    LDR R0, =GPIOB_BASE + GPIO_PUPDR
    LDR R1, =0xAAAAAAAA  
    STR R1, [R0]
	
    ; Configure GPIOE as General Purpose Output Mode
    LDR R0, =GPIOA_BASE + GPIO_MODER
    LDR R1, =0x55555555    ; All pins as outputs
    STR R1, [R0]

    ; Configure output speed for GPIOE (High Speed)
    LDR R0, =GPIOA_BASE + GPIO_OSPEEDR
    LDR R1, =0xFFFFFFFF    ; High speed for all pins
    STR R1, [R0]
	POP{R0-R12,PC}

; *************************************************************
; TFT Initialization
; *************************************************************
TFT_Init
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

    ; Sleep Out
    MOV R0, #0x11
    BL TFT_WriteCommand
    BL delay
	
	 ;memory accsess
	MOV R0, #0x36       ; MADCTL command
	BL TFT_WriteCommand
	MOV R0, #0x48       ; Parameter value (see explanation below)
	BL TFT_WriteData

    
    ; Display ON
    MOV R0, #0x29
    BL TFT_WriteCommand

    POP {R0-R2, LR}
    BX LR	
	
	
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