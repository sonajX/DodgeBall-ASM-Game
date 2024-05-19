;--------------------------------------------------------------------------------------------------------------------------------
;   Goal:   is to create a pixel with player movement using WASD-
;           and create enemies (or projectiles) that ends the game when hit
;   
;   An ASM small program is divided into sections- 
;    1. Model Section 
;    2. Stack Section 
;    3. Data Section
;    4. Code Section

;   Legends:
;       OAh - Line Feed, creates new line
;       ODh - Carriage Return, sets cursor to the beginning of the line
;
;--------------------------------------------------------------------------------------------------------------------------------

.model small    ; Sets the model to small where it can use 64K of data, this is suffficient
.stack 100h     ; sets stack segment
.data           ; data segment is where we instantiate our DATA or WORDS


;   combine Line Feed and Carriage return to set cursor to the next line 
;   { Messages
    message_title db 'BLITZ BALL', 13, 10
	message_title_1 equ $-message_title
    message_start db 'Press T to Start', 13, 10
	message_start_1 equ $-message_start
    message_choose db 'Press C to choose Level', 13, 10
	message_choose_1 equ $-message_choose
    message_exit db 'Press E to Exit', 13, 10
	message_exit_1 equ $-message_exit 
;   }

;   {   Game Variables

    time_aux db 0 ; variable used when checking if the time has changed
    ;   character coords
    player_x dw 154 ;x = 160, default center position
    player_y dw 100 ;y = 100, default center position
    prev_x dw 160
    prev_y dw 100

    ;   player size
    player_size dw 0Ch  ; size of player = 12
    player_velocity dw 0Dh ; speed is 13
    player_life dw 03h  ; starting hp

    keyPressed DB 0000h

    ;   Top left border spawn, x = 34, y = 45, add 13 on x or y
    enemy1_x dw 24
    enemy1_y dw 35
    enemy1_x_prev dw 24
    enemy1_y_prev dw 35

    enemy2_x dw 284 ; right border x = 284
    enemy2_y dw 48
    enemy2_x_prev dw 284
    enemy2_y_prev dw 284


;   {


    ;   border coordinates
    leftborder_x dw 19
    rightborder_x dw 298
    verticalborder_y dw 30
    topborder_y dw 30
    bottomborder_y dw 179
    horizontalborder_x dw 19

    ;   border size
    verticalborder_width dw 03;
    horizontalborder_width dw 280;
    verticalborder_height dw 152; 
    horizontalborder_height dw 03;

.code   ;   Code Segment where we write our main program

Main PROC near  ;   PROC means Procedure (or Function)
    mov ax, @data
    mov ds, ax          ;
    mov es, ax  

    Menu:
    mov ax, 0013h
    int 10h
    mov ah, 0Bh
    mov bx, 0000h
    int 10h

    
    call menu_drawTopBorder
    call menu_drawBottomBorder

    ; Display Title
    mov dh, 05    ;y
    mov dl, 14    ;x
    mov bl, 09h   ;color
    mov cx, message_title_1 ;msg length
    lea bp, message_title   ;msg
    mov ax, 1301h   
    mov bh, 00h   ;page
    int 10h

    ; Start Prompt
    mov dh, 14    ;y
    mov dl, 11    ;x
    mov bl, 02h   ;color
    mov cx, message_start_1 ;msg length
    lea bp, message_start  ;msg
    mov ax, 1301h   
    mov bh, 00h   ;page
    int 10h

    ; Choose Level Prompt
    mov dh, 16    ;y
    mov dl, 08    ;x
    mov bl, 0Ch   ;color
    mov cx, message_choose_1 ;msg length
    lea bp, message_choose   ;msg
    mov ax, 1301h   
    mov bh, 00h   ;page
    int 10h

    ; Exit Prompt
    mov dh, 18    ;y
    mov dl, 11    ;x
    mov bl, 0Dh   ;color
    mov cx, message_exit_1 ;msg length
    lea bp, message_exit   ;msg
    mov ax, 1301h   
    mov bh, 00h   ;page
    int 10h
   
    wait_input:
    mov ah, 01h         
    int 16h             
    jz wait_input       
    mov ah, 00h        
    int 16h             
    cmp al, 'T'
    je start_game
    cmp al, 't'
    je start_game
    cmp al, 'E'
    je wait_input
    cmp al, 'e'
    je wait_input
    cmp al, 'C'
    je wait_input
    cmp al, 'c'
    je wait_input

    jmp wait_input      ; Jump back to wait_input if any other character is pressed

    Start_Game:
    call clear_screen   ; refreshes the screen
    call drawBorder
    call drawPlayer
    
    call draw_enemy2

    Check_Time:
        mov ah, 2Ch ; Set configuration for getting time
        int 21h ; CH = hour, CL = minute, DH = second, DL = 1/100 seconds
        cmp dl, time_aux
        JE Check_Time
        mov time_aux, dl    ;   update time

        call draw_enemy1
        inc enemy1_x

        call move_player

        ;Compare AX to 0, if player_life is 0, stop
        mov ax, player_life
        cmp ax, 0
        JZ Stop

        JMP Check_Time

Stop:
    call exit
    ret

Main endp                                           ;   endp is End Procedure (End Function)
; ------------------------------------------------------------------------------
;   End of Main Function
; ------------------------------------------------------------------------------

printLine proc
	mov ah, 09
    int 21h
    ret
    ret 
printLine endp

setcur proc near
    mov ah, 02
    mov bh, 00
    int 10h
    ret
setcur endp

draw_enemy1 proc near
    mov cx, enemy1_x ; CX = X, set initial x coordinates 
    mov dx, enemy1_y ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_Enemy1_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                000000000
        mov al, 0Ch ;color light red                                000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, enemy1_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Draw_Enemy1_Horizontal  ; (ax != player_size)
        mov cx, enemy1_x
        inc dx
        mov ax, dx
        sub ax, enemy1_y
        cmp ax, player_size
        jne Draw_Enemy1_Horizontal        
    ret
    ret
draw_enemy1 endp

move_enemy1 proc near
    mov ax, enemy1_x
    mov enemy1_x_prev, ax

    inc enemy1_x
    call draw_enemy1
    call erase_enemy1

move_enemy1 endp

erase_enemy1 proc near 
    mov cx, enemy1_x_prev ; CX = X, set initial x coordinates 
    mov dx, enemy1_y ; DX = Y, set initial y coordinates
    
    ;mov prev_x

    Erase_Enemy1_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 00h ;color black
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, enemy1_x_prev
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Erase_Enemy1_Horizontal  ; !(ax > player_size)
        mov cx, enemy1_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy1_y
        cmp ax, player_size
        jne Erase_Enemy1_Horizontal        
    ret
erase_enemy1 endp


draw_enemy2 proc near
    mov cx, enemy2_x ; CX = X, set initial x coordinates 
    mov dx, enemy2_y ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_Enemy2_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                     000000000
        mov al, 0Ch ;color light blue                                    000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, enemy2_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Draw_Enemy2_Horizontal  ; (ax != player_size)
        mov cx, enemy2_x
        inc dx
        mov ax, dx
        sub ax, enemy2_y
        cmp ax, player_size
        jne Draw_Enemy2_Horizontal        
    ret
    ret
draw_enemy2 endp

;   For moving the pixel
drawPlayer proc near
    mov cx, player_x ; CX = X, set initial x coordinates 
    mov dx, player_y ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_Player_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                000000000
        mov al, 0Fh ;color white                                    000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, player_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Draw_Player_Horizontal  ; (ax != player_size)
        mov cx, player_x
        inc dx
        mov ax, dx
        sub ax, player_y
        cmp ax, player_size
        jne Draw_Player_Horizontal        
    ret
drawPlayer endp

move_player proc near
    mov ax, player_x
    mov prev_x, ax
    mov ax, player_y
    mov prev_y, ax

    ;   check if any key is being pressed (if not exit procedure)
    mov ah, 01h             ;   if no key is pressed, ZF is 0
    int 16h
    JZ stop_move

    ;   check if which key is being pressed
    mov ah, 00h
    int 16h

    ;   if 'W' or 'w' move up
    cmp al, 77h ; 'w'
    JE Move_Player_Up
    cmp al, 57h ; 'W'
    JE Move_Player_Up

    ;   if 'S' or 's' move down
    cmp al, 73h ; 's'
    JE Move_Player_Down
    cmp al, 53h ; 'S'
    JE Move_Player_Down

    ;   if 'A' or 'a' move left
    cmp al, 61h ; 'a'
    JE Move_Player_Left
    cmp al, 41h ; 'A'
    JE Move_Player_Left

    ;   if 'D' or 'd' move right
    cmp al, 64h ; 'd'
    JE Move_Player_Right
    cmp al, 44h ; 'D'
    JE Move_Player_Right

    ;   if a character is not WASD, JUMP to EXIT
       JMP stop_move


    Move_Player_Up:
        mov ax, player_velocity
        cmp player_y, 35
        je check_collision
        sub player_y, ax
        jmp move_next

    Move_Player_Down:
        mov ax, player_velocity
        cmp player_y, 165
        je check_collision
        add player_y, ax
        jmp move_next

    Move_Player_Left:
        mov ax, player_velocity
        cmp player_x, 24
        je check_collision
        SUB player_x, ax
        jmp move_next

    Move_Player_Right:
        mov ax, player_velocity
        cmp player_x, 284
        je check_collision
        add player_x, ax
        jmp move_next
		
    check_collision:
        call border_collision

    
    move_next:
        call drawPlayer
        call erasePlayer

    stop_move:
        
        ;   mov ax, 
        ret

move_player endp

erasePlayer proc near
    mov cx, prev_x ; CX = X, set initial x coordinates 
    mov dx, prev_y ; DX = Y, set initial y coordinates
    
    ;mov prev_x

    Erase_Player_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 00h ;color black
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, prev_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Erase_Player_Horizontal  ; !(ax > player_size)
        mov cx, prev_x
        inc dx
        mov ax, dx
        sub ax, prev_y
        cmp ax, player_size
        jne Erase_Player_Horizontal        
    ret
erasePlayer endp
    
;  Exit Game
exit proc near                
    mov ah, 4ch
    int 21h
    ret
exit endp                                            ;   exit the function

clear_screen proc near
    ;   Set the video mode to 320x200 - mode 13h
    mov ah, 00h ; set configuration for video mode
    mov al, 13h ; set the size of video
    int 10h 

    ;   Set background to any color 
    mov ah, 0bh ; set configuration
    mov bh, 00h 
    mov bl, 00h 
    int 10h 
    ret
clear_screen endp

drawLeftBorder proc near
    mov cx, leftborder_x    ; CX = X, set initial x coordinates 
    mov dx, verticalborder_y    ; DX = Y, set initial y coordinates

    ;mov prev_x

    Draw_LeftBorder_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 02h ;color white
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, leftborder_x
        cmp ax, verticalborder_width     ;  ZF is -7 on first run 
        JNE Draw_LeftBorder_Horizontal  ; !(ax > player_size)
        mov cx, leftborder_x
        inc dx
        mov ax, dx
        sub ax, verticalborder_y
        cmp ax, verticalborder_height
        jne Draw_LeftBorder_Horizontal        
    ret
drawLeftBorder endp
drawRightBorder proc near
    mov cx, rightborder_x    ; CX = X, set initial x coordinates 
    mov dx, verticalborder_y    ; DX = Y, set initial y coordinates

    ;mov prev_x

    Draw_RightBorder_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 02h ;color white
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, rightborder_x
        cmp ax, verticalborder_width     ;  ZF is -7 on first run 
        JNE Draw_RightBorder_Horizontal  ; !(ax > player_size)
        mov cx, rightborder_x
        inc dx
        mov ax, dx
        sub ax, verticalborder_y
        cmp ax, verticalborder_height
        jne Draw_RightBorder_Horizontal        
    ret
drawRightBorder endp
drawTopBorder proc near
    mov cx, horizontalborder_x    ; CX = X, set initial x coordinates 
    mov dx, topborder_y           ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_TopBorder_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 02h ;color 
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, horizontalborder_x
        cmp ax, horizontalborder_width   ;  ZF is -7 on first run 
        JNE Draw_TopBorder_Horizontal  ; !(ax > player_size)
        mov cx, horizontalborder_x
        inc dx
        mov ax, dx
        sub ax, topborder_y
        cmp ax, horizontalborder_height
        jne Draw_TopBorder_Horizontal        
    ret
drawTopBorder endp
drawBottomBorder proc near
    mov cx, horizontalborder_x    ; CX = X, set initial x coordinates 
    mov dx, bottomborder_y           ; DX = Y, set initial y coordinates
    ;mov prev_x

Draw_BottomBorder_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 02h ;color 
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, horizontalborder_x
        cmp ax, horizontalborder_width   ;  ZF is -7 on first run 
        JNE Draw_BottomBorder_Horizontal  ; !(ax > player_size)
        mov cx, horizontalborder_x
        inc dx
        mov ax, dx
        sub ax, bottomborder_y
        cmp ax, horizontalborder_height
        jne Draw_BottomBorder_Horizontal        
    ret
drawBottomBorder endp
drawBorder proc near
    call DrawBottomBorder
    call DrawLeftBorder
    call DrawRightBorder
    call DrawTopBorder
    ret
drawBorder endp

menu_drawTopBorder proc
    mov cx, 0       ; CX = X, set initial x coordinates 
    mov dx, 15      ; DX = Y, set initial y coordinates
    ;mov prev_x

    menu_Draw_TopBorder_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 0Ah ;color
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, 0
        cmp ax, 320   ;  ZF is -7 on first run 
        JNE menu_Draw_TopBorder_Horizontal  ; !(ax > player_size)
        mov cx, 0
        inc dx
        mov ax, dx
        sub ax, 15
        cmp ax, 3
        jne menu_Draw_TopBorder_Horizontal        
    ret
menu_drawTopBorder endp

menu_drawBottomBorder proc
    mov cx, 0        ; CX = X, set initial x coordinates 
    mov dx, 185      ; DX = Y, set initial y coordinates
    ;mov prev_x

    menu_Draw_BottomBorder_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 0Ah ;color white
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, 0
        cmp ax, 320   ;  ZF is -7 on first run 
        JNE menu_Draw_BottomBorder_Horizontal  ; !(ax > player_size)
        mov cx, 0
        inc dx
        mov ax, dx
        sub ax, 185
        cmp ax, 3
        jne menu_Draw_BottomBorder_Horizontal        
    ret
menu_drawBottomBorder endp

border_collision proc near
    mov player_y, 100
    mov player_x, 154
    ret
border_collision endp

end Main                                             ;   End the main function