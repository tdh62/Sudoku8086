PAGE 60,132
TITLE A04ASM2 .EXE PROGRAM
;==================================
;=====START OF STACK SEGMENT=======
STACKSG SEGMENT PARA    STACK   'Stack'
	DB	64	DUP(?)

STACKSG ENDS
;=====END OF STACK SEGMENT==========
;===================================
;=====START OF DATA SEGMENT=========
DATASG  SEGMENT PARA    'Data'
	;Those data use for int21-0AH and int21-09H fuction
	;;;MAXBUFF	DB	40	;Set max buffer length
	STRIN	DB	'$$$$$$$$$$$$$$$$$$$$$$$'
	NOWXY	DB	1
			DB	1
	ANS		DB	80 DUP('$')
	ANS1	DB	'162534354612245163631425426351513246$' ;31,36,32,35,33,34,33,35,34,36,31,32,32,34,35,31,36,33,36,33,31,34,32,35,34,32,36,33,35,31,35,31,33,32,34,36
	TEM2	DB	0
			DB	'$'
	GETIN	DB	2 DUP('$');set int input buffer
	OUTPB	DB	2 DUP('$');
	TITL	DB	'IBM-PC Assembly Programming$'
	AUTS	DB	'Authors: $'
	AUT1	DB	'Tan daohuan -201511106312 $'
	AUT2	DB	'Wu xiaoyu   -201511106246 $'
	AUT3	DB	'Zhang liyuan-201511106340 $'
	AUOFF	DB	'--Enter automatically after 5 second-- $'
	END1	DB	'Thank you for using and have a nice day $'
	MAISS	DB	'Select the function $'
	MAIS1	DB	'1.Instructions $'
	MAIS2	DB	'2.Enter into program $'
	MAIS3	DB	'3.About this program $'
	MAIS4	DB	'4.Exit $'
	ABO1	DB	'--Press any key to continue-- $'
	CLST	DB	'Clean screen $'
	USEL1	DB	'Use w a s d (lower) to move and use 1~6 to input$'
	USEL2	DB	'Use Enter to Check and ESC to exit, be sure finished it.More help please see instructions$'
	LINEX	DB	'-----------------------$'
	LINEX2	DB	'=======================$'
	LINEY	DB	'| $'
	XY		DB	37	DUP('0')
	WRONG 	DB 'Have some wrong,try again',0dh,0ah,'$'
    RIGHT	DB 'excellent!',0dh,0ah,'$' 
	INTRO1	DB 'program instruction',0dh,0ah,0dh,0ah,'	1.this program is a Sudoku game, although only one problem,',0dh,0ah,'	but still allows users to experience the infinite fun of Sudoku','$' 
	INTRO2	DB '2.how to use the program','$'
	INTRO3	DB 'Cursor movement: A, left S,below W,upward D, right',0dh,0ah,'	Numeric input: the number 1-6 that accepts only the main keyboard',0dh,0ah,'	Press Enter to check',0dh,0ah,'	To return to the main screen, press ESC','$' 
	INTRO4	DB '3.what is Sudoku?','$'
	INTRO5	DB 'Each horizontal row has six compartments, each of which is called row',0dh,0ah,'	Each column in the vertical direction is six lattices, each column is ',0dh,0ah,'	called the column','$'
	INTRO6	DB 'The two lines intersect with the three columns. There are six',0dh,0ah,'	compartments, each of which is called the sixth palace, or the palace','$'
	INTRO7	DB 'Fill in the empty squares with numbers 1 through 6 (for 6x6 puzzles) ',0dh,0ah,'	so that each row, column, and every palace has no duplicate numbers','$' 
DATASG	ENDS
;=====END OF DATA SEGMENT===========
;===================================
;======START OF CODE SEGMENT========
CODESG  SEGMENT PARA    'Code'
;;;ORG	0H
;------start of main fuction--------
	MAIN    PROC    FAR
		ASSUME  SS:STACKSG,DS:DATASG,CS:CODESG ;define the segment
		MOV     AX,DATASG
		MOV     DS,AX
		;;;CALL MOVT
		CALL	RERESET;���üĴ���
		CALL	SHOWWL;��ʾ��ӭҳ��
		CALL	MAINS;��ʾ��ѡ��
		;CALL	CHUTI
	MAIN    ENDP
	;------end of main fuction-----------
	
	;============ONLY FOR TEST===========
	TES	PROC	NEAR
		RET	;Return to caller
	TES	ENDP
	;============ONLY FOR TEST===========
	
	;------start of rereset fuction------
	;##########################################
	;#This fuction [backup the regeist to stack]#
	;#and set AX,BX,CX,DX regeist to 0000H    #
	;#�˺�����ռĴ�������ֵ                  #
	;##########################################
	RERESET	PROC	NEAR
		;PUSH	DX
		;PUSH	CX
		;PUSH	BX
		;PUSH	AX;buckup for the regeist
		MOV		AX,0000H
		MOV		BX,0000H
		MOV		CX,0000H
		MOV		DX,0000H;Set AX,BX,CX,DX to 0
		RET		;Return to caller
	RERESET	ENDP
	;--------end of rereset fuction------
	
	;------start of SHOWWL fuction------
	;##########################################
	;#This fuction show welcome page          #
	;#�˺�����ʾ��ӭ���漰����                #
	;##########################################
	SHOWWL	PROC	NEAR
		CALL	ABOUO;��ʾ�����Ϣ
		
		MOV		DH,19
		MOV		DL,20
		CALL	GOTOXY
		LEA		DX,AUOFF
		CALL	OUTPU
		
		MOV		BX,0500H
		CALL	DELAY;�ӳ�5��
		RET;return to caller
	SHOWWL	ENDP
	;--------end of SHOWWL fuction------
	
	;----start of getinpu(t) fuction-----
	;##########################################
	;#This fuction are used to get a input    #
	;#from keyboard and push it into data seg.#
	;#��������ȡ�û�����(�����û�)            #
	;##########################################
	GEINPU	PROC	NEAR
		;PUSH	AX;backup AX
		MOV		AX,0700H
		INT		21H;call int 21-01h(return AL = character read from standard input)
		;MOV		[STRIN],AL;copy AL to datasg
		;POP		AX;reset AX
		RET	;Return to caller
	GEINPU	ENDP
	;-------end of getinpu(t) fuction-----
	
	;------start of CLEANSC fuction------
	;##########################################
	;#This fuction used to clean the screen   #
	;#�˺��������������                      #
	;##########################################
	CLEANSC	PROC	NEAR
		;MOV AX,0600H;AH = 06h
					;AL = number of lines by which to scroll up (00h = clear entire window)
		;MOV BH,070H;BH = attribute used to write blank lines at bottom of window
		;MOV CX,0000;CH,CL = row,column of window's upper left corner
		;MOV DX,0FFFFH;row,column of window's lower right corner 
		;INT 10H;CALL int10-06H (return nothing)
		;old fuction full all screen use something of it.
		PUSH	AX
		MOV		AX,0003H
		INT		10H
		POP		AX;BACKUP AND RESET AX RERESET
		;0527,Change clean screen fuction to use int10h-al=03 to clean
		CLEANSC	ENDP
	;--------end of CLEANSC fuction------
	;------start of gotoA fuction------
	;##########################################
	;#�˺����ƶ����λ�õ�ָ����������        #
	;##########################################
	GOTOA	PROC	NEAR
		PUSH	AX
		PUSH	DX
		PUSH 	BX
		MOV		BH,NOWXY
		MOV		BL,NOWXY+1
		
		MOV 	AL,02;׼������
		MUL		BH;���1����˵ý��
		MOV		BH,AL;���ݷ���
		
		ADD		BH,6;��ʼ��λ
		
		MOV		AL,04;׼������
		MUL		BL;��������ַ�
		MOV		BL,AL
		ADD		BL,23
		MOV		DX,BX
		CALL	GOTOXY
		POP		BX
		POP		DX
		POP		AX
		RET;Return to caller
		
	GOTOA	ENDP
	;--------end of GOTOA fuction------
	;------start of gotoxy fuction------
	;##########################################
	;#This fuction used to set CURSOR POSITION#
	;#need set DH=line DL=row                 #
	;#�˺����ƶ����λ�ã���ҪԤ���趨DH=�У� #
	;#DL=��                                   #
	;##########################################
	GOTOXY	PROC	NEAR
		PUSH	AX
		PUSH	BX;backup AX,BX
		MOV 	AH,02H
		MOV 	BH,00
		INT 	10H
		POP		BX
		POP		AX;reset AX,BX
		RET		;Return to caller
		
	GOTOXY	ENDP
	;--------end of gotoxy fuction------
	;----start of outpu(t) fuction-----
	;##########################################
	;#This fuction are used to get a input    #
	;#from keyboard and push it into data seg.#
	;#�����������ʾ����Ҫ��ǰ�趨DS:DXֵ     #
	;##########################################
	OUTPU	PROC	NEAR
		;PUSH	AX;backup AX
		;PUSH	DX;backup DX
		;MOV     AX,DATASG
		;MOV     DS,AX
		MOV		AX,0900H
		INT		21H
		;POP		DX;reset DX
		;POP		AX;reset AX
		RET	;Return to caller
	OUTPU	ENDP
	;-------end of outpu(t) fuction-----
	;----start of OUTPUCOlOR fuction-----
	;##########################################
	;#This fuction are used to get a input    #
	;#from keyboard and push it into data seg.#
	;#�����������������ʾ  				  #
	;##########################################
	OUTPUCOlOR PROC	NEAR
		PUSH	AX
		PUSH	CX
        MOV		AH,09H              ;Request display
        MOV		BH,00                ;Page 00
        MOV		BL,0AH
        MOV 	CX,01                ;One character
        INT 	10H
		POP		CX
		POP		AX
        RET
    OUTPUCOlOR ENDP
	

    ;-------end of OUTPUCOlOR fuction-----
	;##########################################
	;#This fuction get the string input from .#
	;#the buffer of DOS system and save it to #
	;#data segment .                          #
	;#��������ȡ�û�������ַ���              #
	;##########################################
	GETSTR	PROC	NEAR
		PUSH	AX
		PUSH	BX
		PUSH	CX
		PUSH	DX;BACKUP
		MOV		DX,OFFSET OUTPB;set the length of buffer
		MOV		AH,0AH;use the 0a line call
		LEA		DX,[STRIN]
		INT		21H;call int21h
		POP		DX
		POP		CX
		POP 	BX
		POP		AX;RESET
		RET;Return to caller
	GETSTR	ENDP
	;------end of GETSTRING fuction-----
	


	;----start of delay fuction-----
	;##########################################
	;#This fuction are used to break and delay#
	;#sometime not for wait                   #
	;#�˺�����ʱ���� ��Ԥ��BXΪ��ʱʱ��       #
	;##########################################
	DELAY	PROC NEAR
		PUSH	AX
		PUSH	BX
		PUSH	CX
		PUSH	DX;BACKUP RESGEIST
		MOV 	AH,2CH
		INT		21H;get current system time
		;MOV DX,BX;move the DX to BX for cmp
		;ADD BX,0500H;set the time need to delay
		CMP		DH,55;�������5����ʱ�趨
		JE		BITI
		JA		BITI
		JMP		NETT
BITI:	ADD		CL,1;����60���+1
		MOV		AL,CL;�Ĵ��
		ADD		BX,DX
		SUB		BX,60;��������
		JMP		TIMEO
NETT:	MOV		AL,CL;�Ĵ��
		ADD		BX,DX;������

TIMEO:	INT 	21H;Loop untill system time lager than BX
		CMP 	CL,AL;�ȽϷ�
		JE		TIMEO1
		JA		TIMEO1
		JMP		TIMEO
TIMEO1:	CMP		BX,DX;�Ƚ���
		JA		TIMEO
		POP		DX
		POP		CX
		POP		BX
		POP		AX;RESET REGEIST
		RET		;return to caller
	DELAY	ENDP
	;--------end of delay fuction------	
	;------start of BYEBYE fuction------
	;##########################################
	;#This fuction is the END page of program #
	;#������Ϊ�������ҳ��                    #
	;##########################################
	BYEBYE	PROC	NEAR
		CALL	CLEANSC;����
		MOV     AX,DATASG
		MOV     DS,AX		
		MOV		DH,12
		MOV		DL,21
		CALL	GOTOXY
		CALL	RERESET
		LEA		DX,END1
		CALL	OUTPU;��ʾ������
		MOV		BX,0250H
		CALL	DELAY;��ʱ2.5��
		CALL	CLEANSC;�ٴ�����
		MOV		DX,0000H
		CALL	GOTOXY;��긴λ
		MOV     AX,4C00H
		INT     21H;�������
	BYEBYE	ENDP
	;--------end of BYEBYE fuction------	
	;------start of MAINS fuction------
	;##########################################
	;#This fuction is the main page of program#
	;#������Ϊ������ѡ������                  #
	;##########################################
	MAINS	PROC	NEAR
MSSTA:	CALL	CLEANSC;����
		MOV     AX,DATASG
		MOV     DS,AX		
		MOV		DH,4
		MOV		DL,30
		CALL	GOTOXY
		LEA		DX,MAISS
		CALL	OUTPU
		
		MOV		DH,10
		MOV		DL,30
		CALL	GOTOXY
		LEA		DX,MAIS1
		CALL	OUTPU
		
		MOV		DH,12
		MOV		DL,30
		CALL	GOTOXY
		LEA		DX,MAIS2
		CALL	OUTPU
		
		MOV		DH,14
		MOV		DL,30
		CALL	GOTOXY
		LEA		DX,MAIS3
		CALL	OUTPU
		
		MOV		DH,16
		MOV		DL,30
		CALL	GOTOXY
		LEA		DX,MAIS4
		CALL	OUTPU
		
		MOV		DH,22
		MOV		DL,25
		CALL	GOTOXY
		LEA		DX,TITL
		CALL	OUTPU
		
CHEC:	CALL	GEINPU
		CMP		AL,31H
		JE		TOINS
		CMP		AL,32H
		JE		TOPRO
		CMP		AL,33H
		JE		TOABO
		CMP		AL,34H
		JE		TOBYE
		JMP		CHEC
		
		;MOV		BX,1000H
		;CALL	DELAY
TOINS:	CALL	INSS;���˵��
		JMP		MSSTA
TOPRO:	CALL	MOVT;����
		JMP		MSSTA
TOABO:	CALL	ABOUT;�������
		JMP		MSSTA
TOBYE:	CALL	BYEBYE;����
	MAINS	ENDP
	;--------end of MAINS fuction------	
	
	;------start of ABOUO fuction------
	;##########################################
	;#This fuction is the instructions of pro.#
	;#�˺���Ϊ�����������1                   #
	;##########################################
	ABOUO	PROC	NEAR
		CALL	CLEANSC;����
		MOV     AX,DATASG
		MOV     DS,AX		
		MOV		DH,5
		MOV		DL,24
		CALL	GOTOXY
		LEA		DX,TITL
		CALL	OUTPU
		
		MOV		DH,9
		MOV		DL,24
		CALL	GOTOXY
		LEA		DX,AUTS
		CALL	OUTPU
		
		MOV		DH,10
		MOV		DL,24
		CALL	GOTOXY
		LEA		DX,AUT1
		CALL	OUTPU
		
		MOV		DH,11
		MOV		DL,24
		CALL	GOTOXY
		LEA		DX,AUT2
		CALL	OUTPU
		
		MOV		DH,12
		MOV		DL,24
		CALL	GOTOXY
		LEA		DX,AUT3
		CALL	OUTPU
		RET;return to caller
	ABOUO	ENDP
	;--------end of INSS fuction------
		;------start of ABOUO fuction------
	;##########################################
	;#This fuction is the instructions of pro.#
	;#�˺���Ϊ���ʹ��˵������                #
	;##########################################
	TNTRO	PROC	NEAR
		CALL	CLEANSC;����
		MOV     AX,DATASG
		MOV     DS,AX		
		MOV		DH,3
		MOV		DL,30
		CALL	GOTOXY
		LEA		DX,INTRO1
		CALL	OUTPU
			
		MOV		DH,8
		MOV		DL,8
		CALL	GOTOXY
		LEA		DX,INTRO2
		CALL	OUTPU
		
		MOV		DH,9
		MOV		DL,8
		CALL	GOTOXY
		LEA		DX,INTRO3
		CALL	OUTPU
		
		MOV		DH,14
		MOV		DL,8
		CALL	GOTOXY
		LEA		DX,INTRO4
		
		CALL	OUTPU
		MOV		DH,15
		MOV		DL,8
		CALL	GOTOXY
		LEA		DX,INTRO5
		
		CALL	OUTPU
		MOV		DH,18
		MOV		DL,8
		CALL	GOTOXY
		LEA		DX,INTRO6
		
		CALL	OUTPU
		MOV		DH,20
		MOV		DL,8
		CALL	GOTOXY
		LEA		DX,INTRO7
		CALL	OUTPU
		RET;return to caller
	TNTRO	ENDP
	;--------end of INSS fuction------
	;------start of INSS fuction------
	;##########################################
	;#This fuction is the instructions of pro.#
	;#�˺���Ϊ���ʹ��˵��                    #
	;##########################################
	INSS	PROC	NEAR
		PUSH	AX;BACKUP AX
		CALL	TNTRO;��ʾ��Ϣ
		
		MOV		DH,23
		MOV		DL,23
		CALL	GOTOXY
		LEA		DX,ABO1
		CALL	OUTPU
		
		CALL	GEINPU;�ж�ȡһ�ΰ���
		POP		AX;RESET AX
		RET;return to caller
	INSS	ENDP
	;--------end of INSS fuction------
	
	
	
	;;;------start of PROGR fuction------
	;;;##########################################
	;;;#This fuction is the program             #
	;;;#�˺���Ϊ����ʵ�������                  #
	;;;##########################################
	;;PROGR	PROC	NEAR
	;;	CALL	MOVT
	;;	RET;return to caller
	;;PROGR	ENDP
	;;;--------end of PROGR fuction------
	
	
	;------start of ABOUT fuction------
	;##########################################
	;#This fuction is about of this program   #
	;#�˺���Ϊ���ڱ��������                  #
	;##########################################
	ABOUT	PROC	NEAR
		PUSH	AX;BACKUP AX
		CALL	ABOUO;��ʾ��Ϣ
		
		MOV		DH,19
		MOV		DL,24
		CALL	GOTOXY
		LEA		DX,ABO1
		CALL	OUTPU
		
		CALL	GEINPU;�ж�ȡһ�ΰ���
		POP		AX;RESET AX
		RET;return to caller
	ABOUT	ENDP
	;--------end of ABOUT fuction------
	
	;----start of movt fuction-----
	;##########################################
	;#�������̿��ƹ���ƶ�                    #
	;##########################################
	MOVT	PROC	NEAR
		CALL	CLEANSC
		CALL	CHUTI
		CALL	LINE
		CALL	GOTOA
STT:	CALL	GEINPU
		
		;�������봦��
		CMP 	AL,31H
		JE		CN11
		CMP	 	AL,32H
		JE		CN11
		CMP 	AL,33H
		JE		CN11
		CMP 	AL,34H
		JE		CN11
		CMP 	AL,35H
		JE		CN11
		CMP 	AL,36H
		JE		CN11
		JMP 	KEY1
CN11:	;SUB AL,30H	
		MOV 	TEM2,AL
		;MOV	TEM2+1,'&'
		LEA		DX,TEM2
		CALL	SAVEI
		CALL	OUTPU
		;CALL	OUTPUCOlOR

		CALL	GOTOA
		JMP		STT
		;�����ִ���
KEY1:	CMP		 AL,77H
		JE 		KUP;����W����
		CMP		 AL,61H
		JE		 KLEF;����A����
		CMP		AL,64H
		JE 		KRIG;����D����
		CMP		AL,73H
		JE 		KDOW;����S����
		;;�趨�˳�(ESC)
		CMP		AL,1BH
		JE		EN11
		;;���س�
		CMP		AL,0DH
		JE		CHE
		JMP 	STT		
		

		
KUP:	CMP 	NOWXY,1
		JE 		UPL
		SUB		NOWXY,1
		JMP 	EN	
UPL:	MOV 	NOWXY,6
		JMP 	EN
		
		
KLEF:	CMP 	NOWXY+1,1
		JE 		LFL
		SUB		NOWXY+1,1
		JMP 	EN
LFL:	MOV 	NOWXY+1,6
		JMP 	EN
		
		
KRIG:	CMP		NOWXY+1,6
		JE 		RIL
		ADD		NOWXY+1,1
		JMP 	EN
RIL:	MOV 	NOWXY+1,1
		JMP 	EN
		
		
KDOW:	CMP 	NOWXY,6
		JE 		DOL
		ADD		NOWXY,1
		JMP 	EN
DOL:	MOV 	NOWXY,1
		JMP 	EN

		
EN:		MOV 	DL,NOWXY
		MOV 	DH,NOWXY+1

		CALL	GOTOA
		JMP 	STT
CHE:	MOV		NOWXY,00
		MOV		NOWXY+1,01
		CALL	CHECK
EN11:	;RET
		;MOV AX,4C00H
		;INT	21H;;��ʱ������

		RET	;Return to caller
	MOVT	ENDP
	;-------end of movt fuction-----
	;------start of LINE fuction------
	;##########################################
	;#�˺���Ϊ����                            #
	;##########################################
	LINE	PROC	NEAR
		MOV		CX,11;�趨ѭ������
		MOV		DH,7
		MOV		DL,25;��λ
L2:		ADD		DH,1
		CALL	GOTOXY
		PUSH	DX;BACKUP DX
		LEA		DX,LINEY
		CALL	OUTPU;������
		POP		DX;RESET DX
		LOOP	L2
		
		MOV		CX,11;�趨ѭ������
		MOV		DH,7
		MOV		DL,49;��λ
L3:		ADD		DH,1
		CALL	GOTOXY
		PUSH	DX;BACKUP DX
		LEA		DX,LINEY
		CALL	OUTPU;������
		POP		DX;RESET DX
		LOOP	L3	
		
		MOV		DH,6
		MOV		DL,29
		MOV		CX,6;�趨ѭ������
L4:		ADD		DH,2
		CALL	GOTOXY
		PUSH	DX
		LEA		DX,LINEY
		CALL	OUTPU;������
		POP		DX
		LOOP	L4
		MOV		DH,6
		MOV		DL,33
		MOV		CX,6;�趨ѭ������
L5:		ADD		DH,2
		CALL	GOTOXY
		PUSH	DX
		LEA		DX,LINEY
		CALL	OUTPU;������
		POP		DX
		LOOP	L5	
		MOV		DH,6
		MOV		DL,41
		MOV		CX,6;�趨ѭ������
L6:		ADD		DH,2
		CALL	GOTOXY
		PUSH	DX
		LEA		DX,LINEY
		CALL	OUTPU;������
		POP		DX
		LOOP	L6
		MOV		DH,6
		MOV		DL,45
		MOV		CX,6;�趨ѭ������
L7:		ADD		DH,2
		CALL	GOTOXY
		PUSH	DX
		LEA		DX,LINEY
		CALL	OUTPU;������
		POP		DX
		LOOP	L7
		MOV		DH,6
		MOV		DL,37
		MOV		CX,6;�趨ѭ������
L8:		ADD		DH,2
		CALL	GOTOXY
		PUSH	DX
		LEA		DX,LINEY
		CALL	OUTPU
		POP		DX
		LOOP	L8
		;��������
		
		MOV		DH,07
		MOV		DL,26
		CALL	GOTOXY
		LEA		DX,LINEX
		CALL	OUTPU
		MOV		DH,09
		MOV		DL,26
		CALL	GOTOXY
		LEA		DX,LINEX
		CALL	OUTPU		
		MOV		DH,13
		MOV		DL,26
		CALL	GOTOXY
		LEA		DX,LINEX
		CALL	OUTPU		
		MOV		DH,17
		MOV		DL,26
		CALL	GOTOXY
		LEA		DX,LINEX
		CALL	OUTPU
		MOV		DH,19
		MOV		DL,26
		CALL	GOTOXY
		LEA		DX,LINEX
		CALL	OUTPU
		;��������
		MOV		DH,11
		MOV		DL,26
		CALL	GOTOXY
		LEA		DX,LINEX2
		CALL	OUTPU
		MOV		DH,15
		MOV		DL,26
		CALL	GOTOXY
		LEA		DX,LINEX2
		CALL	OUTPU	
		;˫������
		MOV		DH,21
		MOV		DL,15
		CALL	GOTOXY
		LEA		DX,USEL1
		CALL	OUTPU;˵������1

		MOV		DH,22
		MOV		DL,0
		CALL	GOTOXY
		LEA		DX,USEL2
		CALL	OUTPU;˵������2
		CALL	GOTOA
		;�ض�λ���
		
		
		
		RET;return to caller
	LINE	ENDP
	;--------end of LINE fuction------
	
	;--------start of check fuction------	
	;##########################################
	;#�˺��������ж�������ȷ���	          #
	;##########################################
	CHECK	PROC NEAR
	PUSH		SI;
	PUSH		CX;
	PUSH		AX;
	PUSH		DX;
		 MOV 	SI,0			;ƫ��ֵ
         MOV 	CX,36			;ѭ���жϴ���
AGAIN2:  MOV 	AL,ANS1[SI]	
		 SHL 	SI,01			;ans1�ڴ浥Ԫ��ַƫ����Ϊans���ڴ浥Ԫ��ַƫ������2��
         CMP 	ANS[SI+2],AL	;�����ж����ڴ����������Ƿ����
         JNZ 	NOMATCH		;��������ת
		 SHR 	SI,01			;�ָ�si
         INC 	SI				;��һƫַ
         DEC 	CX				;�ƴ�
         JNZ 	AGAIN2
         CMP 	CX,0
		 JZ  	MATCH   
NOMATCH:					;������ʾ
		CALL 	CLEANSC
		MOV	 	DH,13
		MOV 	DL,27
		CALL 	GOTOXY
		MOV 	DX,offset WRONG
        MOV 	AH,09h
		INT 	21h
		JMP		ENDCH
MATCH: 						;��ȷ��ʾ
		CALL 	CLEANSC
		MOV 	DH,12
		MOV 	DL,27
		CALL 	GOTOXY
		mov 	DX,offset RIGHT
		MOV 	AH,09h
		INT 	21h
ENDCH:						;�ȴ���������������˵�
		MOV 	DH,19
		MOV 	DL,25
		CALL 	GOTOXY
		LEA		DX,ABO1
		CALL	OUTPU
		CALL	GEINPU
		POP		SI;
		POP		CX;
		POP		AX;
		POP		DX;
	CHECK	ENDP
	;--------end of check fuction------
	
	;--------start of SAVEI fuction------	
	;##########################################
	;#�˺���������д���ڴ��Ӧ����	          #
	;##########################################
	SAVEI	PROC NEAR
		PUSH	AX
		PUSH	AX;SAVE AX
		MOV     AX,DATASG
		MOV     DS,AX
		MOV		AX,0
		MOV		CL,AL
		MOV		AL,NOWXY
		SUB		AL,1
		MOV		BL,06
		MUL		BL	;AX=06*(NOWXY-1)
		ADD		AL,NOWXY+1 
		LEA		BX,ANS
		ADD		AL,AL
		ADD		BL,AL
		;LEA		DX,ANS+AL;ȷ���ڴ��ַ
		POP		AX
		MOV		[BX],AX;д�ڴ�
		;����
		;LEA	DX,ANS
		;ADD	DX,1
		;CALL	OUTPU
		POP		AX
		RET		;RETRUN TO CALLER		
	SAVEI	ENDP
	;--------end of SAVEI fuction------
	
	;--------start of chuti fuction------	
	;##########################################
	;#�˺������ڳ���            	          #
	;##########################################
	CHUTI	PROC NEAR
		PUSH	AX
		MOV		NOWXY,1
		MOV		NOWXY+1,3
		CALL	GOTOA	;�����������Ӧλ��
		MOV		AL,32H      ;��Ӧ����
		CALL	OUTPUCOlOR	;�Բ�ͬ��ɫ��ʾ
		CALL	SAVEI	;����
		
		MOV		NOWXY,1
		MOV		NOWXY+1,4
		CALL	GOTOA
		MOV		AL,35H
		CALL	OUTPUCOlOR
		CALL	SAVEI

		MOV		NOWXY,2
		MOV		NOWXY+1,2
		CALL	GOTOA
		MOV		AL,35H
		CALL	OUTPUCOlOR
		CALL	SAVEI
	
		MOV		NOWXY,2
		MOV		NOWXY+1,5
		CALL	GOTOA
		MOV		AL,31H
		CALL	OUTPUCOlOR
		CALL	SAVEI
		
		MOV		NOWXY,3
		MOV		NOWXY+1,1
		CALL	GOTOA
		MOV		AL,32H
		CALL	OUTPUCOlOR
		CALL	SAVEI
		
		MOV		NOWXY,3
		MOV		NOWXY+1,6
		CALL	GOTOA
		MOV		AL,33H
		CALL	OUTPUCOlOR
		CALL	SAVEI
		
		MOV		NOWXY,4
		MOV		NOWXY+1,1
		CALL	GOTOA
		MOV		AL,36H
		CALL	OUTPUCOlOR
		CALL	SAVEI
		
		MOV		NOWXY,4
		MOV		NOWXY+1,6
		CALL	GOTOA
		MOV		AL,35H
		CALL	OUTPUCOlOR
		CALL	SAVEI
		
		MOV		NOWXY,5
		MOV		NOWXY+1,2
		CALL	GOTOA
		MOV		AL,32H
		CALL	OUTPUCOlOR
		CALL	SAVEI
		
	    MOV		NOWXY,5
		MOV		NOWXY+1,5
		CALL	GOTOA
		MOV		AL,35H
		CALL	OUTPUCOlOR
		CALL	SAVEI
		
		MOV		NOWXY,6
		MOV		NOWXY+1,3
		CALL	GOTOA
		MOV		AL,33H
		CALL	OUTPUCOlOR
		CALL	SAVEI
		
	    MOV		NOWXY,6
		MOV		NOWXY+1,4
		CALL	GOTOA
		MOV		AL,32H
		CALL	OUTPUCOlOR
		CALL	SAVEI
		
		MOV		NOWXY,1
		MOV		NOWXY+1,1		
		POP		AX
		RET;RETURN TO CALLER
		
	CHUTI	ENDP
	;--------end of chuti fuction------


CODESG ENDS
;=======END OF CODE SEGMENT===========


END MAIN

