;declaring and initializing variables
Stack_Size      	EQU     0x400
LCD					EQU		0x40010000
LCD_ROW				EQU		0x0
LCD_COLUMN			EQU		0x4
LCD_COLOR			EQU		0x8
LCD_CONTROL			EQU		0xC
BUTTON				EQU		0x10
BRICK_HEIGHT		EQU		0x19
BRICK_WIDTH			EQU		0x1E
HUMAN_WIDTH			EQU		0X19
HUMAN_HEIGHT		EQU		0X28
BRICK1_ROW			EQU		0X00
BRICK1_COLUMN		EQU		0X00	
BRICK2_ROW			EQU		0X50
BRICK2_COLUMN		EQU		0X00
BRICK3_ROW			EQU		0XA0
BRICK3_COLUMN		EQU		0X00
HUMAN_ROW			EQU		0XC8
HUMAN_COLUMN		EQU		0X78
MAX_COLUMN			EQU		0X140
NUMBER_OF_BRICKS	EQU		0X03
HUMAN_VERTICAL_SPEED EQU	0X18
HUMAN_HORIZONTAL_SPEED EQU  0X14
COLLISION_TOLERANCE_Y	EQU 0X1E
COLLISION_TOLERANCE_X	EQU 0X14
	
	
	
				 AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem        SPACE   Stack_Size
__initial_sp

				 AREA    RESET, DATA, READONLY
                 EXPORT  __Vectors
                 EXPORT  __Vectors_End

;vector table
__Vectors        DCD     __initial_sp               ; Top of Stack
                 DCD     Reset_Handler              ; Reset Handler
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	0
				 DCD	Button_Handler
__Vectors_End    
;array-like object I created and allocated memory
				AREA GAMEDATA, DATA, READWRITE
				ALIGN
array_pointer
brick1_row		DCD	0
brick1_column	DCD	0
brick2_row		DCD	0
brick2_column	DCD	0
brick3_row		DCD	0
brick3_column	DCD	0
brick4_row		DCD	0
brick4_column	DCD	0
brick5_row		DCD	0
brick5_column	DCD	0
brick6_row		DCD	0
brick6_column	DCD	0
human_row		DCD	0
human_column	DCD 0
speed			DCD	0


				 AREA    RSTHNDLR, CODE, READONLY
Reset_Handler    PROC
                 EXPORT  Reset_Handler

				 ldr	 r0, =0xE000E100
				 movs	 r1,#1	
				 str	 r1,[r0]						 
			     CPSIE	 i					 
                 LDR     R0, =__main
                 BX      R0
                 ENDP
;for button interrupt
				AREA	 button, CODE, READONLY
Button_Handler	PROC
				EXPORT	 Button_Handler
				push	{r0, r1, r2, r3, r4}
				ldr	 	r0, =0x40010010 ;button register adress
				ldr	 	r1,[r0]
				movs    r3, r1
				movs	r2,#0xFF			
				ands	r1,r1,r2			
				;determines which button pressed
				cmp	 	r1,#16
				beq	 	up_press
				cmp		r1, #32
				beq		down_press
				cmp		r1, #64
				beq		left_press
				cmp		r1, #128
				beq		right_press
				str	 	r3,[r0]
				pop		{r4, r3, r2, r1, r0}
				bx		lr			
				ENDP 

				;necessary function is called according to the pressed button
up_press		str	 	r3,[r0]
				mov		r4, lr
				ldr r0,=human_row
				movs r2,#HUMAN_VERTICAL_SPEED
				rsbs  r1,r2,#0
				BL moveobject_y
				mov lr,r4
				pop		{r4, r3, r2, r1, r0}
				
				BX lr
				  	
down_press		str	 	r3,[r0]
				mov		r4, lr
				ldr r0,=human_row
				movs r1,#HUMAN_VERTICAL_SPEED
				BL moveobject_y
				mov lr,r4
				pop		{r4, r3, r2, r1, r0}
				
				BX lr
				
left_press		str	 	r3,[r0]
				mov		r4, lr
				ldr r0,=human_column
				movs r2,#HUMAN_HORIZONTAL_SPEED
				rsbs  r1,r2,#0
				BL moveobject_x
				mov lr,r4
				pop		{r4, r3, r2, r1, r0}
				
				BX lr
				


right_press		str	 	r3,[r0]
				mov		r4, lr
				ldr r0,=human_column
				movs r1,#HUMAN_HORIZONTAL_SPEED
				BL moveobject_x
				mov lr,r4
				pop		{r4, r3, r2, r1, r0}
				
				BX lr



                 AREA    main, CODE, READONLY
				 EXPORT	 __main
				 ENTRY					 
__main 			 PROC
           
				 
				 IMPORT  brick
				 IMPORT  human
				 ;filling arrays elements with variable's values I declared above
				 ldr r0,=brick1_row
				 ldr r1,=BRICK1_ROW
				 str r1,[r0]
				 
				 ldr r0,=brick1_column
				 ldr r1,=BRICK1_COLUMN
				 str r1,[r0]
				 
				 ldr r0,=brick2_row
				 ldr r1,=BRICK2_ROW
				 str r1,[r0]
				 
				 ldr r0,=brick2_column
				 ldr r1,=BRICK2_COLUMN
				 str r1,[r0]
				 
				 ldr r0,=brick3_row
				 ldr r1,=BRICK3_ROW
				 str r1,[r0]
				 
				 ldr r0,=brick3_column
				 ldr r1,=BRICK3_COLUMN
				 str r1,[r0]
				 
				 
				 ldr r0,=human_row
				 ldr r1,=HUMAN_ROW
				 str r1,[r0]
				 
				 ldr r0,=human_column
				 ldr r1,=HUMAN_COLUMN
				 str r1,[r0]
				 
				 ldr r0,=speed
				 ldr r1,=1
				 str r1,[r0]
				 
				
				 
				 ;main game loop
loop			 BL create_game
				 
				 B loop
				 
				 ENDP
				 
				 
				 
					AREA	CREATE_GAME, code, readonly
create_game			proc
					export	create_game
					
					push{r4}
					push{r5}
					push{r6}
					push{r7}
					mov r3,lr
					push{r3}
					
					ldr r4,=speed ;speed of the brick
					movs r5,#0 ;for loop counter
					BL clear_lcd
					ldr r7,=array_pointer ;address of the first element
					
					;arguments for subroutine
					ldr r0,=human_row
					ldr r1,=human
draw		        BL drawhuman ;drawing human

					;checks if human win
					ldr r0,=human_row
					BL check_win
					cmp r0,#1
					beq resetwin
					
					
for_loop			cmp r5,#NUMBER_OF_BRICKS ;iterate as many as the number of bricks

					
					
					beq exit_loop_1	
					
					
					mov r0,r7
					ldr r1,=brick
					
					BL drawbrick ;drawing the brick
					
					mov r0,r7
					movs r1,#1
					BL getrightcorner
					
					BL screencheck
					cmp r0,#1
					
					beq reset
after_reset			
					
					adds r7,r7,#4 ;incrementing array pointer
					
					mov r0,r7
					ldr r1,[r4]
					BL moveobject_x
					
					;getting the midpoints for checkcollision
					mov r0,r7
					subs r0,r0,#4
					BL getbrickmidpoint_y
					mov r6,r0
					
					ldr r0,=human_row
					BL gethumanmidpoint_y
					
					subs r0,r0,r6
					BL absolute_value
					mov r6,r0
					
					mov r0,r7
					BL getbrickmidpoint_x
					mov r3,r0
					
					ldr r0,=human_column
					push{r3} ;in case r3 is changed inside the subroutine
					BL gethumanmidpoint_x
					pop{r3}
					
					subs r0,r0,r3 ;difference in x coordinate values
					BL absolute_value
					;arguments for check collision
					mov r1,r0
					mov r0,r6 ;difference in y coordinate values
					
					
					BL check_collision
					cmp r0,#1
					beq reset_human
after_resethuman					
					adds r5, r5, #1 ;increment loop counter
					adds r7,r7,#4 ;increment array pointer by 4
					B for_loop
					
					
reset				mov r0,r5
					mov r1,r7
					BL reset_position
					
					b after_reset
					

reset_human			 movs r0,#3 ;3 is an argument for the subroutine indicating it should reset human's position
					 ldr r1,=human_row
					 BL reset_position
					 B after_resethuman
					 
resetwin			 movs r0,#3 
					 ldr r1,=human_row
					 BL reset_position
					 B for_loop

exit_loop_1			
					
					BL refresh_lcd ;refreshing the screen
					pop{r3}
					mov lr,r3
					pop{r7}
					pop{r6}
					pop{r5}
					pop{r4}
					
					BX LR	
					ENDP
					
				 
				AREA	MOVEOBJECT_Y, code, readonly
moveobject_y	proc
				export moveobject_y
				ldr r2,[r0]
				add r2,r2,r1 ;updates position
				str r2,[r0]
				BX LR
				ENDP

				AREA	MOVEOBJECT_X, code, readonly
moveobject_x	proc
				export moveobject_x
				ldr r2,[r0]
				add r2,r2,r1 ;updates position
				str r2,[r0]
				BX LR
				ENDP
					

				
					
;subroutine updtaes the lcd color register values which goes in the lcd buffer					
				AREA	DRAWBRICK, code, readonly
drawbrick		proc
				export drawbrick
				push{r4}
				push{r5}
				push{r6}
				push{r7}
				mov r7,lr
				push{r7}
				adds r2, r0, #4
				
				ldr r0,[r0]
				movs r4,#0 ;row counter
				ldr r5,=LCD ;lcd row adress
				ldr r2,[r2]
				
				
for_loop_2		cmp r4,#BRICK_HEIGHT
				beq exit_loop_2
				mov r7,r2
				str r0,[r5]
				
				movs r6,#0 ;column counter
for_loop_3		cmp r6,#BRICK_WIDTH
				beq continue_loop_2
				
				
				str r7, [r5,#0x4]
				adds r7,r7,#1
				ldr r3,[r1]
				str r3,[r5,#0x8]
				
				
				adds r1, r1, #4 ;increment image pointer
				adds r6,r6,#1 ;increments column counter
				B for_loop_3
				
				
				
continue_loop_2	
				adds r0,r0,#1
				adds r4,r4,#1
				B for_loop_2
				
				
				
				
				
exit_loop_2		
				pop{r7}
				mov lr,r7
				pop{r7}
				pop{r6}
				pop{r5}
				pop{r4}
				
				BX LR
				ENDP
;subroutine updtaes the lcd color register values which goes in the lcd buffer
				AREA	DRAWHUMAN, code, readonly	
drawhuman		proc
				export drawhuman
				
				push{r4}
				push{r5}
				push{r6}
				push{r7}
				mov r7,lr
				push{r7}
				adds r2, r0, #4
				
				ldr r0,[r0]
				movs r4,#0 ;row counter
				ldr r5,=LCD ;lcd row adress
				ldr r2,[r2]
				
				
for_loop_4		cmp r4,#HUMAN_HEIGHT
				beq exit_loop_4
				mov r7,r2
				str r0,[r5]
				
				movs r6,#0 ;column counter
for_loop_5		cmp r6,#HUMAN_WIDTH
				beq continue_loop_4
				
				
				str r7, [r5,#0x4]
				adds r7,r7,#1
				ldr r3,[r1]
				str r3,[r5,#0x8]
				
				
				adds r1, r1, #4 ;increment image pointer
				adds r6,r6,#1 ;increments column counter
				B for_loop_5
				
				
				
continue_loop_4	
				adds r0,r0,#1
				adds r4,r4,#1
				B for_loop_4
				
				
				
				
				
exit_loop_4		
				pop{r7}
				mov lr,r7
				pop{r7}
				pop{r6}
				pop{r5}
				pop{r4}
				
				BX LR
				ENDP
;getting the x coordinate of the top-right corner of the object to check if it touches screen boundary			
				AREA	GETRIGHTCORNER, code, readonly	 ;takes 2 arguments r0 is array pointer r1 is marker and retruns the right corner of the object
getrightcorner	proc
				export getrightcorner
				ldr r0,[r0,#0x4] ;r0 is array pointer 
				cmp r1,#1 ;r1 is marker
				beq  ifbrick
				adds r0,r0,#HUMAN_WIDTH
				B return_1
ifbrick			adds r0,r0,#BRICK_WIDTH
return_1		BX LR
				ENDP
	
				AREA	SCREENCHECK, code, readonly	;takes one argument r0 is the right corner of the object and returns 1 if object is out of bounds
screencheck		proc
				export screencheck
				ldr r1,=MAX_COLUMN ;max column
				cmp r0,r1
				bhi out_of_bounds
				movs r0,#0
				B return_2
				
out_of_bounds	movs r0,#1
return_2		BX LR	
				ENDP


				AREA	RESET_POSITION, code, readonly	;takes two argument r0 is a marker to determine which object it should be reset and r1 is the array pointer
reset_position	proc
				export reset_position
				push{r4}
				adds r2,r1,#4
				
			    cmp r0,#0
				beq ifbrick_1
				cmp r0,#1
				beq ifbrick_2
				cmp r0,#2
				beq ifbrick_3
				cmp r0,#3
				beq ifhuman
				

ifbrick_1		movs r3,#BRICK1_ROW	
				str r3,[r1]
				movs r3,#BRICK1_COLUMN
				str r3,[r2]
				B exit_function
				
ifbrick_2		movs r3,#BRICK2_ROW	
				str r3,[r1]
				movs r3,#BRICK2_COLUMN
				str r3,[r2]
				B exit_function

ifbrick_3		movs r3,#BRICK3_ROW	
				str r3,[r1]
				movs r3,#BRICK3_COLUMN
				str r3,[r2]
				B exit_function
	
	
ifhuman			movs r3,HUMAN_ROW
				str r3,[r1]
				movs r3,HUMAN_COLUMN
				str r3,[r2]
				B exit_function
				
exit_function	pop{r4}
				BX LR	
			    ENDP
	
				 AREA	GETBRICKMIDPOINT_Y, code, readonly	;takes one argument r0 and it is the pointer of the row number of the top of the brick
getbrickmidpoint_y proc
				 export getbrickmidpoint_y
				 mov r3,r0
				 ldr r3,[r3]
				 movs r1,#1
				 movs r2,#BRICK_HEIGHT
				 asrs r2,r2,r1
				 add r3,r3,r2
				 mov r0,r3
				 BX LR
				 ENDP
				 
				 AREA	GETHUMANMIDPOINT_Y, code, readonly	;takes one argument r0 and it is the pointer of the row number of the top of the human
gethumanmidpoint_y proc
				 export gethumanmidpoint_y
				 mov r3,r0
				 ldr r3,[r3]
				 movs r1,#1
				 movs r2,#HUMAN_HEIGHT
				 asrs r2,r2,r1
				 add r3,r3,r2
				 mov r0,r3
				 BX LR
				 ENDP
					 
					 
				 AREA	GETBRICKMIDPOINT_X, code, readonly	;takes one argument r0 is the pointer of the column number of the top-left corner
getbrickmidpoint_x proc
				 export getbrickmidpoint_x
				 mov r3,r0
				 ldr r3,[r3]
				 movs r1,#1
				 movs r2,#BRICK_WIDTH
				 asrs r2,r2,r1
				 add r3,r3,r2
				 mov r0,r3
				 BX LR
				 ENDP
					 
				 AREA	GETHUMANMIDPOINT_X, code, readonly	;takes one argument r0 is the pointer of the column number of the top-left corner
gethumanmidpoint_x proc
				 export gethumanmidpoint_x
				 mov r3,r0
				 ldr r3,[r3]
				 movs r1,#1
				 movs r2,#HUMAN_WIDTH
				 asrs r2,r2,r1
				 add r3,r3,r2
				 mov r0,r3
				 BX LR
				 ENDP
				 
;calculates the absoulte value of the passed argument				 
				 AREA	ABSOLUTE_VALUE, code, readonly	
absolute_value	 proc
				 export absolute_value
				 cmp r0,#0
				 BLT negative
				 B return_3
				 
negative		 rsbs r1,r0,#0
				 mov r0,r1
return_3		 BX LR
				 ENDP
				 
				 AREA	CHECK_COLLISION, code, readonly	;takes one argument r0 and it is the distance between midpoints returns 1 if collision happens otherwise returns 0
check_collision	 proc
				 export check_collision
				 cmp r0,#COLLISION_TOLERANCE_Y
				 blt nested_branch
				 B otherwise

nested_branch 		cmp r1,#COLLISION_TOLERANCE_X
					blt collision_happened
					B otherwise
					
collision_happened	movs r0,#1
					b return_4
					
otherwise			movs r0,#0				
return_4			BX LR
					ENDP
						
						
					AREA	CHECK_WIN, code, readonly	 ;takes one argument r0 and it is the pointer of the row index of the human's top side and returns 1 if player win
check_win			proc
					export check_win
					ldr r0,[r0]
					cmp r0,#0
					BLT win
					B win_else
win					movs r0,#1
					B return_5
win_else			movs r0,#0
return_5			BX LR
					ENDP
;refreshes lcd
				AREA	REFRESH_LCD, code, readonly	
refresh_lcd		proc
				export refresh_lcd
				ldr r0,=0x4001000C
				movs r1,#1
				str r1,[r0]
				
				
				
				BX LR
				ENDP
				
				
;clears lcd				
					
				
				AREA	CLEAR_LCD, code, readonly					
clear_lcd		proc
				export clear_lcd
				ldr r0,=0x4001000C
				movs r1,#2
				str r1,[r0]
				;ldr r0,=0x4001000C
				;movs r1,#1
				
				str r1,[r0]
				
				
				
				BX LR
				ENDP
				END
					
					
					
					
					
					
				
				
				
				
				 
				 
				 
				 
	


								
				