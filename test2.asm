.model small
.stack 100h
.data

    ball_x dw 100
    ball_y dw 160

.code
Main proc near

    mov ax, @data
    mov ds, ax



Main endp
end Main