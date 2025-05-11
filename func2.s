

	AREA mycode, CODE, READONLY
	
	IMPORT 	TFT_Init
	IMPORT TFT_FillScreen
	IMPORT TFT_WriteCommand	
	IMPORT TFT_WriteData	
	IMPORT CONFIG
	EXPORT Move_left_D
	EXPORT Move_right_D
	EXPORT TFT_DrawSquare
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

DELAY_INTERVAL  EQU     0x90000
	

TFT_DrawSquare
    PUSH {R2,R7-R10,LR}
    ;TODO
	MOV R8, R5
    SUB R8, R8, #10      ; x_start
    ADD R10, R5, #10     ; x_end

    MOV R9, R6
    SUB R9, R9, #10      ; y_start
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
	POP {R2,R7-R10,LR}
    BX LR

Move_right_D
    PUSH {R2,R5-R8,LR}
    ;TODO
	MOV R5, R9
    SUB R5, R5, R9      ; y_start 40
    ADD R8, R9, R9    ; y_end

    MOV R6, R10
    ADD R6, R6, #35      ; x_start
    ADD R7, R10, #45     ; x_end

    ; Set Column Address
    MOV R0, #0x2A
    BL TFT_WriteCommand
    MOV R0, R5, LSR #8
    BL TFT_WriteData
    MOV R0, R5
    BL TFT_WriteData
    MOV R0, R8, LSR #8
    BL TFT_WriteData
    MOV R0, R8
    BL TFT_WriteData

    ; Set Page Address
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, R6, LSR #8
    BL TFT_WriteData
    MOV R0, R6
    BL TFT_WriteData
    MOV R0, R7, LSR #8
    BL TFT_WriteData
    MOV R0, R7
    BL TFT_WriteData

    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; Prepare color bytes
    MOV R2, R1, LSR #8  ; High byte
    AND R3, R1, #0xFF   ; Low byte

    ; Write pixels (width = 20, height = 20)
    MOV R4, #1200
Move_right_D_loop
    MOV R0, R2
    BL TFT_WriteData
    MOV R0, R3
    BL TFT_WriteData
    SUBS R4, R4, #1
    BNE Move_right_D_loop
	POP {R2,R5-R8,LR}
    BX LR
	
Move_left_D
    PUSH {R2,R5-R8,LR}
    ;TODO
	MOV R5, R9
    SUB R5, R5, R9      ; y_start
    ADD R8, R9, R9     ; y_end

    MOV R6, R10
    SUB R6, R6, #45      ; x_start
    SUB R7, R10, #35     ; x_end

    ; Set Column Address
    MOV R0, #0x2A
    BL TFT_WriteCommand
    MOV R0, R5, LSR #8
    BL TFT_WriteData
    MOV R0, R5
    BL TFT_WriteData
    MOV R0, R8, LSR #8
    BL TFT_WriteData
    MOV R0, R8
    BL TFT_WriteData

    ; Set Page Address
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, R6, LSR #8
    BL TFT_WriteData
    MOV R0, R6
    BL TFT_WriteData
    MOV R0, R7, LSR #8
    BL TFT_WriteData
    MOV R0, R7
    BL TFT_WriteData

    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; Prepare color bytes
    MOV R2, R1, LSR #8  ; High byte
    AND R3, R1, #0xFF   ; Low byte

    ; Write pixels (width = 20, height = 20)
    MOV R4, #1200
Move_left_D_loop
    MOV R0, R2
    BL TFT_WriteData
    MOV R0, R3
    BL TFT_WriteData
    SUBS R4, R4, #1
    BNE Move_left_D_loop
	POP {R2,R5-R8,LR}
    BX LR


	END