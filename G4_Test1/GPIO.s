        AREA |.text|, CODE, READONLY, ALIGN=2
        THUMB
        REQUIRE8
        PRESERVE8

	
        EXPORT	LEDs_Init
		EXPORT	LED_Toggle
			
RCC		EQU		0x40021000
	
; Deben buscar el valor en el Reference Manual
GPIOE	EQU		0x48001000	; EvalBoard
;GPIOB	EQU		0x48000400	; K8
GPIOB   EQU		0x48000400	; G4
GPIOA	EQU		0x48000000 ; RE

AHB2ENR	EQU 	0x4C

; Deben buscar el valor en el Reference Manual
MODER   EQU		0x00	
ODR		EQU		0x14


LEDs_Init
	push {lr}

	;RCC->AHB2ENR |= RCC_AHB2ENR_GPIOBEN; (bit 1)
	;**** Encender el puerto correspondiente de tu tarjeta ****

	ldr  r0, =RCC			;read
	ldr  r1, [r0,#AHB2ENR]
	movs r2, #0x2			;modify: bit 1 = GPIOBEN
	orrs r1, r1, r2
	str  r1, [r0,#AHB2ENR]	;write

	;EvalBoard / Discovery
	;	GPIOE->MODER |= (1<<26);
	;	GPIOE->ODR &= ~(1<<13);
	;F303K8
	;	GPIOB->MODER &= ~(1<<7);
	;	GPIOB->MODER |= (1<<6);
	;F303RE
	;	GPIOA->MODER |= (1<<10);
	;	GPIOA->ODR &= ~(1<<5);
	;G4 (NUCLEO-G431KB) - LED en PB8
	;	GPIOB->MODER &= ~(1<<17);
	;	GPIOB->MODER |= (1<<16);
	;	GPIOB->ODR &= ~(1<<8);

	ldr  r0, =GPIOB			;read
	ldr  r1, [r0,#MODER]
	movs r2, #0x20000		;modify clear bit 17
	bics r1, r1, r2
	movs r2, #0x10000		;modify set bit 16  -> MODER[17:16] = 01 
	orrs r1, r1, r2
	str  r1, [r0,#MODER]	;write

	ldr  r1, [r0,#ODR]		;read
	movs r2, #0x100			;modify: clear bit 8 LED apagado al inicio
	bics r1, r1, r2
	str  r1, [r0,#ODR]		;write

	pop {pc}

LED_Toggle
	push {lr}

	;GPIOE->ODR ^= 1<<13 EvalBoard / Discovery
	;GPIOB->ODR ^= 1<<3 K8
	;GPIOA->ODR ^= 1<<5 RE
	;GPIOB->ODR ^= 1<<8 G4

	ldr  r0, =GPIOB		;read
	ldr  r1, [r0,#ODR]
	movs r2, #0x100		;modify
	eors r1, r1, r2
	str  r1, [r0,#ODR]	;write

	pop {pc}

	end
