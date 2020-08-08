data    segment
enter_name db 'Input name:','$'
enter_phone db 'Input a telephone number:','$'
tip db 'Do you want to search a telephone number?(y/n)','$'
ask_name db 'what is the name?','$'
nofind db 'Not find','$'
enter_num db 'the number you want to store:','$'
tmpn db 21,?,21 dup(?)
tmpp db 9,?,9 dup(?)
table db 50 dup(28 dup(?))
name_count dw 0
endaddr dw ?
swapped dw ?
totalnum dw ?
savenp db 28 dup(?),0dh,0ah,'$'
searchaddr dw ?
flag db ?
flagb db ?
show db 'name                phone',0dh,0ah,'$'
data  ends

code  segment
   assume ds:data,cs:code,es:data
main proc far
       mov ax,data
       mov ds,ax
       mov es,ax
       ;�˴��������δ���
       mov bx,0
	   mov di,offset table;diָ��table
       mov dx,offset enter_num;�����ʾ
       mov ah,09
       int 21h
newchar:;bx��ø���                     
       mov ah,01h              
       int 21h;����
       mov dl,al
       sub al,30h            
       jl next;С��0
       cmp al,39h              
       jg next;����9                
	   mov ah,0             
       xchg ax,bx            
       mov cx,10           
       mul cx                
       xchg ax,bx            
       add bx,ax;(bx)=(bx)*10+(ax)            
       jmp newchar;��һλ
next:
       mov totalnum,bx
       call crlf
a10:
       mov dx,offset enter_name;�����ʾ
       mov ah,09h
       int 21h
       call input_name
       inc name_count;����һ����name_count++
       call stor_name

       mov dx,offset enter_phone;�����ʾ
       mov ah,09h
       int 21h
       call inphone
       call stor_phone

       cmp name_count,0;һ����û��
       je exit
       mov bx,totalnum
       cmp name_count,bx;��û������
       jnz a10
       call name_sort;�����ˣ���ʼ����
 a20:
       mov dx,offset tip;Ҫ��Ҫ����
       mov ah,09h
       int 21h
       mov ah,08h;����
       int 21h
       cmp al,'y'
       jz  a30
       cmp al,'n';�����ˣ��˳�
       jz  exit
       jmp a20;�����ǣ�������
 a30:
       call crlf
       mov dx,offset ask_name;Ҫ��˭
       mov ah,09h
       int 21h
       call input_name
 a40:
       call name_search
       jmp a20
 exit:
       mov ax,4c00h
       int 21h
 main endp
;--------------------------------------------------------------------
input_name proc near
       mov dx,offset tmpn;���뵽������
       mov ah,0ah
       int 21h
       call crlf

       mov bh,0
       mov bl,tmpn+1
       mov cx,21
       sub cx,bx;cxΪʣ���ַ�
b10:
       mov tmpn[bx+2],' ';�Ѻ���Ķ��滻
       inc bx
       loop b10
       ret
input_name endp
;--------------------------------------------------------------------
stor_name proc near
       mov  si,offset tmpn+2
       mov  cx,20
       rep  movsb
       ret
stor_name endp
;--------------------------------------------------------------------
inphone proc near
       mov dx,offset tmpp;���뵽������
       mov ah,0ah
       int 21h

       call crlf
       mov bh,0
       mov bl,tmpp+1
       mov cx,9
       sub cx,bx;cxΪʣ��
c10:
       mov tmpp[bx+2],' ';�滻
       inc bx
       loop c10
       ret
inphone endp
;--------------------------------------------------------------------
stor_phone proc near
       mov si,offset tmpp+2
       mov cx,8
       rep movsb;�Ƶ�table
       ret
stor_phone endp
;--------------------------------------------------------------------
name_sort proc near;����������
       sub di,28
       mov endaddr,di;����λ
c1:
       mov swapped,0
       mov si,offset table
c2:
       mov cx,20
       mov di,si;Դ��Ŀ��
       add di,28
       mov ax,di
       mov bx,si;cmpsb si-di  movsb di<-si
       repz cmpsb;��
       jbe c3      
;chang order
       mov si,bx
       mov di,offset savenp
       mov cx,28
       rep movsb;�Ѹ���Ϣ�Ƶ��ݴ���
       mov cx,28
       mov di,bx
       rep movsb;����һ��������
       mov cx,28
       mov si,offset savenp
       rep movsb;���ݴ������Ƶ�����
       mov swapped,1
 c3:
       mov si,ax
       cmp si,endaddr
       jb  c2;��û�бȵ���β
       cmp swapped,0
       jnz c1;�Ƚ�swapped�ǲ���Ϊ0������û�н�����
       ret
name_sort endp
;--------------------------------------------------------------------
name_search proc near
       mov bx,offset table
       mov flag,0;flag����
d:
       mov cx,20
       mov si,offset tmpn+2
       mov di,bx
       repz cmpsb;�Ƚ�
       jz  d2
       add bx,28 
       cmp bx,endaddr
       jbe d;û��β,������
       sub flag,0;flag�ǲ���Ϊ0����û���ҵ�
       jz nof
       jmp dexit             
nof:
       mov dx,offset nofind
       mov ah,09h
       int 21h
       call crlf;û�ҵ�
d2:
       mov searchaddr,bx
       inc flag;�ҵ���++
       call printline
       add bx,28;��һ����Ϣ
       cmp bx,endaddr
       jbe d;�ǲ���������
       jmp dexit;
       jnz d
dexit:
     ret
name_search endp
;--------------------------------------------------------------------
printline proc  near
       sub flag,0;flag�Ƿ�Ϊ0����û���ҵ�
       jz  no
p10:
       mov ah,09h
       mov dx,offset show
       int 21h;��ӡ����
       mov cx,28
       mov si,searchaddr
       mov di,offset savenp
       rep movsb;�Ƶ�savenp,�������
       mov dx,offset savenp
       mov ah,09h
       int 21h;��ӡת��������绰
       jmp exit
no:    mov dx,offset nofind;û�ҵ�
       mov ah,09h
       int 21h
exit:
       ret
printline endp
;--------------------------------------------------------------------
crlf proc near 			 ;�س�����
	 mov dl,0dh
	 mov ah,02h
	 int 21h

	 mov dl,0ah
	 mov ah,02h
	 int 21h
	 ret
crlf endp
;--------------------------------------------------------------------
code ends
;--------------------------------------------------------------------
end main





