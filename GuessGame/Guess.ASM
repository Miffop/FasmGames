use16
org 100h
jmp start
t1 db 'Try to guess the number 1-1024',10,'$'
t2 db 'Your guess: $'
tg db 'My number is greater',10,'$'
tl db 'My number is less',10,'$'
te db 'Write the NUMBER pls',10,'$'
tw db 'You have done it, congrads!!!$'
yn dw  0
mn dw  666
mtl dw 0
ten dw 10,100,1024
buf db 6,0,0,0,0,0,0
start:
        ;Generating random number
        mov ah,2ch
        int 21h
        movzx ax,dh
        movzx bx,dl
        mul [ten+2]
        add ax,bx
        div [ten+4]
        xor dx,0101010101b
        inc dx
        mov [mn],dx
        ;writing the goal
        mov ah,09h
        mov dx,t1
guess:
        int 21h;optimisation for 8-10 bytes
        ;input things
        mov ah,09h
        mov dx,t2
        int 21h
        mov ah,0ah
        mov dx,buf
        int 21h
        mov ah,02h
        mov dl,10
        int 21h
        ;convert строка to number
        mov di,buf
        add di,1
        movzx ax,byte[buf+1]
        add di,ax;set di to the last digit
        mov bx,0
        mov [mtl],1
        movzx cx,[buf+1]
        lp1:
        ;get digit
        movzx si,byte[di]
        dec di
        ;check if it is a digit
        cmp si,47
        jna error
        cmp si,57
        ja error
        sub si,48
        ;add the digit to bx
        mov ax,si
        mul [mtl]
        add bx,ax
        mov ax,[mtl]
        mul [ten]
        mov [mtl],ax
        loop lp1
        mov [yn],bx
        ;comparison
        mov ah,09h
        mov bx,[mn]
        mov cx,[yn]
        cmp bx,cx
        ja gcase
        je gend
        jmp lcase
gcase:
        mov dx,tg
        jmp guess
lcase:
        mov dx,tl
        jmp guess
error:
        mov ah,09h
        mov dx,te
        jmp guess
gend:
        mov ah,09h
        mov dx,tw
        int 21h
        mov ax,4C00h
        int 21h

