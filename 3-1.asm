DATAS SEGMENT
    ;�˴��������ݶδ���  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
    MOV BL,10H
    MOV CH,0EH
NEW_LINE:
    MOV Cl,10H
    
    MOV AH,02H
    MOV DL,13;����
    INT 21H
    MOV AH,02H
    MOV DL,10;�������
    INT 21H
NEXT_CHAR:    
    MOV AH,02H
    MOV DL,BL
    INT 21H
    
    MOV AH,02H
    MOV DL,0
    INT 21H
    
    ADD BL,01H
    SUB CL,1
    JNZ NEXT_CHAR
    SUB CH,1
    JNZ NEW_LINE
OVER:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


