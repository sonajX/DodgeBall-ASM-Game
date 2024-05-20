.model small
.stack 100h
.data

    player_x dw 160
    player_y dw 100
    player_size dw 15

    Message1 db 'Welcome to the game', 13, 10, '$'

.code
    

    Main Proc near  ; ax = ah, al
    mov ax, @data
    mov ds, ax

    mov ah, 00h ;   set configuration to set video mode
    mov al, 13h ;   set video mode to 13h, 320 x 200 pixels
    int 10h

    mov ah, 0bh ; set configuration
    mov bh, 00h ; 
    mov bl, 00h ;   color black
    int 10h


    mov ah, 09h ;   set configuration for printing
    lea dx, Message1
    int 21h ;call dos to print

    ;   call drawPlayer to print at designated coordinates
    call drawPlayer

    mov ah, 4ch
    mov al, 00h
    int 21h
    ret
    main endp

drawPlayer proc near
    mov cx, player_x ; CX = X, set initial x coordinates, 0
    mov dx, player_y ; DX = Y, set initial y coordinates, 0
    ;mov prev_x

    Draw_Player_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 03h ;color white                                   
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; 
        mov ax, cx
        sub ax, player_x
        cmp ax, player_size         ;   15
        JNE Draw_Player_Horizontal
        mov cx, player_x        
        inc dx                  
        mov ax, dx
        sub ax, player_y
        cmp ax, player_size
        jne Draw_Player_Horizontal        
    ret
drawPlayer endp


    end Main