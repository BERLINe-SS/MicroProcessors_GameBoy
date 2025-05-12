

	AREA MYCODE, CODE, READONLY
	IMPORT 	TFT_Init
	IMPORT TFT_FillScreen
	IMPORT TFT_WriteCommand	
	IMPORT TFT_WriteData	
	IMPORT CONFIG
	IMPORT Move_left_D
	IMPORT Move_right_D
	EXPORT TFT_DrawObsticle_Top_1
	EXPORT TFT_ReDrawObsticle_Top_1
	EXPORT TFT_DrawObsticle_Down_1
	EXPORT TFT_ReDrawObsticle_Down_1
	IMPORT TFT_DrawSquare
	IMPORT  GAME_BOY_LOOP

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




Move_left
    PUSH {R2,R5,R6,R9,R10,LR}
    
	MOV R5, R7
	MOV R10, #240
	SUB R6, R10, R7
    SUB R5, R5, R6    ; y_start
    ADD R9, R7, R6     ; y_end

    MOV R6, R8
    SUB R6, R6, #45      ; x_start
    SUB R10, R8, #35     ; x_end

    ; Set Column Address
    MOV R0, #0x2A
    BL TFT_WriteCommand
    MOV R0, R5, LSR #8
    BL TFT_WriteData
    MOV R0, R5
    BL TFT_WriteData
    MOV R0, R9, LSR #8
    BL TFT_WriteData
    MOV R0, R9
    BL TFT_WriteData

    ; Set Page Address
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, R6, LSR #8
    BL TFT_WriteData
    MOV R0, R6
    BL TFT_WriteData
    MOV R0, R10, LSR #8
    BL TFT_WriteData
    MOV R0, R10
    BL TFT_WriteData

    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; Prepare color bytes
    MOV R2, R1, LSR #8  ; High byte
    AND R3, R1, #0xFF   ; Low byte

    ; Write pixels (width = 20, height = 20)
    MOV R4, #1200
Move_left_loop
    MOV R0, R2
    BL TFT_WriteData
    MOV R0, R3
    BL TFT_WriteData
    SUBS R4, R4, #1
    BNE Move_left_loop
	POP {R2,R5,R6,R9,R10,LR}
    BX LR
	
	
Move_right
	PUSH {R2,R5,R6,R9,R10,LR}
    
	MOV R5, R7
	MOV R10, #240
	SUB R6, R10, R7
    SUB R5, R5, R6    ; y_start
    ADD R9, R7, R6     ; y_end

    MOV R6, R8
    ADD R6, R6, #35      ; x_start
    ADD R10, R8, #45     ; x_end

    ; Set Column Address
    MOV R0, #0x2A
    BL TFT_WriteCommand
    MOV R0, R5, LSR #8
    BL TFT_WriteData
    MOV R0, R5
    BL TFT_WriteData
    MOV R0, R9, LSR #8
    BL TFT_WriteData
    MOV R0, R9
    BL TFT_WriteData

    ; Set Page Address
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, R6, LSR #8
    BL TFT_WriteData
    MOV R0, R6
    BL TFT_WriteData
    MOV R0, R10, LSR #8
    BL TFT_WriteData
    MOV R0, R10
    BL TFT_WriteData

    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; Prepare color bytes
    MOV R2, R1, LSR #8  ; High byte
    AND R3, R1, #0xFF   ; Low byte

    ; Write pixels (width = 20, height = 20)
    MOV R4, #1200
Move_right_loop
    MOV R0, R2
    BL TFT_WriteData
    MOV R0, R3
    BL TFT_WriteData
    SUBS R4, R4, #1
    BNE Move_right_loop
	POP {R2,R5,R6,R9,R10,LR}
    BX LR

TFT_DrawObsticle_Down_1
    PUSH {R2,R5-R8,LR}
    ;TODO
	MOV R5, R9
    SUB R5, R5, R9     ; y_start
    ADD R8, R9, R9     ; y_end

    MOV R6, R10
    SUB R6, R6, #35      ; x_start
    ADD R7, R10, #35     ; x_end

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
    MOV R4, #5600
DrawObsticle_Down_1_1
    MOV R0, R2
    BL TFT_WriteData
    MOV R0, R3
    BL TFT_WriteData
    SUBS R4, R4, #1
    BNE DrawObsticle_Down_1_1
	POP {R2,R5-R8,LR}
    BX LR

TFT_ReDrawObsticle_Down_1
	PUSH{R11,LR}
	
	MOV R1,#Black
	BL Move_right_D
	MOV R1,#Mario
	BL Move_left_D
	ADD R10, #-10 
	
	CMP R10, #95
	BLT GetY_D_1
	
	BL TFT_DrawObsticle_Down_1
	B end_get_states_D_1

GetY_D_1
	CMP R10, #-5
	BLT end_get_states_D_1
	ADD R11, R9, R9
	ADD R11, R11, #15
	
	CMP R11, R5
	BGT Blink_2   ; need edit
	BL TFT_DrawObsticle_Down_1
	B end_get_states_D_1

end_get_states_D_1
    pop{R11,LR}
    BX LR

TFT_DrawObsticle_Top_1
    PUSH {R2,R5,R6,R9,R10,LR}
    
	MOV R5, R7
	MOV R10, #240
	SUB R6, R10, R7
    SUB R5, R5, R6    ; y_start
    ADD R9, R7, R6     ; y_end

    MOV R6, R8
    SUB R6, R6, #35      ; x_start
    ADD R10, R8, #35     ; x_end

    ; Set Column Address
    MOV R0, #0x2A
    BL TFT_WriteCommand
    MOV R0, R5, LSR #8
    BL TFT_WriteData
    MOV R0, R5
    BL TFT_WriteData
    MOV R0, R9, LSR #8
    BL TFT_WriteData
    MOV R0, R9
    BL TFT_WriteData

    ; Set Page Address
    MOV R0, #0x2B
    BL TFT_WriteCommand
    MOV R0, R6, LSR #8
    BL TFT_WriteData
    MOV R0, R6
    BL TFT_WriteData
    MOV R0, R10, LSR #8
    BL TFT_WriteData
    MOV R0, R10
    BL TFT_WriteData

    ; Memory Write
    MOV R0, #0x2C
    BL TFT_WriteCommand

    ; Prepare color bytes
    MOV R2, R1, LSR #8  ; High byte
    AND R3, R1, #0xFF   ; Low byte

    ; Write pixels (width = 20, height = 20)
    MOV R4, #5600
DrawObsticle_Top_1_1
    MOV R0, R2
    BL TFT_WriteData
    MOV R0, R3
    BL TFT_WriteData
    SUBS R4, R4, #1
    BNE DrawObsticle_Top_1_1
	POP {R2,R5,R6,R9,R10,LR}
    BX LR
	



TFT_ReDrawObsticle_Top_1
	PUSH{R11, LR}
	
	MOV R1,#Black
	BL Move_right
	
	MOV R1,#Mario
	BL Move_left

	ADD R8, #-10 
	
	CMP R8, #95
	BLT GetY_T_1
	
	BL TFT_DrawObsticle_Top_1
	B end_get_states_T_1

GetY_T_1
	CMP R8, #-5
	BLT end_get_states_T_1
	
	SUB R11, R7, #240
	ADD R11, R7, R11
	SUB R11, R11, #20
	CMP R11, R5
	
	BLT Blink_2    
	BL TFT_DrawObsticle_Top_1
	B end_get_states_T_1	

end_get_states_T_1
    pop{R11,LR}
    BX LR
	
delay_func
    PUSH {R0, LR}
    LDR R0, =DELAY_INTERVAL
delay_loop_2
    SUBS R0, R0, #1
    BNE delay_loop_2
    POP {R0, LR}
    BX LR


Blink_2
	MOV R12,#0
BLINK_LOOP2
	MOV R1,#Black
	BL TFT_DrawSquare
	BL delay_func
	MOV R1,#Pink
	BL TFT_DrawSquare
	ADD R12,R12,#1
	BL delay_func
	CMP R12,#10
	BLT BLINK_LOOP2
	BL delay_func
	BL delay_func
	BL delay_func
	BL delay_func
	BL delay_func
	BL delay_func
	B GAME_BOY_LOOP


	

	END