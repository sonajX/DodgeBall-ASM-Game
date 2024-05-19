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
    message_title db 'Blitz Ball', 13, 10, '$'
    message_start db 'Press T to start', 13, 10, '$'
    message_choose db 'Press C to choose level', 13, 10, '$'
    message_exit db 'Press E to exit', 13, 10, '$'   
;   }

;   {   Game Variables

    time_aux db 0 ; variable used when checking if the time has changed
    ;   character coords
    player_x dw 160 ;x = 160, default center position
    player_y dw 100 ;y = 100, default center position
    prev_x dw 160
    prev_y dw 100

    ;   player size
    player_size dw 0Ch  ; size of player = 12
    player_velocity dw 0Dh ; speed is 13
    player_life dw 03h  ; starting hp

    keyPressed DB 0000h

    enemy1_x dw 0
    enemy1_y dw 0
;   {

        ; border coordinates
    leftborder_x dw 10
    rightborder_x dw 307
    verticalborder_y dw 30
    topborder_y dw 30
    bottomborder_y dw 190
    horizontalborder_x dw 10

    ; border size
    verticalborder_width dw 03;
    horizontalborder_width dw 297;
    verticalborder_height dw 163; 
    horizontalborder_height dw 03;

.code   ;   Code Segment where we write our main program

Main PROC near  ;   PROC means Procedure (or Function)
    mov ax, @data
    mov ds, ax
    call clear_screen   ; refreshes the screen

    ;   Display Message
    
        lea dx, message_title
        call printLine
        call drawBorder

    Check_Time:
        mov ah, 2Ch ; Set configuration for getting time
        int 21h ; CH = hour, CL = minute, DH = second, DL = 1/100 seconds
        cmp dh, time_aux
        JE Check_Time
        mov time_aux, dl    ;   update time
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
printLine proc near
	mov ah, 09
	int 21h
    ret
printLine endp

move_player proc near
    call erasePlayer
    call movePlayer ;if player movement is detected, inc or dec coords
    call drawPlayer
    ret
move_player endp

;   For moving the pixel
drawPlayer proc near
    mov cx, player_x ; CX = X, set initial x coordinates 
    mov dx, player_y ; DX = Y, set initial y coordinates
    ;mov prev_x

    Draw_Player_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 0Fh ;color white
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, player_x
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Draw_Player_Horizontal  ; !(ax > player_size)
        mov cx, player_x
        inc dx
        mov ax, dx
        sub ax, player_y
        cmp ax, player_size
        jne Draw_Player_Horizontal        
    ret
drawPlayer endp

movePlayer proc near
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
        sub player_y, ax
        jmp stop_move

    Move_Player_Down:
        mov ax, player_velocity
        add player_y, ax
        jmp stop_move

    Move_Player_Left:
        mov ax, player_velocity
        SUB player_x, ax
        jmp stop_move

    Move_Player_Right:
        mov ax, player_velocity
        add player_x, ax
        jmp stop_move

    stop_move:
        ;   mov ax, 
        ret

movePlayer endp

erasePlayer proc near
    mov cx, prev_x ; CX = X, set initial x coordinates 
    mov dx, prev_y ; DX = Y, set initial y coordinates
    
    ;mov prev_x

    Erase_Player_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 00h ;color blue
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
;   Clear Screen
    
cls proc near
	mov ax, 0600h
	mov bh, 07
	mov cx, 0000
	mov dx, 184fh
	int 10h
	ret
cls endp

;   Exit Game
exit proc near                
    mov ah, 4ch
    int 21h
    ret
exit endp                                            ;   exit the function

clear_screen proc near
    ;   Set the video mode to 320x200 - mode 13h
    mov ah, 00h 
    mov al, 13h 
    int 10h 

    ;   Set background to any color 
    mov ah, 0bh
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
        mov al, 02h ;color white
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
        mov al, 02h ;color white
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
    call DrawTopBordeR
    ret
drawBorder endp

end Main                                             ;   End the main function