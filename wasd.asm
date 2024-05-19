.model small
.stack 100h
.data
des db ?
col db ?
line1 db 'Pamantasan ng Lungsod ng Maynila$'
line2 db 'Intramuros, Manila$'
line3 db 'Department of Computer Science$'
line4 db 'Computer Organization and Assembly Language Programming$'
line5 db 'Presents ...$'
line6 db 'Graphics in text mode$'
line7 db 'Arrow keys F1-diamond F2-Heart F3-Spade F4-Club F5-Clear$'

.code
main proc near
	mov ax, @data
	mov ds, ax

	call cls

	mov dh, 04
	mov dl, 24
	call setcur

	lea dx, line1
	call outstr

	mov dh, 05
	mov dl, 32
	call setcur

	lea dx, line2
	call outstr

	mov dh, 10
	mov dl, 25
	call setcur

	lea dx, line3
	call outstr

	mov dh, 12
	mov dl, 12
	call setcur

	lea dx, line4
	call outstr

	mov dh, 20
	mov dl, 33
	call setcur

	lea dx, line5
	call outstr

	mov dh, 22
	mov dl, 27
	call setcur

	lea dx, line6
	call outstr

	mov ah, 08
	int 21h

	call cls

	mov dh, 23
	mov dl, 03
	call setcur

	lea dx, line7
	call outstr

	mov dh, 12
	mov dl, 40
	call setcur

next:mov ah, 00
int 16h

cmp al, 00
jne texit

up:cmp ah, 48h
jne down
dec dh
	call setcur
	jmp next
down:cmp ah, 50h
	jne left
	inc dh
	call setcur
	jmp next
left:cmp ah, 4bh
	jne right
	dec dl
	call setcur
	jmp next
right:cmp ah, 4dh
	jne f1
	inc dl
	call setcur
	jmp next
texit:jmp exit

f1: cmp ah, 3bh
jne f2
	mov des, 04
	mov col, 71h
	call displai
	jmp next
f2: cmp ah, 3ch
jne f3
mov des, 03
mov col, 4dh
	call displai
	jmp next
f3: cmp ah, 3dh
	jne f4
	mov des, 06
	mov col, 70h
	call displai
	jmp next
f4: cmp ah, 3eh
	jne f5
	mov des, 05
	mov col, 25h
call displai
	jmp next
f5: cmp ah, 3fh
	jne exit
	mov des, 20h
	mov col, 07h
	call displai
	jmp next
exit:mov ah, 4ch
	int 21h
main endp

cls proc near
	mov ax, 0600h
	mov bh, 07
	mov cx, 0000
	mov dx, 184fh
	int 10h
	ret
cls endp

setcur proc near
	mov ah, 02
	mov bh, 00
	int 10h
	ret
setcur endp

outstr proc near
	mov ah, 09
	int 21h
	ret
outstr endp

displai proc near
	mov ah, 09
	mov bh, 00
	mov al, des
	mov bl, col
	mov cx, 0001
	int 10h
	ret
displai endp

end main
