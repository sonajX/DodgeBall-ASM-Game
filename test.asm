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
    message_life db 'Lives: ', 13, 10
    message_life_1 equ $-message_life
    message_score db 'Score: 000', 13, 10
    message_score_1 equ $-message_score
    message_time db 'Time: 60s', 13, 10
    message_time_1 equ $-message_time
    message_quit db 'Exit[E]', 13, 10
    message_quit_1 equ $-message_quit
;   }

;   {   Game Variables

    time_aux db 0 ; variable used when checking if the time has changed
    ;   character coords
    player_x dw 152 ;x = 160, default center position
    player_y dw 92 ;y = 100, default center position
    prev_x dw 152
    prev_y dw 192

    ;   player size
    player_size dw 0Fh  ; size of player = 15

    player_velocity dw 16 ; speed is 16

    player_life dw 03h  ; starting hp

    keyPressed DB 0000h

    ;   Top left border spawn, x = 34, y = 45, add 13 on x or y
    life1_x dw 75
    life1_y dw 184
    life2_x dw 87
    life2_y dw 184
    life3_x dw 99
    life3_y dw 184

    ; Left enemies
    enemy1_x dw 24
    enemy1_y dw 44
    enemy1_x_prev dw 24
    enemy1_y_prev dw 44

    enemy3_x dw 24
    enemy3_y dw 76
    enemy3_x_prev dw 24
    enemy3_y_prev dw 76

    enemy5_x dw 24
    enemy5_y dw 108
    enemy5_x_prev dw 24
    enemy5_y_prev dw 108

    enemy7_x dw 24
    enemy7_y dw 140
    enemy7_x_prev dw 24
    enemy7_y_prev dw 140

    ; Right enemies

    enemy2_x dw 280 ; right border x = 280
    enemy2_y dw 60
    enemy2_x_prev dw 280
    enemy2_y_prev dw 60

    enemy4_x dw 280 ; right border x = 280
    enemy4_y dw 92
    enemy4_x_prev dw 284
    enemy4_y_prev dw 92

    enemy6_x dw 280 ; right border x = 280
    enemy6_y dw 124
    enemy6_x_prev dw 284
    enemy6_y_prev dw 124

    enemy8_x dw 280 ; right border x = 280
    enemy8_y dw 156
    enemy8_x_prev dw 284
    enemy8_y_prev dw 156


;   {


    ;   border coordinates
    leftborder_x dw 19
    rightborder_x dw 297
    verticalborder_y dw 39
    topborder_y dw 39
    bottomborder_y dw 173
    horizontalborder_x dw 19

    ;   border size
    verticalborder_width dw 03;
    horizontalborder_width dw 280;
    verticalborder_height dw 137; 
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
    mov dh, 06    ;y
    mov dl, 14    ;x
    mov bx, 0009h   ;page + color
    mov cx, message_title_1 ;msg length
    lea bp, message_title   ;msg
    mov ax, 1301h   
    int 10h

    ; Start Prompt
    mov dh, 14    ;y
    mov dl, 11    ;x
    mov bl, 0002h   ;page + color
    mov cx, message_start_1 ;msg length
    lea bp, message_start  ;msg
    mov ax, 1301h
    int 10h

    ; Choose Level Prompt
    mov dh, 16    ;y
    mov dl, 08    ;x
    mov bx, 000Ch   ;page + color
    mov cx, message_choose_1 ;msg length
    lea bp, message_choose   ;msg
    mov ax, 1301h   
    int 10h

    ; Exit Prompt
    mov dh, 18    ;y
    mov dl, 11    ;x
    mov bx, 00Dh   ;page+color
    mov cx, message_exit_1 ;msg length
    lea bp, message_exit   ;msg
    mov ax, 1301h   
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

    ; Display Score
    mov dh, 03     ;y
    mov dl, 03     ;x
    mov bx, 000Bh ;page+color
    mov cx, message_score_1 ;msg length
    lea bp, message_score   ;msg
    mov ax, 1301h   
    int 10h
    ; Display Time
    mov dh, 03     ;y
    mov dl, 28     ;x
    mov bx, 000Bh ;page+color
    mov cx, message_time_1 ;msg length
    lea bp, message_time   ;msg
    mov ax, 1301h   
    int 10h
    ; Display Hearts
    mov dh, 23     ;y
    mov dl, 03     ;x
    mov bx, 000Dh ;page+color
    mov cx, message_life_1 ;msg length
    lea bp, message_life   ;msg
    mov ax, 1301h   
    int 10h
    mov cx, 00 ; CX = X, set initial x coordinates 
    mov dx, 00 ; DX = Y, set initial y coordinates
    call draw_life1
    call draw_life2
    call draw_life3
    ; Display Exit Prompt
    mov dh, 23     ;y
    mov dl, 30     ;x
    mov bx, 000Ch ;page+color
    mov cx, message_quit_1 ;msg length
    lea bp, message_quit   ;msg
    mov ax, 1301h   
    int 10h
    
    call drawBorder
    call drawPlayer    ; drawPlayer at center
    
    call draw_enemy1
    call draw_enemy2
    ;call draw_enemy3
    ;call draw_enemy4
    ;call draw_enemy5
    ;call draw_enemy6
    ;call draw_enemy7
    ;call draw_enemy8

    Check_Time:
        mov ah, 2Ch ; Set configuration for getting time
        int 21h ; CH = hour, CL = minute, DH = second, DL = 1/100 seconds
        cmp dl, time_aux
        JE Check_Time
        mov time_aux, dl    ;   update time

        call move_player
        call move_enemy1      

        JMP Check_Time

Stop:
    call exit
    ret
Main endp                                           ;   endp is End Procedure (End Function)
; ------------------------------------------------------------------------------
;   End of Main Function
; ------------------------------------------------------------------------------

draw_life1 proc near
        mov cx, life1_x ; CX = X, set initial x coordinates 
        mov dx, life1_y ; DX = Y, set initial y coordinates

    Draw_Life1_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                000000000
        mov al, 0Ch ;color                               000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, life1_x ; x
        cmp ax, 8     ;  ZF is -7 on first run 
        JNE Draw_Life1_Horizontal  ; (ax != player_size)
        mov cx, life1_x ; x
        inc dx
        mov ax, dx
        sub ax, life1_y ; y
        cmp ax, 8
        jne Draw_Life1_Horizontal        
    ret
draw_life1 endp
draw_life2 proc near
        mov cx, life2_x ; CX = X, set initial x coordinates 
        mov dx, life2_y ; DX = Y, set initial y coordinates
        
    Draw_Life2_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                000000000
        mov al, 0Ch ;color light red                                000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, life2_x ; x
        cmp ax, 8      ;  ZF is -7 on first run 
        JNE Draw_Life2_Horizontal  ; (ax != player_size)
        mov cx, life2_x ; x
        inc dx
        mov ax, dx
        sub ax, life2_y ; y
        cmp ax, 8
        jne Draw_Life2_Horizontal        
    ret
draw_life2 endp
draw_life3 proc near
        mov cx, life3_x ; CX = X, set initial x coordinates 
        mov dx, life3_y ; DX = Y, set initial y coordinates
        
    Draw_Life3_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                000000000
        mov al, 0Ch ;color light red                                000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, life3_x ; x
        cmp ax, 8    ;  ZF is -7 on first run 
        JNE Draw_Life3_Horizontal  ; (ax != player_size)
        mov cx, life3_x ; x
        inc dx
        mov ax, dx
        sub ax, life3_y ; y
        cmp ax, 8
        jne Draw_Life3_Horizontal        
    ret
draw_life3 endp

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
draw_enemy1 endp
erase_enemy1 proc near 
    mov cx, enemy1_x_prev ; CX = X, set initial x coordinates 
    mov dx, enemy1_y ; DX = Y, set initial y coordinates

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
move_enemy1 proc near
    call draw_enemy1
    mov ax, enemy1_x
    mov enemy1_x_prev, ax
    call erase_enemy1
    add enemy1_x, 4
    call draw_enemy1
    ret
move_enemy1 endp

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

draw_enemy3 proc near
    mov cx, enemy3_x ; CX = X, set initial x coordinates 
    mov dx, enemy3_y ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_Enemy3_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                     000000000
        mov al, 0Ch ;color light blue                                    000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, enemy3_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Draw_Enemy3_Horizontal  ; (ax != player_size)
        mov cx, enemy3_x
        inc dx
        mov ax, dx
        sub ax, enemy3_y
        cmp ax, player_size
        jne Draw_Enemy3_Horizontal        
    ret
    ret
draw_enemy3 endp

draw_enemy4 proc near
    mov cx, enemy4_x ; CX = X, set initial x coordinates 
    mov dx, enemy4_y ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_enemy4_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                     000000000
        mov al, 0Ch ;color light blue                                    000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, enemy2_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Draw_enemy4_Horizontal  ; (ax != player_size)
        mov cx, enemy4_x
        inc dx
        mov ax, dx
        sub ax, enemy4_y
        cmp ax, player_size
        jne Draw_enemy4_Horizontal        
    ret
    ret
draw_enemy4 endp

draw_enemy5 proc near
    mov cx, enemy5_x ; CX = X, set initial x coordinates 
    mov dx, enemy5_y ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_enemy5_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                     000000000
        mov al, 0Ch ;color light blue                                    000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, enemy5_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Draw_enemy5_Horizontal  ; (ax != player_size)
        mov cx, enemy5_x
        inc dx
        mov ax, dx
        sub ax, enemy5_y
        cmp ax, player_size
        jne Draw_enemy5_Horizontal        
    ret
    ret
draw_enemy5 endp

draw_enemy6 proc near
    mov cx, enemy6_x ; CX = X, set initial x coordinates 
    mov dx, enemy6_y ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_enemy6_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                     000000000
        mov al, 0Ch ;color light blue                                    000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, enemy6_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Draw_enemy6_Horizontal  ; (ax != player_size)
        mov cx, enemy6_x
        inc dx
        mov ax, dx
        sub ax, enemy6_y
        cmp ax, player_size
        jne Draw_enemy6_Horizontal        
    ret
    ret
draw_enemy6 endp
draw_enemy7 proc near
    mov cx, enemy7_x ; CX = X, set initial x coordinates 
    mov dx, enemy7_y ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_enemy7_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                     000000000
        mov al, 0Ch ;color light blue                                    000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, enemy7_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Draw_enemy7_Horizontal  ; (ax != player_size)
        mov cx, enemy7_x
        inc dx
        mov ax, dx
        sub ax, enemy7_y
        cmp ax, player_size
        jne Draw_enemy7_Horizontal        
    ret
    ret
draw_enemy7 endp
draw_enemy8 proc near
    mov cx, enemy8_x ; CX = X, set initial x coordinates 
    mov dx, enemy8_y ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_enemy8_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                     000000000
        mov al, 0Ch ;color light blue                                    000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, enemy8_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Draw_enemy8_Horizontal  ; (ax != player_size)
        mov cx, enemy8_x
        inc dx
        mov ax, dx
        sub ax, enemy8_y
        cmp ax, player_size
        jne Draw_enemy8_Horizontal        
    ret
    ret
draw_enemy8 endp

;   For moving the pixel
drawPlayer proc near
    mov cx, player_x ; CX = X, set initial x coordinates, 0
    mov dx, player_y ; DX = Y, set initial y coordinates, 0
    ;mov prev_x

    Draw_Player_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 0Fh ;color white                                   
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; 
        mov ax, cx
        sub ax, player_x
        cmp ax, player_size 
        JNE Draw_Player_Horizontal
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

    ;   if 'E' or 'e' exit program
    cmp al, 65h ; 'e'
    JE exit
    cmp al, 45h ; 'E'
    JE exit

    ;   if a character is not WASD, JUMP to EXIT
       JMP stop_move


    Move_Player_Up:
        mov ax, player_velocity
        cmp player_y, 44
        je check_collision
        sub player_y, ax
        jmp move_next

    Move_Player_Down:
        mov ax, player_velocity
        cmp player_y, 156
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
        cmp player_x, 280
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

exit proc near                
    mov ah, 4ch ;  Exit Game
    int 21h
    ret
exit endp  

erasePlayer proc near
    mov cx, prev_x ; CX = X, set initial x coordinates 
    mov dx, prev_y ; DX = Y, set initial y coordinates
    
    ;mov prev_x

    Erase_Player_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 01h ;color black
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
                                        ;   exit the function
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
        JNE menu_Draw_BottomBorder_Horizontal  ; 
        mov cx, 0
        inc dx
        mov ax, dx
        sub ax, 185
        cmp ax, 3
        jne menu_Draw_BottomBorder_Horizontal        
    ret
menu_drawBottomBorder endp
border_collision proc near
    mov player_y, 92 ; update to reference centered position
    mov player_x, 152
    ret
border_collision endp
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

end Main                                             ;   End the main function