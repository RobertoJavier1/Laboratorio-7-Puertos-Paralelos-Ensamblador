#include "RTE_Components.h"
#include CMSIS_device_header


extern void LEDs_Init(void);
extern void LED_Toggle(void);

int main(void){

	SysTick_Config(SystemCoreClock/10);
	LEDs_Init();

	while(1);	
}

void SysTick_Handler(void){
	LED_Toggle();
}
