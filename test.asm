;--------------------------------------------------------------------------------------------------------------------------------
;   Goal:   is to create a pixel with player movement using WASD-
;           and create enemies (or projectiles) that ends the game when hit
;   
;   An ASM small program is divided into sections- 
;    1. Model Section 
;    2. Stack Section 
;    3. Data Section
;    4. Code Section
;--------------------------------------------------------------------------------------------------------------------------------
.model small    ; Sets the model to small where it can use 64K of data, this is suffficient
.stack 200h     ; sets stack segment
.data           ; data segment is where we instantiate our DATA or WORDS

;   { Messages
    message_start db 'Press T to Start'
  	message_start_1 equ $-message_start
    message_choose db 'Press C to Choose Level'
  	message_choose_1 equ $-message_choose
    message_info db 'Press U for More Info'
    message_info_1 equ $-message_info
    message_leaderboard db "Press L for Leaderboard"
    message_leaderboard_1 equ $-message_leaderboard
    message_exit db 'Press E to Exit Game'
	message_exit_1 equ $-message_exit
    message_life db 'Lives: '
    message_life_1 equ $-message_life
    message_score db 'Score:'
    message_score_1 equ $-message_score
    message_time db 'Time: '
    message_time_1 equ $-message_time
    message_quit db 'Exit[E]'
    message_quit_1 equ $-message_quit
    message_victory db 'You Win!'
    message_victory_1 equ $-message_victory
    message_name db 'Enter your name: '
    message_name_1 equ $-message_name
    message_save db 'Save to Leaderboard [S] '
    message_save_1 equ $-message_save
    message_retry db 'Try Again [T]'
    message_retry_1 equ $-message_retry
    message_menu db 'Back to Menu [B]'
    message_menu_1 equ $-message_menu
    message_level db 'Choose Level'
    message_level_1 equ $-message_level 
    message_lvlone db '1 - Easy', 13, 10
    message_lvlone_1 equ $-message_lvlone
    message_lvltwo db '2 - Medium', 13, 10
    message_lvltwo_1 equ $-message_lvltwo
    message_lvlthree db '3 - Hard', 13, 10
    message_lvlthree_1 equ $-message_lvlthree
;   { 

    
;    { Game Variables
    game_level dw 0      ;   Change after level selector have been implemented
    time_aux db 0           ; To Check if the time has changed
    time_tix dw 0           ; Use as variable for tick speed
    time_enemy_speed dw 0   
    time_seconds dw 63
    ones dw 33h
    ones_1 equ $-ones
    tens dw 36h  
    tens_1 equ $-tens
    score_ones dw 30h
    score_ones_1 equ $-score_ones
    score_tens dw 30h
    score_tens_1 equ $-score_tens
    score_hund dw 30h
    score_hund_1 equ $-score_hund

    
    ;   character coords
    player_x dw 152 ;x = 160, default center position
    player_y dw 92 ;y = 100, default center position
    enemy_tick_speed dw 2  ;   enemy speed per tick
    prev_x dw 152
    prev_y dw 92

    
    keyPressed DB 0000h

    ;   Top left border spawn, x = 34, y = 45, add 13 on x or y
    life1_x dw 75
    life1_y dw 184
    life2_x dw 98
    life2_y dw 184
    life3_x dw 121
    life3_y dw 184
    life_width dw 19
    life_height dw 9

    ; Left enemies
    enemy1_x dw 08
    enemy1_y dw 44
    enemy1_x_prev dw 24

    enemy2_x dw 08
    enemy2_y dw 60
    enemy2_x_prev dw 24

    enemy3_x dw 08
    enemy3_y dw 76
    enemy3_x_prev dw 24

    enemy4_x dw 08
    enemy4_y dw 92
    enemy4_x_prev dw 24

    enemy5_x dw 08
    enemy5_y dw 108
    enemy5_x_prev dw 24

    enemy6_x dw 08
    enemy6_y dw 124
    enemy6_x_prev dw 24

    enemy7_x dw 08
    enemy7_y dw 140
    enemy7_x_prev dw 24

    enemy8_x dw 08
    enemy8_y dw 156
    enemy8_x_prev dw 24


    ; Right enemies
    enemy9_x dw 296
    enemy9_y dw 44
    enemy9_x_prev dw 280

    enemy10_x dw 296
    enemy10_y dw 60
    enemy10_x_prev dw 280

    enemy11_x dw 296
    enemy11_y dw 76
    enemy11_x_prev dw 280

    enemy12_x dw 296
    enemy12_y dw 92
    enemy12_x_prev dw 280

    enemy13_x dw 296
    enemy13_y dw 108
    enemy13_x_prev dw 280

    enemy14_x dw 296
    enemy14_y dw 124
    enemy14_x_prev dw 280

    enemy15_x dw 296
    enemy15_y dw 140
    enemy15_x_prev dw 280

    enemy16_x dw 296
    enemy16_y dw 156
    enemy16_x_prev dw 280

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

    playerRight_color_pattern db 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
                        db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h
                        db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h
                        db 00h,0Eh,0Eh,0Eh,0Eh,06h,06h,06h,06h,0Eh,0Eh,06h,06h,0Eh,00h
                        db 00h,0Eh,0Eh,0Eh,06h,06h,06h,06h,06h,0Eh,06h,06h,06h,0Eh,00h
                        db 00h,0Eh,0Eh,06h,06h,06h,06h,00h,06h,06h,06h,00h,06h,06h,00h
                        db 00h,0Eh,0Eh,06h,06h,0Dh,0Dh,00h,06h,06h,06h,00h,0Dh,0Dh,00h
                        db 00h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,00h
                        db 04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,00h
                        db 04h,04h,08h,08h,08h,08h,07h,07h,07h,07h,07h,07h,08h,08h,00h
                        db 04h,08h,08h,08h,08h,08h,08h,07h,07h,07h,07h,08h,08h,08h,00h
                        db 00h,08h,08h,08h,08h,08h,08h,08h,07h,07h,08h,08h,08h,08h,00h
                        db 00h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,00h
                        db 00h,00h,01h,01h,01h,01h,00h,00h,00h,01h,01h,01h,01h,00h,00h
                        db 00h,00h,01h,01h,01h,01h,01h,00h,00h,01h,01h,01h,01h,01h,00h

    playerLeft_color_pattern db 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
                        db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h
                        db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h
                        db 00h,0Eh,06h,06h,0Eh,0Eh,06h,06h,06h,0Eh,0Eh,0Eh,0Eh,0Eh,00h
                        db 00h,0Eh,06h,06h,06h,0Eh,06h,06h,06h,06h,06h,0Eh,0Eh,0Eh,00h
                        db 00h,06h,06h,00h,06h,06h,06h,00h,06h,06h,06h,06h,0Eh,0Eh,00h
                        db 00h,0Dh,0Dh,00h,06h,06h,06h,00h,0Dh,0Dh,06h,06h,0Eh,0Eh,00h
                        db 00h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,00h
                        db 00h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h
                        db 00h,08h,08h,07h,07h,07h,07h,07h,07h,08h,08h,08h,08h,04h,04h
                        db 00h,08h,08h,08h,07h,07h,07h,07h,08h,08h,08h,08h,08h,08h,04h
                        db 00h,08h,08h,08h,08h,07h,07h,08h,08h,08h,08h,08h,08h,08h,00h
                        db 00h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,00h
                        db 00h,00h,00h,01h,01h,01h,01h,00h,00h,01h,01h,01h,01h,00h,00h
                        db 00h,00h,01h,01h,01h,01h,01h,00h,01h,01h,01h,01h,01h,00h,00h

    playerUp_color_pattern db 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
                        db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h
                        db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h
                        db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h
                        db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h
                        db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h
                        db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h
                        db 00h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,00h
                        db 00h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h
                        db 00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,04h,04h
                        db 00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,04h
                        db 00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h
                        db 00h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,00h
                        db 00h,00h,01h,01h,01h,01h,00h,00h,00h,01h,01h,01h,01h,00h,00h
                        db 00h,00h,01h,01h,01h,01h,00h,00h,00h,01h,01h,01h,01h,00h,00h

    life_color_pattern db 00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,00h,00h
                        db 00h,07h,0fh,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,0fh,07h,00h
                        db 07h,0fh,0fh,0fh,07h,00h,00h,04h,04h,00h,04h,04h,00h,00h,07h,0fh,0fh,0fh,07h
                        db 07h,0fh,0fh,0fh,0fh,07h,04h,0fh,04h,04h,04h,04h,04h,07h,0fh,0fh,0fh,0fh,07h
                        db 07h,0fh,0fh,07h,0fh,0fh,04h,04h,04h,04h,04h,04h,04h,0fh,0fh,07h,0fh,0fh,07h
                        db 00h,07h,0fh,0fh,07h,0fh,04h,04h,04h,04h,04h,04h,04h,0fh,07h,0fh,0fh,07h,00h
                        db 00h,00h,07h,0fh,0fh,07h,00h,04h,04h,04h,04h,04h,00h,07h,0fh,0fh,07h,00h,00h
                        db 00h,00h,00h,07h,07h,00h,00h,00h,04h,04h,04h,00h,00h,00h,07h,07h,00h,00h,00h
                        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,04h,00h,00h,00h,00h,00h,00h,00h,00h,00h
                        
    logo_color_pattern_0 db 00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh
      db 00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h
      db 00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h
      db 00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h

    logo_color_pattern_1 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
      db 08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
      db 08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
      db 08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
      db 08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h

    logo_color_pattern_2 db 00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
      db 08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h
      db 0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h
      db 0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h
      db 0fh,0fh,08h,08h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0fh,0fh,08h,08h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 08h,08h,08h,08h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 08h,08h,08h,08h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h
      db 08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h
      db 08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h
      db 08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h

    logo_color_pattern_3 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,08h,08h
      db 00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h
      db 00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h
      db 00h,00h,00h,00h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h
      db 00h,00h,00h,00h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,00h,00h,00h,00h

;   ball patterns
tennis_color_pattern    db 00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h
                        db 00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h
                        db 00h,00h,0Ah,0Fh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Fh,0Ah,00h,00h
                        db 00h,0Ah,0Ah,0Fh,0Fh,0Ah,0Ah,0Ah,0Ah,0Ah,0Fh,0Fh,0Ah,0Ah,00h
                        db 00h,0Ah,0Ah,0Ah,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Ah,0Ah,0Ah,00h
                        db 0Ah,0Ah,0Ah,0Ah,0Ah,0Fh,0Fh,0Fh,0Fh,0Fh,0Ah,0Ah,0Ah,0Ah,0Ah
                        db 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
                        db 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
                        db 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah
                        db 0Ah,0Ah,0Ah,0Ah,0Ah,0Fh,0Fh,0Fh,0Fh,0Fh,0Ah,0Ah,0Ah,0Ah,0Ah
                        db 00h,0Ah,0Ah,0Ah,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Ah,0Ah,00h
                        db 00h,0Ah,0Ah,0Fh,0Fh,0Ah,0Ah,0Ah,0Ah,0Ah,0Fh,0Fh,0Ah,0Ah,00h
                        db 00h,00h,0Ah,0Fh,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Fh,0Ah,00h,00h
                        db 00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h
                        db 00h,00h,00h,00h,00h,0Ah,0Ah,0Ah,0Ah,0Ah,00h,00h,00h,00h,00h

volleyball_color_pattern    db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h
                        db 00h,00h,00h,0Bh,0Bh,08h,08h,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
                        db 00h,00h,0Bh,0Bh,08h,0Eh,0Eh,08h,08h,0Eh,0Eh,0Eh,0Eh,00h,00h
                        db 00h,0Bh,0Bh,08h,08h,0Eh,0Eh,08h,0Bh,08h,0Eh,0Eh,0Eh,0Eh,00h
                        db 00h,0Bh,08h,0Eh,0Eh,0Eh,0Eh,08h,0Bh,0Bh,08h,0Eh,0Eh,0Eh,00h
                        db 0Bh,0Bh,08h,0Eh,0Eh,0Eh,08h,0Bh,0Bh,0Bh,08h,08h,0Eh,0Eh,0Eh
                        db 0Bh,08h,0Eh,0Eh,0Eh,08h,0Bh,0Bh,0Bh,08h,0Bh,08h,0Eh,0Eh,0Eh
                        db 0Bh,08h,0Eh,0Eh,0Eh,08h,0Bh,0Bh,0Bh,08h,0Bh,0Bh,08h,0Eh,0Eh
                        db 0Bh,08h,0Eh,0Eh,08h,0Bh,0Bh,0Bh,08h,08h,0Bh,0Bh,0Bh,08h,08h
                        db 08h,0Eh,0Eh,08h,0Bh,0Bh,0Bh,08h,0Eh,0Eh,08h,0Bh,0Bh,0Bh,0Bh
                        db 00h,0Eh,0Eh,08h,0Bh,0Bh,0Bh,08h,0Eh,0Eh,0Eh,08h,08h,08h,00h
                        db 00h,0Eh,0Eh,08h,0Bh,0Bh,08h,0Bh,08h,0Eh,0Eh,0Eh,0Eh,0Eh,00h
                        db 00h,00h,08h,0Bh,0Bh,0Bh,08h,0Bh,0Bh,08h,08h,08h,0Eh,00h,00h
                        db 00h,00h,00h,0Bh,0Bh,08h,0Eh,08h,0Bh,0Bh,0Bh,0Bh,00h,00h,00h
                        db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,08h,0Bh,00h,00h,00h,00h,00h 
; logo size



    logo_width dw 48
    logo_height dw 46
    ;   logo coordinates
    logo_x dw 65
    logo_y dw 40

    ;   player size
    player_size dw 0Fh  ; size of player = 15
    player_velocity dw 16 ; speed is 16
    player_life dw 03h  ; starting hp
    
    ;   Flag variables for enemy spawn
    enemy1_flag db 0    ;   0 = false, 1 = true
    enemy3_flag db 0    
    enemy2_flag db 0   
    enemy4_flag db 0
    enemy5_flag db 0   
    enemy6_flag db 0    
    enemy7_flag db 0    
    enemy8_flag db 0
    enemy9_flag db 0  
    enemy10_flag db 0  
    enemy11_flag db 0  
    enemy12_flag db 0   
    enemy13_flag db 0   
    enemy14_flag db 0   
    enemy15_flag db 0   
    enemy16_flag db 0   



.code   ;   Code Segment where we write our main program

Main PROC near  ;   PROC means Procedure (or Function)
        mov ax, @data
        mov ds, ax          
        mov es, ax  

    Start: 
        call display_menu
    
    wait_input:
        mov ah, 01h         
        int 16h             
        jz wait_input       
        mov ah, 00h        
        int 16h             
        cmp al, 'T'
        je Levels
        cmp al, 't'
        je Levels
        cmp al, 'E'
        je Stop
        cmp al, 'e'
        je Stop

        jmp wait_input      ; Jump back to wait_input if any other character is pressed
    
    level_resp:
        mov ah, 01h         
        int 16h             
        jz level_resp       
        mov ah, 00h        
        int 16h             
        cmp al, '1'
        je Set_level1
        cmp al, '2'
        je Set_level2
        cmp al, '3'
        je Set_level3
        cmp al, 'B'
        je Back
        cmp al, 'b'
        je Back

        jmp level_resp  ; jump back to level resp if other keys are clicked
    
    Back: 
        call clear_screen
        jmp Start

    Stop:
        call clear_screen
        mov ah, 4ch ;  Set configuration to exit with return
        int 21h
    
    Levels: 
        call clear_screen
        call display_choose_level
        jmp level_resp

    Set_Level1: 
        mov game_level, 1
        jmp Start_Game

    Set_Level2:
        mov game_level, 2
        jmp Start_Game

    Set_Level3:
        mov game_level, 3
        jmp Start_Game

    Start_game:
        call reset_variables
        call display_game_hud
        call drawBorder
        mov si, offset playerRight_color_pattern
        call drawPlayer    ; drawPlayer at center
        
    Check_Time:         ;   infinite tix++ loop, increments tix per cycle
        mov ah, 2Ch         ;   Set configuration for getting time
        int 21h             ;   CH = hour, CL = minute, DH = second, DL = 1/100 seconds
        cmp dl, time_aux
        JE Check_Time       
        mov time_aux, dl    ;   update time
        ;   Start of game ticks below
        call check_enemy_collision_player
        call move_player    ;   Get key press and execute movement, if no key press return early
        
        inc time_tix   ; 0 start   
        inc time_enemy_speed    ; 0 start
        mov bx, enemy_tick_speed
        cmp time_enemy_speed, bx        ;   Enemy moves every 10 tix
        JNE Next_Tix
            
            Check_Level1:
                cmp game_level, 1
                JNE Check_Level2
                    call Move_Level1

            Check_Level2:
                cmp game_level, 2
                JNE Check_Level3
                    call move_level2
            
            Check_Level3:
                cmp game_level, 3
                JNE Check_Exit
                       call move_level3

        Check_Exit:

        mov time_enemy_speed, 0     ;   reset enemy tix speed
        
        Next_Tix:
        cmp time_tix, 20            ;   seconds timer, 20 tix is approx 1 second
        JNE dont_decrement_seconds  ;   every 20 tix, decrement second

        
        call countdown              ; display decrementing countdown
        call display_score          ; display iterating score
        dec time_seconds
        
        mov time_tix, 0             ;   reset tix to 0
    
        dont_decrement_seconds:
        
        JMP Check_Time
    ret
Main endp                   ;   endp is End Procedure (End Function)
; ------------------------------------------------------------------------------
;   End of Main Function
; ------------------------------------------------------------------------------

move_player proc near
    mov ax, player_x
    mov prev_x, ax
    mov ax, player_y
    mov prev_y, ax
    ;   check if any key is being pressed (if not exit procedure)
    mov ah, 01h         ;   Set configuration for key_press, ZF = 0 if no Key Press
    int 16h
    JNZ key_press_detected        ;   if no key is pressed, ZF is 0
    ret     ;   early return if no key press

    key_press_detected:  ;   There is a key press
    
    mov ah, 00h         ;   check if which key is being pressed
    int 16h

    cmp al, 'E'
    JE reset_game
    cmp al, 'e'
    JE reset_game

    JMP Next_Move
    ;   reset variables then call main function again
    reset_game:
        call clear_screen
        call reset_variables
        jmp Start

    Next_Move:
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
    ;   if a character is not WASD, early return to stop the procedure
    ret

    Move_Player_Up:
        mov ax, player_velocity
        cmp player_y, 44
        je check_collision
        sub player_y, ax
        mov si, offset playerUp_color_pattern
        jmp move_next

    Move_Player_Down:
        mov ax, player_velocity
        cmp player_y, 156
        je check_collision
        add player_y, ax
        mov si, offset playerRight_color_pattern
        jmp move_next

    Move_Player_Left:
        mov ax, player_velocity
        cmp player_x, 24
        je check_collision
        SUB player_x, ax
        mov si, offset playerLeft_color_pattern
        jmp move_next

    Move_Player_Right:
        mov ax, player_velocity
        cmp player_x, 280
        je check_collision
        add player_x, ax
        mov si, offset playerRight_color_pattern
        jmp move_next
		
    check_collision:
        call border_collision

    move_next:
        call drawPlayer
        call erasePlayer

    stop_move:
        ret

move_player endp

display_choose_level proc near
    call clear_screen
    mov ax, 1300h           ;   set configuration write string
    mov dh, 05              ;   y
    mov dl, 14              ;   x
    mov bx, 000Fh           ;   bh = page , bl = color
    mov cx, message_level_1 ;   msg length
    lea bp, message_level   ;   msg
    int 10h

    ; level 1 prompt
    mov dh, 13                ;   y
    mov dl, 15                ;   x
    mov bx, 000Ah             ;   bh = page , bl = color
    mov cx, message_lvlone_1  ;   msg length
    lea bp, message_lvlone    ;   msg
    int 10h

    ; level 2 prompt
    mov dh, 15                ;   y
    mov dl, 15                ;   x
    mov bx, 0009h             ;   bh = page , bl = color
    mov cx, message_lvltwo_1  ;   msg length
    lea bp, message_lvltwo    ;   msg
    int 10h

    ; level 3 prompt
    mov dh, 17                 ;   y
    mov dl, 15                 ;   x
    mov bx, 000Ch              ;   bh = page , bl = color
    mov cx, message_lvlthree_1 ;   msg length
    lea bp, message_lvlthree   ;   msg
    int 10h

    ret
display_choose_level endp

display_game_hud proc near
    call clear_screen   ; refreshes the screen
    ; Display Score
    mov ax, 1300h   ;   set configuration for displaying with graphics
    mov dh, 03     ;y
    mov dl, 03     ;x
    mov bx, 000Bh ;page+color
    mov cx, message_score_1 ;msg length
    lea bp, message_score   ;msg
    int 10h

    mov dh, 3               ; y position
    mov dl, 12              ; x position
    mov bx, 000Dh           ; page+color
    mov cx, 1               ; message length
    lea bp, score_ones      ; message
    int 10h

    mov dh, 3               ; y position
    mov dl, 11              ; x position
    mov bx, 000Dh           ; page+color
    mov cx, 1               ; message length
    lea bp, score_tens      ; message
    int 10h

    mov dh, 3               ; y position
    mov dl, 10              ; x position
    mov bx, 000Dh           ; page+color
    mov cx, 1               ; message length
    lea bp, score_hund      ; message
    int 10h

    ; Display Time
    mov dh, 03     ;y
    mov dl, 28     ;x
    mov bx, 000Bh ;page+color
    mov cx, message_time_1 ;msg length
    lea bp, message_time   ;msg
    mov ax, 1300h   
    int 10h
    mov dh, 03               ;   y
    mov dl, 34               ;   x 
    mov bx, 000Dh           ;   page+color
    mov cx, tens_1  ;   msg length
    lea bp, tens    ;   msg
    int 10h
    mov dh, 3               ;   y
    mov dl, 35              ;   x 
    mov bx, 000Dh           ;   page+color
    mov cx, ones_1  ;   msg length
    lea bp, ones   ;   msg
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
    ret
display_game_hud endp

display_score proc near
    score_check_ones:
    cmp score_ones, '0'
    cmp score_ones, '5'
    je score_check_tens
    add score_ones, 5
    jmp score_print_ones

    score_check_tens:
    cmp score_tens, '9'
    je score_check_hund
    add score_tens, 1
    mov score_ones, '0'
    jmp score_print_tens

    score_check_hund:
    cmp score_hund, '9'
    add score_hund, 1
    mov score_tens, '0'
    mov score_ones, '0'
    jmp score_print_hund

    score_print_ones:
    mov ax, 1300h
    mov dh, 3               ; y position
    mov dl, 12              ; x position
    mov bx, 000Dh           ; page+color
    mov cx, 1               ; message length
    lea bp, score_ones      ; message
    int 10h
    jmp score_stop_timer

    score_print_tens:
    mov ax, 1300h
    mov dh, 3               ; y position
    mov dl, 11              ; x position
    mov bx, 000Dh           ; page+color
    mov cx, 1               ; message length
    lea bp, score_tens      ; message
    int 10h
    jmp score_print_ones

    score_print_hund:
    mov ax, 1300h
    mov dh, 3               ; y position
    mov dl, 10              ; x position
    mov bx, 000Dh           ; page+color
    mov cx, 1               ; message length
    lea bp, score_hund      ; message
    int 10h
    jmp score_print_tens

    score_stop_timer:
    ret
display_score endp

display_menu proc near
    call clear_screen
    call menu_drawTopBorder
    call menu_drawBottomBorder
    call draw_logo

    ; Display Start Prompt
    mov ax, 1300h           ;   set configuration to ah 13h, al 01h
    mov dh, 14              ;   y
    mov dl, 12              ;   x
    mov bx, 000Ah           ;   bh = page , bl = color
    mov cx, message_start_1 ;   msg length
    lea bp, message_start   ;   msg
    int 10h
    
    ; Display Information Prompt
    mov dh, 16              ;   y
    mov dl, 10              ;   x
    mov bx, 0009h           ;   page + color
    mov cx, message_info_1  ;   msg length
    lea bp, message_info    ;   msg 
    int 10h

    ; Display Extras Prompt
    mov dh, 18              ;   y
    mov dl, 09              ;   x
    mov bx, 000Ch           ;   page + color
    mov cx, message_leaderboard_1 ;   msg length
    lea bp, message_leaderboard   ;   msg 
    int 10h

    ; Exit Prompt
    mov dh, 20              ;   y
    mov dl, 10              ;   x
    mov bx, 000Dh           ;   page+color
    mov cx, message_exit_1  ;   msg length
    lea bp, message_exit    ;   msg
    int 10h
    ret
display_menu endp

countdown proc near
    check_ones:
    cmp ones, 30h           ; check if ones is 0 (30 is 0 in hex)
    JE check_tens
    JNE decrement_ones

    check_tens:             ; check if tens is 0 (30 is 0 in hex)
    cmp tens, 30h
    je check_ones
    jne decrement_tens

    decrement_tens:
    mov ones, '9'
    dec tens
    jmp print_tens

    decrement_ones:
    dec ones
    jmp print_ones

    print_tens:
    mov ax, 1300h
    mov dh, 03              ;   y
    mov dl, 34              ;   x 
    mov bx, 000Dh           ;   page+color
    mov cx, tens_1          ;   msg length
    lea bp, tens            ;   msg
    int 10h

    print_ones:
    mov ax, 1300h
    mov dh, 3               ;   y
    mov dl, 35              ;   x 
    mov bx, 000Dh           ;   page+color
    mov cx, ones_1          ;   msg length
    lea bp, ones            ;   msg
    int 10h

    stop_timer:
    ret
countdown endp

draw_logo proc near
    ; Part 1
    mov cx, logo_x                ; CX = X, set initial x coordinates
    mov dx, logo_y                ; DX = Y, set initial y coordinates
    mov si, offset logo_color_pattern_0

    Draw_Logo_Horizontal_0:
        mov ah, 0Ch               ; function 0Ch - write pixel in graphics mode
        mov al, [si]              ; AL = color
        mov bh, 00h               ; BH = page number (disregard)
        int 10h                   ; call BIOS video interrupt
        inc si
        inc cx
        mov ax, cx
        sub ax, logo_x
        cmp ax, logo_width
        jne Draw_Logo_Horizontal_0
        mov cx, logo_x
        inc dx
        mov ax, dx
        sub ax, logo_y
        cmp ax, logo_height
        jne Draw_Logo_Horizontal_0

    ; Part 2
    add cx, 48                    ; Adjust CX to be 48 pixels to the right
    mov dx, logo_y                ; Reset DX to initial y coordinates
    mov si, offset logo_color_pattern_1

    Draw_Logo_Horizontal_1:
        mov ah, 0Ch               ; function 0Ch - write pixel in graphics mode
        mov al, [si]              ; AL = color
        mov bh, 00h               ; BH = page number (disregard)
        int 10h                   ; call BIOS video interrupt
        inc si
        inc cx
        mov ax, cx
        sub ax, logo_x
        sub ax, 48                ; Adjust the subtracted value by 48 pixels
        cmp ax, logo_width
        jne Draw_Logo_Horizontal_1
        mov cx, logo_x
        add cx, 48                ; Adjust CX to be 48 pixels to the right again
        inc dx
        mov ax, dx
        sub ax, logo_y
        cmp ax, logo_height
        jne Draw_Logo_Horizontal_1

    ; Part 3
    add cx, 48                    ; Adjust CX to be 48 pixels to the right
    mov dx, logo_y                ; Reset DX to initial y coordinates
    mov si, offset logo_color_pattern_2

    Draw_Logo_Horizontal_2:
        mov ah, 0Ch               ; function 0Ch - write pixel in graphics mode
        mov al, [si]              ; AL = color
        mov bh, 00h               ; BH = page number (disregard)
        int 10h                   ; call BIOS video interrupt
        inc si
        inc cx
        mov ax, cx
        sub ax, logo_x
        sub ax, 96                ; Adjust the subtracted value by 48 pixels
        cmp ax, logo_width
        jne Draw_Logo_Horizontal_2
        mov cx, logo_x
        add cx, 96                ; Adjust CX to be 48 pixels to the right again
        inc dx
        mov ax, dx
        sub ax, logo_y
        cmp ax, logo_height
        jne Draw_Logo_Horizontal_2
    
    ; Part 4
    add cx, 48                    ; Adjust CX to be 48 pixels to the right
    mov dx, logo_y                ; Reset DX to initial y coordinates
    mov si, offset logo_color_pattern_3

    Draw_Logo_Horizontal_3:
        mov ah, 0Ch               ; function 0Ch - write pixel in graphics mode
        mov al, [si]              ; AL = color
        mov bh, 00h               ; BH = page number (disregard)
        int 10h                   ; call BIOS video interrupt
        inc si
        inc cx
        mov ax, cx
        sub ax, logo_x
        sub ax, 144                ; Adjust the subtracted value by 48 pixels
        cmp ax, logo_width
        jne Draw_Logo_Horizontal_3
        mov cx, logo_x
        add cx, 144                ; Adjust CX to be 48 pixels to the right again
        inc dx
        mov ax, dx
        sub ax, logo_y
        cmp ax, logo_height
        jne Draw_Logo_Horizontal_3

    ret
draw_logo endp

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
draw_life1 proc near
        mov cx, life1_x ; CX = X, set initial x coordinates 
        mov dx, life1_y ; DX = Y, set initial y coordinates
        mov si, offset life_color_pattern

    Draw_Life1_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                000000000
        mov al, [si] ;color                               000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, life1_x ; x
        cmp ax, life_width     ;  ZF is -7 on first run 
        JNE Draw_Life1_Horizontal  ; (ax != player_size)
        mov cx, life1_x ; x
        inc dx
        mov ax, dx
        sub ax, life1_y ; y
        cmp ax, life_height
        jne Draw_Life1_Horizontal        
    ret
draw_life1 endp
draw_life2 proc near
        mov cx, life2_x ; CX = X, set initial x coordinates 
        mov dx, life2_y ; DX = Y, set initial y coordinates
        mov si, offset life_color_pattern
        
    Draw_Life2_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                000000000
        mov al, [si] ;color light red                                000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, life2_x ; x
        cmp ax, life_width      ;  ZF is -7 on first run 
        JNE Draw_Life2_Horizontal  ; (ax != player_size)
        mov cx, life2_x ; x
        inc dx
        mov ax, dx
        sub ax, life2_y ; y
        cmp ax, life_height
        jne Draw_Life2_Horizontal        
    ret
draw_life2 endp
draw_life3 proc near
        mov cx, life3_x ; CX = X, set initial x coordinates 
        mov dx, life3_y ; DX = Y, set initial y coordinateacs
        mov si, offset life_color_pattern

    Draw_Life3_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                000000000
        mov al, [si] ;color light red                                000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, life3_x ; x
        cmp ax, life_width    ;  ZF is -7 on first run 
        JNE Draw_Life3_Horizontal  ; (ax != player_size)
        mov cx, life3_x ; x
        inc dx
        mov ax, dx
        sub ax, life3_y ; y
        cmp ax, life_height
        jne Draw_Life3_Horizontal        
    ret
draw_life3 endp

move_enemy1 proc near
    cmp enemy1_flag, 1
    JE next_move_enemy1
    ret

    next_move_enemy1:

    add enemy1_x, 16
    call erase_enemy1
    cmp enemy1_x, 296
    JE reset_enemy1

    call draw_enemy1
    ret

    reset_enemy1:
    mov enemy1_x, 08
    mov enemy1_x_prev, 24
    mov enemy1_flag, 0
    ret

move_enemy1 endp

draw_enemy1 proc near
    mov cx, enemy1_x ; CX = X, set initial x coordinates 
    mov dx, enemy1_y ; DX = Y, set initial y coordinates
    mov si, offset tennis_color_pattern
    mov enemy1_x_prev, cx
    Draw_Enemy1_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, enemy1_x
        cmp ax, player_size         ;   15
        JNE Draw_Enemy1_Horizontal
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

move_enemy2 proc near
    cmp enemy2_flag, 1
    je next_move_enemy2
    ret

    next_move_enemy2:

    add enemy2_x, 16
    call erase_enemy2
    cmp enemy2_x, 296
    je reset_enemy2

    call draw_enemy2
    ret

    reset_enemy2:
    mov enemy2_x, 08
    mov enemy2_x_prev, 24
    mov enemy2_flag, 0
    ret
move_enemy2 endp

draw_enemy2 proc near
    mov cx, enemy2_x ; CX = X, set initial x coordinates 
    mov dx, enemy2_y ; DX = Y, set initial y coordinates
    mov si, offset volleyball_color_pattern
    mov enemy2_x_prev, cx
    Draw_Enemy2_Horizontal:
        mov ah, 0Ch ; configuration to printing pixel
        mov al, [si] ; color pattern
        mov bh, 00h ; page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy2_x
        cmp ax, player_size ; 15
        jne Draw_Enemy2_Horizontal
        mov cx, enemy2_x
        inc dx
        mov ax, dx
        sub ax, enemy2_y
        cmp ax, player_size
        jne Draw_Enemy2_Horizontal        
    ret
draw_enemy2 endp

erase_enemy2 proc near 
    mov cx, enemy2_x_prev ; CX = X, set initial x coordinates 
    mov dx, enemy2_y ; DX = Y, set initial y coordinates
    Erase_Enemy2_Horizontal:
        mov ah, 0Ch ; configuration to printing pixel
        mov al, 00h ; color black
        mov bh, 00h ; page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx
        mov ax, cx
        sub ax, enemy2_x_prev
        cmp ax, player_size
        jne Erase_Enemy2_Horizontal
        mov cx, enemy2_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy2_y
        cmp ax, player_size
        jne Erase_Enemy2_Horizontal        
    ret
erase_enemy2 endp

move_enemy3 proc near
    cmp enemy3_flag, 1
    je next_move_enemy3
    ret

    next_move_enemy3:

    add enemy3_x, 16
    call erase_enemy3
    cmp enemy3_x, 296
    je reset_enemy3

    call draw_enemy3
    ret

    reset_enemy3:
    mov enemy3_x, 08
    mov enemy3_x_prev, 24
    mov enemy3_flag, 0
    ret
move_enemy3 endp

draw_enemy3 proc near
    mov cx, enemy3_x
    mov dx, enemy3_y
    mov si, offset tennis_color_pattern
    mov enemy3_x_prev, cx
    Draw_Enemy3_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy3_x
        cmp ax, player_size
        jne Draw_Enemy3_Horizontal
        mov cx, enemy3_x
        inc dx
        mov ax, dx
        sub ax, enemy3_y
        cmp ax, player_size
        jne Draw_Enemy3_Horizontal        
    ret
draw_enemy3 endp

erase_enemy3 proc near 
    mov cx, enemy3_x_prev
    mov dx, enemy3_y
    Erase_Enemy3_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy3_x_prev
        cmp ax, player_size
        jne Erase_Enemy3_Horizontal
        mov cx, enemy3_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy3_y
        cmp ax, player_size
        jne Erase_Enemy3_Horizontal        
    ret
erase_enemy3 endp

move_enemy4 proc near
    cmp enemy4_flag, 1
    je next_move_enemy4
    ret

    next_move_enemy4:

    add enemy4_x, 16
    call erase_enemy4
    cmp enemy4_x, 296
    je reset_enemy4

    call draw_enemy4
    ret

    reset_enemy4:
    mov enemy4_x, 08
    mov enemy4_x_prev, 24
    mov enemy4_flag, 0
    ret
move_enemy4 endp

draw_enemy4 proc near
    mov cx, enemy4_x
    mov dx, enemy4_y
    mov si, offset tennis_color_pattern
    mov enemy4_x_prev, cx
    Draw_Enemy4_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy4_x
        cmp ax, player_size
        jne Draw_Enemy4_Horizontal
        mov cx, enemy4_x
        inc dx
        mov ax, dx
        sub ax, enemy4_y
        cmp ax, player_size
        jne Draw_Enemy4_Horizontal        
    ret
draw_enemy4 endp

erase_enemy4 proc near 
    mov cx, enemy4_x_prev
    mov dx, enemy4_y
    Erase_Enemy4_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy4_x_prev
        cmp ax, player_size
        jne Erase_Enemy4_Horizontal
        mov cx, enemy4_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy4_y
        cmp ax, player_size
        jne Erase_Enemy4_Horizontal        
    ret
erase_enemy4 endp

move_enemy5 proc near
    cmp enemy5_flag, 1
    je next_move_enemy5
    ret

    next_move_enemy5:

    add enemy5_x, 16
    call erase_enemy5
    cmp enemy5_x, 296
    je reset_enemy5

    call draw_enemy5
    ret

    reset_enemy5:
    mov enemy5_x, 08
    mov enemy5_x_prev, 24
    mov enemy5_flag, 0
    ret
move_enemy5 endp

draw_enemy5 proc near
    mov cx, enemy5_x
    mov dx, enemy5_y
    mov si, offset tennis_color_pattern
    mov enemy5_x_prev, cx
    Draw_Enemy5_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy5_x
        cmp ax, player_size
        jne Draw_Enemy5_Horizontal
        mov cx, enemy5_x
        inc dx
        mov ax, dx
        sub ax, enemy5_y
        cmp ax, player_size
        jne Draw_Enemy5_Horizontal        
    ret
draw_enemy5 endp

erase_enemy5 proc near 
    mov cx, enemy5_x_prev
    mov dx, enemy5_y
    Erase_Enemy5_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy5_x_prev
        cmp ax, player_size
        jne Erase_Enemy5_Horizontal
        mov cx, enemy5_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy5_y
        cmp ax, player_size
        jne Erase_Enemy5_Horizontal        
    ret
erase_enemy5 endp

move_enemy6 proc near
    cmp enemy6_flag, 1
    je next_move_enemy6
    ret

    next_move_enemy6:

    add enemy6_x, 16
    call erase_enemy6
    cmp enemy6_x, 296
    je reset_enemy6

    call draw_enemy6
    ret

    reset_enemy6:
    mov enemy6_x, 08
    mov enemy6_x_prev, 24
    mov enemy6_flag, 0
    ret
move_enemy6 endp

draw_enemy6 proc near
    mov cx, enemy6_x
    mov dx, enemy6_y
    mov si, offset tennis_color_pattern
    mov enemy6_x_prev, cx
    Draw_Enemy6_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy6_x
        cmp ax, player_size
        jne Draw_Enemy6_Horizontal
        mov cx, enemy6_x
        inc dx
        mov ax, dx
        sub ax, enemy6_y
        cmp ax, player_size
        jne Draw_Enemy6_Horizontal        
    ret
draw_enemy6 endp

erase_enemy6 proc near 
    mov cx, enemy6_x_prev
    mov dx, enemy6_y
    Erase_Enemy6_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy6_x_prev
        cmp ax, player_size
        jne Erase_Enemy6_Horizontal
        mov cx, enemy6_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy6_y
        cmp ax, player_size
        jne Erase_Enemy6_Horizontal        
    ret
erase_enemy6 endp

move_enemy7 proc near
    cmp enemy7_flag, 1
    je next_move_enemy7
    ret

    next_move_enemy7:

    add enemy7_x, 16
    call erase_enemy7
    cmp enemy7_x, 296
    je reset_enemy7

    call draw_enemy7
    ret

    reset_enemy7:
    mov enemy7_x, 08
    mov enemy7_x_prev, 24
    mov enemy7_flag, 0
    ret
move_enemy7 endp

draw_enemy7 proc near
    mov cx, enemy7_x
    mov dx, enemy7_y
    mov si, offset tennis_color_pattern
    mov enemy7_x_prev, cx
    Draw_Enemy7_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy7_x
        cmp ax, player_size
        jne Draw_Enemy7_Horizontal
        mov cx, enemy7_x
        inc dx
        mov ax, dx
        sub ax, enemy7_y
        cmp ax, player_size
        jne Draw_Enemy7_Horizontal        
    ret
draw_enemy7 endp

erase_enemy7 proc near 
    mov cx, enemy7_x_prev
    mov dx, enemy7_y
    Erase_Enemy7_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy7_x_prev
        cmp ax, player_size
        jne Erase_Enemy7_Horizontal
        mov cx, enemy7_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy7_y
        cmp ax, player_size
        jne Erase_Enemy7_Horizontal        
    ret
erase_enemy7 endp

move_enemy8 proc near
    cmp enemy8_flag, 1
    je next_move_enemy8
    ret

    next_move_enemy8:

    add enemy8_x, 16
    call erase_enemy8
    cmp enemy8_x, 296
    je reset_enemy8

    call draw_enemy8
    ret

    reset_enemy8:
    mov enemy8_x, 08
    mov enemy8_x_prev, 24
    mov enemy8_flag, 0
    ret
move_enemy8 endp

draw_enemy8 proc near
    mov cx, enemy8_x
    mov dx, enemy8_y
    mov si, offset tennis_color_pattern
    mov enemy8_x_prev, cx
    Draw_Enemy8_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy8_x
        cmp ax, player_size
        jne Draw_Enemy8_Horizontal
        mov cx, enemy8_x
        inc dx
        mov ax, dx
        sub ax, enemy8_y
        cmp ax, player_size
        jne Draw_Enemy8_Horizontal        
    ret
draw_enemy8 endp

erase_enemy8 proc near 
    mov cx, enemy8_x_prev
    mov dx, enemy8_y
    Erase_Enemy8_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy8_x_prev
        cmp ax, player_size
        jne Erase_Enemy8_Horizontal
        mov cx, enemy8_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy8_y
        cmp ax, player_size
        jne Erase_Enemy8_Horizontal        
    ret
erase_enemy8 endp

move_enemy9 proc near
    cmp enemy9_flag, 1
    JE next_move_enemy9
    ret

    next_move_enemy9:
    sub enemy9_x, 16
    call erase_enemy9
    cmp enemy9_x, 08
    JE reset_enemy9

    call draw_enemy9
    ret

    reset_enemy9:
    mov enemy9_x, 296
    mov enemy9_x_prev, 280
    mov enemy9_flag, 0
    ret
move_enemy9 endp

draw_enemy9 proc near
    mov cx, enemy9_x
    mov dx, enemy9_y
    mov si, offset tennis_color_pattern
    mov enemy9_x_prev, cx
    Draw_Enemy9_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy9_x
        cmp ax, player_size
        JNE Draw_Enemy9_Horizontal
        mov cx, enemy9_x
        inc dx
        mov ax, dx
        sub ax, enemy9_y
        cmp ax, player_size
        jne Draw_Enemy9_Horizontal        
    ret
draw_enemy9 endp

erase_enemy9 proc near 
    mov cx, enemy9_x_prev
    mov dx, enemy9_y

    Erase_Enemy9_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy9_x_prev
        cmp ax, player_size
        JNE Erase_Enemy9_Horizontal
        mov cx, enemy9_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy9_y
        cmp ax, player_size
        jne Erase_Enemy9_Horizontal        
    ret
erase_enemy9 endp

move_enemy10 proc near
    cmp enemy10_flag, 1
    JE next_move_enemy10
    ret

    next_move_enemy10:

    sub enemy10_x, 16
    call erase_enemy10
    cmp enemy10_x, 08
    JE reset_enemy10

    call draw_enemy10
    ret

    reset_enemy10:
    mov enemy10_x, 296
    mov enemy10_x_prev, 280
    mov enemy10_flag, 0
    ret
move_enemy10 endp

draw_enemy10 proc near
    mov cx, enemy10_x ; CX = X, set initial x coordinates 
    mov dx, enemy10_y ; DX = Y, set initial y coordinates
    mov si, offset tennis_color_pattern
    mov enemy10_x_prev, cx
    Draw_Enemy10_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, enemy10_x
        cmp ax, player_size         ;   15
        JNE Draw_Enemy10_Horizontal
        mov cx, enemy10_x
        inc dx
        mov ax, dx
        sub ax, enemy10_y
        cmp ax, player_size
        jne Draw_Enemy10_Horizontal        
    ret
draw_enemy10 endp

erase_enemy10 proc near 
    mov cx, enemy10_x_prev ; CX = X, set initial x coordinates 
    mov dx, enemy10_y ; DX = Y, set initial y coordinates

    Erase_Enemy10_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 00h ;color black
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, enemy10_x_prev
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Erase_Enemy10_Horizontal  ; !(ax > player_size)
        mov cx, enemy10_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy10_y
        cmp ax, player_size
        jne Erase_Enemy10_Horizontal        
    ret
erase_enemy10 endp

move_enemy11 proc near
    cmp enemy11_flag, 1
    JE next_move_enemy11
    ret

    next_move_enemy11:
    sub enemy11_x, 16
    call erase_enemy11
    cmp enemy11_x, 08
    JE reset_enemy11

    call draw_enemy11
    ret

    reset_enemy11:
    mov enemy11_x, 296
    mov enemy11_x_prev, 280
    mov enemy11_flag, 0
    ret
move_enemy11 endp

draw_enemy11 proc near
    mov cx, enemy11_x
    mov dx, enemy11_y
    mov si, offset tennis_color_pattern
    mov enemy11_x_prev, cx
    Draw_Enemy11_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy11_x
        cmp ax, player_size
        JNE Draw_Enemy11_Horizontal
        mov cx, enemy11_x
        inc dx
        mov ax, dx
        sub ax, enemy11_y
        cmp ax, player_size
        jne Draw_Enemy11_Horizontal        
    ret
draw_enemy11 endp

erase_enemy11 proc near 
    mov cx, enemy11_x_prev
    mov dx, enemy11_y

    Erase_Enemy11_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy11_x_prev
        cmp ax, player_size
        JNE Erase_Enemy11_Horizontal
        mov cx, enemy11_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy11_y
        cmp ax, player_size
        jne Erase_Enemy11_Horizontal        
    ret
erase_enemy11 endp

move_enemy12 proc near
    cmp enemy12_flag, 1
    JE next_move_enemy12
    ret

    next_move_enemy12:
    sub enemy12_x, 16
    call erase_enemy12
    cmp enemy12_x, 08
    JE reset_enemy12

    call draw_enemy12
    ret

    reset_enemy12:
    mov enemy12_x, 296
    mov enemy12_x_prev, 280
    mov enemy12_flag, 0
    ret
move_enemy12 endp

draw_enemy12 proc near
    mov cx, enemy12_x
    mov dx, enemy12_y
    mov si, offset tennis_color_pattern
    mov enemy12_x_prev, cx
    Draw_Enemy12_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy12_x
        cmp ax, player_size
        JNE Draw_Enemy12_Horizontal
        mov cx, enemy12_x
        inc dx
        mov ax, dx
        sub ax, enemy12_y
        cmp ax, player_size
        jne Draw_Enemy12_Horizontal        
    ret
draw_enemy12 endp

erase_enemy12 proc near 
    mov cx, enemy12_x_prev
    mov dx, enemy12_y

    Erase_Enemy12_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy12_x_prev
        cmp ax, player_size
        JNE Erase_Enemy12_Horizontal
        mov cx, enemy12_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy12_y
        cmp ax, player_size
        jne Erase_Enemy12_Horizontal        
    ret
erase_enemy12 endp

move_enemy13 proc near
    cmp enemy13_flag, 1
    JE next_move_enemy13
    ret

    next_move_enemy13:
    sub enemy13_x, 16
    call erase_enemy13
    cmp enemy13_x, 08
    JE reset_enemy13

    call draw_enemy13
    ret

    reset_enemy13:
    mov enemy13_x, 296
    mov enemy13_x_prev, 280
    mov enemy13_flag, 0
    ret
move_enemy13 endp

draw_enemy13 proc near
    mov cx, enemy13_x
    mov dx, enemy13_y
    mov si, offset tennis_color_pattern
    mov enemy13_x_prev, cx
    Draw_Enemy13_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy13_x
        cmp ax, player_size
        JNE Draw_Enemy13_Horizontal
        mov cx, enemy13_x
        inc dx
        mov ax, dx
        sub ax, enemy13_y
        cmp ax, player_size
        jne Draw_Enemy13_Horizontal        
    ret
draw_enemy13 endp

erase_enemy13 proc near 
    mov cx, enemy13_x_prev
    mov dx, enemy13_y

    Erase_Enemy13_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy13_x_prev
        cmp ax, player_size
        JNE Erase_Enemy13_Horizontal
        mov cx, enemy13_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy13_y
        cmp ax, player_size
        jne Erase_Enemy13_Horizontal        
    ret
erase_enemy13 endp

move_enemy14 proc near
    cmp enemy14_flag, 1
    JE next_move_enemy14
    ret

    next_move_enemy14:
    sub enemy14_x, 16
    call erase_enemy14
    cmp enemy14_x, 08
    JE reset_enemy14

    call draw_enemy14
    ret

    reset_enemy14:
    mov enemy14_x, 296
    mov enemy14_x_prev, 280
    mov enemy14_flag, 0
    ret
move_enemy14 endp

draw_enemy14 proc near
    mov cx, enemy14_x
    mov dx, enemy14_y
    mov si, offset tennis_color_pattern
    mov enemy14_x_prev, cx
    Draw_Enemy14_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy14_x
        cmp ax, player_size
        JNE Draw_Enemy14_Horizontal
        mov cx, enemy14_x
        inc dx
        mov ax, dx
        sub ax, enemy14_y
        cmp ax, player_size
        jne Draw_Enemy14_Horizontal        
    ret
draw_enemy14 endp

erase_enemy14 proc near 
    mov cx, enemy14_x_prev
    mov dx, enemy14_y

    Erase_Enemy14_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy14_x_prev
        cmp ax, player_size
        JNE Erase_Enemy14_Horizontal
        mov cx, enemy14_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy14_y
        cmp ax, player_size
        jne Erase_Enemy14_Horizontal        
    ret
erase_enemy14 endp

move_enemy15 proc near
    cmp enemy15_flag, 1
    JE next_move_enemy15
    ret

    next_move_enemy15:
    sub enemy15_x, 16
    call erase_enemy15
    cmp enemy15_x, 08
    JE reset_enemy15

    call draw_enemy15
    ret

    reset_enemy15:
    mov enemy15_x, 296
    mov enemy15_x_prev, 280
    mov enemy15_flag, 0
    ret
move_enemy15 endp

draw_enemy15 proc near
    mov cx, enemy15_x
    mov dx, enemy15_y
    mov si, offset tennis_color_pattern
    mov enemy15_x_prev, cx
    Draw_Enemy15_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy15_x
        cmp ax, player_size
        JNE Draw_Enemy15_Horizontal
        mov cx, enemy15_x
        inc dx
        mov ax, dx
        sub ax, enemy15_y
        cmp ax, player_size
        jne Draw_Enemy15_Horizontal        
    ret
draw_enemy15 endp

erase_enemy15 proc near 
    mov cx, enemy15_x_prev
    mov dx, enemy15_y

    Erase_Enemy15_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy15_x_prev
        cmp ax, player_size
        JNE Erase_Enemy15_Horizontal
        mov cx, enemy15_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy15_y
        cmp ax, player_size
        jne Erase_Enemy15_Horizontal        
    ret
erase_enemy15 endp

move_enemy16 proc near
    cmp enemy16_flag, 1
    JE next_move_enemy16
    ret

    next_move_enemy16:
    sub enemy16_x, 16
    call erase_enemy16
    cmp enemy16_x, 08
    JE reset_enemy16

    call draw_enemy16
    ret

    reset_enemy16:
    mov enemy16_x, 296
    mov enemy16_x_prev, 280
    mov enemy16_flag, 0
    ret
move_enemy16 endp

draw_enemy16 proc near
    mov cx, enemy16_x
    mov dx, enemy16_y
    mov si, offset tennis_color_pattern
    mov enemy16_x_prev, cx
    Draw_Enemy16_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, enemy16_x
        cmp ax, player_size
        JNE Draw_Enemy16_Horizontal
        mov cx, enemy16_x
        inc dx
        mov ax, dx
        sub ax, enemy16_y
        cmp ax, player_size
        jne Draw_Enemy16_Horizontal        
    ret
draw_enemy16 endp

erase_enemy16 proc near 
    mov cx, enemy16_x_prev
    mov dx, enemy16_y

    Erase_Enemy16_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, enemy16_x_prev
        cmp ax, player_size
        JNE Erase_Enemy16_Horizontal
        mov cx, enemy16_x_prev
        inc dx
        mov ax, dx
        sub ax, enemy16_y
        cmp ax, player_size
        jne Erase_Enemy16_Horizontal        
    ret
erase_enemy16 endp

drawPlayer proc near
    mov cx, player_x ; CX = X, set initial x coordinates, 0
    mov dx, player_y ; DX = Y, set initial y coordinates, 0
    ;mov prev_x

    Draw_Player_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
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
                                        ;   exit the function
drawLeftBorder proc near
    mov cx, leftborder_x    ; CX = X, set initial x coordinates 
    mov dx, verticalborder_y    ; DX = Y, set initial y coordinates
    
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

set_enemy1_flag proc near
    mov enemy1_flag, 1
    ret
set_enemy1_flag endp

set_enemy2_flag proc near
    mov enemy2_flag, 1
    ret
set_enemy2_flag endp

set_enemy3_flag proc near
    mov enemy3_flag, 1
    ret
set_enemy3_flag endp

set_enemy4_flag proc near
    mov enemy4_flag, 1
    ret
set_enemy4_flag endp

set_enemy5_flag proc near
    mov enemy5_flag, 1
    ret
set_enemy5_flag endp

set_enemy6_flag proc near
    mov enemy6_flag, 1
    ret
set_enemy6_flag endp

set_enemy7_flag proc near
    mov enemy7_flag, 1
    ret
set_enemy7_flag endp

set_enemy8_flag proc near
    mov enemy8_flag, 1
    ret
set_enemy8_flag endp

set_enemy9_flag proc near
    mov enemy9_flag, 1
    ret
set_enemy9_flag endp


set_enemy10_flag proc near
    mov enemy10_flag, 1
    ret
set_enemy10_flag endp

set_enemy11_flag proc near
    mov enemy11_flag, 1
    ret
set_enemy11_flag endp

set_enemy12_flag proc near
    mov enemy12_flag, 1
    ret
set_enemy12_flag endp

set_enemy13_flag proc near
    mov enemy13_flag, 1
    ret
set_enemy13_flag endp

set_enemy14_flag proc near
    mov enemy14_flag, 1
    ret
set_enemy14_flag endp

set_enemy15_flag proc near
    mov enemy15_flag, 1
    ret
set_enemy15_flag endp

set_enemy16_flag proc near
    mov enemy16_flag, 1
    ret
set_enemy16_flag endp

check_enemy_collision_player proc near
    ;   Check for x pos collision
    mov ax, enemy1_x
    cmp player_x, ax
    JE  check_y1
    JNE next_collision1
    ;   Check for y pos collision
    check_y1:
    mov ax, enemy1_y
    cmp player_y, ax

    JNE next_collision1
    call border_collision
    call drawPlayer

    next_collision1:


    ret
check_enemy_collision_player endp

Move_Level1 proc near

    ;   1st projectile
    lvl1_next0:             ;   set specified time on when will the projectiles spawn
    cmp time_seconds, 60
    JNE lvl1_next1
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy16_flag

    lvl1_next1:
    cmp time_seconds, 57
    JNE lvl1_next2
        call set_enemy1_flag
        call set_enemy3_flag
        call set_enemy5_flag
        call set_enemy7_flag
    

    lvl1_next2:
    cmp time_seconds, 54
    JNE lvl1_next3
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy6_flag
        call set_enemy15_flag

    lvl1_next3:
    cmp time_seconds, 51
    JNE lvl1_next4
        call set_enemy3_flag
        call set_enemy5_flag
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy6_flag
        call set_enemy7_flag
        call set_enemy16_flag
      
    lvl1_next4:
    cmp time_seconds, 48
    JNE lvl1_next5
        call set_enemy9_flag
        call set_enemy2_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy14_flag
        call set_enemy13_flag
   
    lvl1_next5:
    cmp time_seconds, 45
    JNE lvl1_next6
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy6_flag
        call set_enemy15_flag
        call set_enemy8_flag
   
    lvl1_next6:
    cmp time_seconds, 42
    JNE lvl1_next7
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy14_flag
        call set_enemy15_flag 


    lvl1_next7:
    cmp time_seconds, 39
    JNE lvl1_next8
    call set_enemy1_flag
    call set_enemy3_flag
    call set_enemy4_flag
    call set_enemy5_flag
    call set_enemy6_flag
    call set_enemy15_flag
    call set_enemy16_flag
    call set_enemy12_flag

    lvl1_next8:
    cmp time_seconds, 36
    JNE lvl1_next9
        call set_enemy3_flag
        call set_enemy1_flag
        call set_enemy5_flag
        call set_enemy4_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy9_flag
        call set_enemy2_flag
    lvl1_next9:

   lvl1_next9:
    cmp time_seconds, 33
    JNE lvl1_next10
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy6_flag
        call set_enemy7_flag
       
    lvl1_next10:

       lvl1_next10:
    cmp time_seconds, 30
    JNE lvl1_next11
        call set_enemy1_flag
        call set_enemy4_flag
        call set_enemy6_flag
        call set_enemy16_flag
        call set_enemy12_flag
    lvl1_next11:

           lvl1_next11:
    cmp time_seconds, 27
    JNE lvl1_next12
        call set_enemy1_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy15_flag
        call set_enemy16_flag
        call set_enemy12_flag
    lvl1_next12:

             lvl1_next12:
    cmp time_seconds, 24
    JNE lvl1_next13
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy14_flag
        call set_enemy16_flag
        call set_enemy5_flag
        call set_enemy9_flag
      
    lvl1_next13:

               lvl1_next13:
    cmp time_seconds, 21
    JNE lvl1_next14
        call set_enemy1_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy8_flag
        call set_enemy13_flag
        call set_enemy1_flag
      
    lvl1_next14:

          lvl1_next14:
    cmp time_seconds, 18
    JNE lvl1_next15
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy7_flag
        call set_enemy8_flag
        call set_enemy16_flag
      
    lvl1_next15:

          lvl1_next15:
    cmp time_seconds, 15
    JNE lvl1_next16
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy14_flag
        call set_enemy13_flag
        call set_enemy1_flag
      
    lvl1_next16:
 
   lvl1_next16:
    cmp time_seconds, 12
    JNE lvl1_next17
        call set_enemy1_flag
        call set_enemy3_flag
        call set_enemy6_flag
        call set_enemy15_flag
        call set_enemy16_flag
      
    lvl1_next17:

       lvl1_next18:
    cmp time_seconds, 9
    JNE lvl1_next19
        call set_enemy2_flag
        call set_enemy4_flag
        call set_enemy6_flag
        call set_enemy8_flag
        call set_enemy13_flag
      
    lvl1_next19:

   lvl1_next19:
    cmp time_seconds, 6
    JNE lvl1_next20
        call set_enemy10_flag
        call set_enemy12_flag
        call set_enemy14_flag
        call set_enemy16_flag
        call set_enemy7_flag
      
    lvl1_next20:

     lvl1_next20:
    cmp time_seconds,3
    JNE lvl1_next21
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy11_flag
        call set_enemy4_flag
        call set_enemy13_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy7_flag
    lvl1_next21:

    move_enemies_lvl1:    
        call move_enemy1
        call move_enemy2
        call move_enemy3
        call move_enemy4
        call move_enemy5
        call move_enemy6
        call move_enemy7
        call move_enemy8
        call move_enemy9
        call move_enemy10
        call move_enemy11
        call move_enemy12
        call move_enemy13
        call move_enemy14
        call move_enemy15
        call move_enemy16


    ret
move_level1 endp


Move_Level2 proc near

    lvl2_next0:             ;   set specified time on when will the projectiles spawn
    cmp time_seconds, 60
    JNE lvl2_next1
        call set_enemy2_flag
        call set_enemy12_flag
        call set_enemy9_flag
        call set_enemy15_flag
        call set_enemy16_flag

    lvl2_next1:
    cmp time_seconds, 57
    JNE lvl2_next2
        call set_enemy14_flag
        call set_enemy7_flag
        call set_enemy3_flag
        call set_enemy8_flag
        call set_enemy10_flag
        call set_enemy13_flag

    lvl2_next2:
    cmp time_seconds, 54
    JNE lvl2_next3
        call set_enemy1_flag
        call set_enemy3_flag
        call set_enemy15_flag
        call set_enemy9_flag
        call set_enemy8_flag
        call set_enemy7_flag
        call set_enemy12_flag
        call set_enemy16_flag
        call set_enemy4_flag
        call set_enemy6_flag

    lvl2_next3:
    cmp time_seconds, 51
    JNE lvl2_next4
        call set_enemy3_flag
        call set_enemy5_flag
        call set_enemy15_flag
        call set_enemy6_flag
        call set_enemy2_flag
        call set_enemy10_flag
        call set_enemy14_flag
        call set_enemy8_flag

    lvl2_next4:
    cmp time_seconds, 48
    JNE lvl2_next5
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
  
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy14_flag
    
    lvl2_next5:
    cmp time_seconds, 45
    JNE lvl2_next6
        call set_enemy6_flag
        call set_enemy5_flag
        call set_enemy4_flag
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag


    lvl2_next6:
    cmp time_seconds, 42
    JNE lvl2_next7
        call set_enemy7_flag
        call set_enemy12_flag
        call set_enemy16_flag
        call set_enemy4_flag
        call set_enemy6_flag
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag

    lvl2_next7:
    cmp time_seconds, 39
    JNE lvl2_next8
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy11_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy16_flag

    lvl2_next8:
    cmp time_seconds, 37
    JNE lvl2_next9
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy5_flag
        call set_enemy7_flag
        call set_enemy11_flag
        call set_enemy14_flag
        call set_enemy16_flag
        call set_enemy15_flag
    
    lvl2_next9:
    cmp time_seconds, 34
    JNE lvl2_next10
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy5_flag
        call set_enemy7_flag
        call set_enemy8_flag
        call set_enemy16_flag
        call set_enemy4_flag
    lvl2_next10:

lvl2_next10:
    cmp time_seconds, 31
    JNE lvl2_next11
        call set_enemy1_flag
        call set_enemy9_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy6_flag
        call set_enemy7_flag
        call set_enemy8_flag
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy14_flag
    lvl2_next11:

lvl2_next11:
    cmp time_seconds, 28
    JNE lvl2_next12
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy6_flag
        call set_enemy14_flag
        call set_enemy1_flag
        call set_enemy12_flag
    lvl2_next12:

lvl2_next12:
    cmp time_seconds, 25
    JNE lvl2_next13
        call set_enemy1_flag
        call set_enemy10_flag
        call set_enemy3_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy15_flag
        call set_enemy16_flag
        call set_enemy7_flag
        call set_enemy8_flag
        call set_enemy6_flag
    lvl2_next13:

lvl2_next13:
    cmp time_seconds, 22
    JNE lvl2_next14
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy16_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy7_flag
    lvl2_next14:

lvl2_next14:
    cmp time_seconds, 19
    JNE lvl2_next15
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy15_flag
        call set_enemy8_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy12_flag
    lvl2_next15:

lvl2_next15:
    cmp time_seconds, 17
    JNE lvl2_next16
        call set_enemy10_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy14_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy8_flag
    lvl2_next16:

lvl2_next16:
    cmp time_seconds, 14
    JNE lvl2_next17
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy12_flag
        call set_enemy3_flag
        call set_enemy2_flag
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy8_flag
    lvl2_next17:

lvl2_next17:
    cmp time_seconds, 11
    JNE lvl2_next18
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy5_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy16_flag
        
    lvl2_next18:

lvl2_next18:
    cmp time_seconds, 9
    JNE lvl2_next19
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy7_flag
        call set_enemy8_flag
        call set_enemy15_flag
        call set_enemy1_flag
        
    lvl2_next19:

lvl2_next19:
    cmp time_seconds, 6
    JNE lvl2_next20
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy8_flag
        call set_enemy15_flag
        
    lvl2_next20:

lvl2_next20:
    cmp time_seconds, 6
    JNE lvl2_next21
        call set_enemy1_flag
        call set_enemy9_flag
        call set_enemy2_flag
        call set_enemy10_flag
        call set_enemy3_flag
        call set_enemy11_flag
        call set_enemy4_flag
        call set_enemy12_flag
        call set_enemy8_flag
        call set_enemy7_flag
        call set_enemy6_flag
        call set_enemy16_flag
        call set_enemy3_flag
        call set_enemy11_flag
        call set_enemy4_flag
        call set_enemy12_flag
        
    lvl2_next21:
    
    lvl2_next22:
    cmp time_seconds, 2
    JNE lvl2_next23
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy15_flag
        call set_enemy16_flag
        call set_enemy14_flag
         call set_enemy6_flag
        call set_enemy16_flag
        call set_enemy3_flag
        call set_enemy11_flag
        call set_enemy4_flag
        call set_enemy12_flag
    lvl2_next23:

    move_enemies_lvl2:    
        call move_enemy1
        call move_enemy2
        call move_enemy3
        call move_enemy4
        call move_enemy5
        call move_enemy6
        call move_enemy7
        call move_enemy8
        call move_enemy9
        call move_enemy10
        call move_enemy11
        call move_enemy12
        call move_enemy13
        call move_enemy14
        call move_enemy15
        call move_enemy16



    ret
Move_Level2 endp


Move_Level3 proc near

    lvl3_next0:             
    cmp time_seconds, 60
    JNE lvl3_next1
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy15_flag
        call set_enemy16_flag
    cmp time_seconds, 58
        call set_enemy16_flag


    lvl3_next1:
    cmp time_seconds, 57
    JNE lvl3_next2
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy14_flag
        call set_enemy13_flag
        call set_enemy12_flag
        call set_enemy2_flag
    cmp time_seconds, 56
        call set_enemy1_flag

    lvl3_next2:
    cmp time_seconds, 54
    JNE lvl3_next3
        call set_enemy9_flag
        call set_enemy10_flag
    cmp time_seconds, 53
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy13_flag
        call set_enemy6_flag
        call set_enemy15_flag
        call set_enemy8_flag
        call set_enemy16_flag
        call set_enemy15_flag

    lvl3_next3:
    cmp time_seconds, 51
    JNE lvl3_next4
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy8_flag

    lvl3_next4:
    cmp time_seconds, 48
    JNE lvl3_next5
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy14_flag
        call set_enemy13_flag
        call set_enemy12_flag
        call set_enemy11_flag
        call set_enemy10_flag
        call set_enemy1_flag
        call set_enemy2_flag
    
    lvl3_next5:
    cmp time_seconds, 45
    JNE lvl3_next6
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy14_flag
        call set_enemy13_flag
        call set_enemy4_flag
        call set_enemy11_flag
        call set_enemy10_flag
        call set_enemy1_flag
        call set_enemy2_flag


    lvl3_next6:
    cmp time_seconds, 42
    JNE lvl3_next7
        call set_enemy1_flag
        call set_enemy10_flag
        call set_enemy13_flag
        call set_enemy4_flag
        call set_enemy13_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy7_flag
        

    lvl3_next7:
    cmp time_seconds, 39
    JNE lvl3_next8
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy15_flag
        call set_enemy7_flag
        call set_enemy8_flag
        call set_enemy16_flag
    lvl3_next8:
    cmp time_seconds, 37
    JNE lvl3_next9
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy8_flag
        call set_enemy16_flag
    
    lvl3_next9:
    cmp time_seconds, 34
    JNE lvl3_next10
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy5_flag
        call set_enemy7_flag
        call set_enemy8_flag
        call set_enemy16_flag
        call set_enemy4_flag
    lvl3_next10:

lvl3_next10:
    cmp time_seconds, 31
    JNE lvl3_next11
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy6_flag
        call set_enemy7_flag
        call set_enemy7_flag
        call set_enemy8_flag
    cmp time_seconds, 29
        call set_enemy16_flag
    lvl3_next11:

lvl3_next11:
    cmp time_seconds, 28
    JNE lvl3_next12
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy13_flag
        call set_enemy14_flag
        call set_enemy16_flag
    cmp time_seconds, 26
        call set_enemy6_flag
        call set_enemy7_flag
        call set_enemy8_flag
    lvl3_next12:

lvl3_next12:
    cmp time_seconds, 25
    JNE lvl3_next13
        call set_enemy8_flag
        call set_enemy7_flag
        call set_enemy6_flag
        call set_enemy5_flag
        call set_enemy4_flag
        call set_enemy11_flag
        call set_enemy10_flag
    cmp time_seconds, 23 
        call set_enemy1_flag

    lvl3_next13:

lvl3_next13:
    cmp time_seconds, 22
    JNE lvl3_next14
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy14_flag
        call set_enemy5_flag
        call set_enemy4_flag
        call set_enemy11_flag
        call set_enemy2_flag
        call set_enemy1_flag

     cmp time_seconds, 20   
        call set_enemy6_flag
        call set_enemy7_flag
    lvl3_next14:

lvl3_next14:
    cmp time_seconds, 19
    JNE lvl3_next15
        call set_enemy1_flag
        call set_enemy10_flag
        call set_enemy3_flag
        call set_enemy12_flag
        call set_enemy5_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy16_flag
    cmp time_seconds, 18
        call set_enemy7_flag
     
    lvl3_next15:

lvl3_next15:
    cmp time_seconds, 17
    JNE lvl3_next16
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy7_flag
    cmp time_seconds, 15
        call set_enemy15_flag
        call set_enemy16_flag
      
    lvl3_next16:

lvl3_next16:
    cmp time_seconds, 14
    JNE lvl3_next17
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy13_flag
     cmp time_seconds, 12   
        call set_enemy14_flag
        call set_enemy6_flag
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy7_flag
    lvl3_next17:

lvl3_next17:
    cmp time_seconds, 11
    JNE lvl3_next18
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy11_flag
        call set_enemy13_flag
        call set_enemy14_flag
        call set_enemy15_flag
        
    lvl3_next18:

lvl3_next18:
    cmp time_seconds, 9
    JNE lvl3_next19
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy7_flag
        call set_enemy8_flag
        
    lvl3_next19:

lvl3_next19:
    cmp time_seconds, 6
    JNE lvl3_next20
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy16_flag
        call set_enemy8_flag
        call set_enemy15_flag
        
    lvl3_next20:

lvl3_next20:
    cmp time_seconds, 3
    JNE lvl3_next21
        call set_enemy1_flag
        call set_enemy9_flag
        call set_enemy2_flag
        call set_enemy10_flag
        call set_enemy3_flag
        call set_enemy11_flag
        call set_enemy4_flag
        call set_enemy12_flag
        call set_enemy8_flag
        call set_enemy7_flag
        call set_enemy6_flag
        call set_enemy16_flag
        call set_enemy3_flag
        call set_enemy11_flag
        call set_enemy4_flag
        call set_enemy12_flag
        
    lvl3_next21:
    
    lvl3_next22:
    cmp time_seconds, 2
    JNE lvl3_next23
        call set_enemy1_flag
        call set_enemy9_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy11_flag
        call set_enemy4_flag
        call set_enemy12_flag
        call set_enemy5_flag
         call set_enemy13_flag
        call set_enemy6_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy8_flag
        call set_enemy12_flag
    lvl3_next23:

    move_enemies_lvl3:    
        call move_enemy1
        call move_enemy2
        call move_enemy3
        call move_enemy4
        call move_enemy5
        call move_enemy6
        call move_enemy7
        call move_enemy8
        call move_enemy9
        call move_enemy10
        call move_enemy11
        call move_enemy12
        call move_enemy13
        call move_enemy14
        call move_enemy15
        call move_enemy16

    ret
Move_Level3 endp


reset_variables proc near
    mov time_aux, 0
    mov time_tix, 0
    mov time_enemy_speed, 0
    mov player_x, 152 
    mov player_y, 92 
    mov prev_x, 152
    mov prev_y, 92
    mov time_seconds, 63

    mov life1_x, 75
    mov life1_y, 184
    mov life2_x, 98
    mov life2_y, 184
    mov life3_x, 121
    mov life3_y, 184

    mov enemy1_flag, 0    ;   0 = false, 1 = true
    mov enemy3_flag, 0    ;   0 = false, 1 = true
    mov enemy2_flag, 0    ;
    mov enemy4_flag, 0
    mov enemy5_flag, 0    ;   0 = false, 1 = true
    mov enemy6_flag, 0    ;
    mov enemy7_flag, 0    ;   0 = false, 1 = true
    mov enemy8_flag, 0

    mov enemy1_x, 08
    mov enemy1_y, 44
    mov enemy1_x_prev, 24

    mov enemy2_x, 08
    mov enemy2_y, 60
    mov enemy2_x_prev, 24

    mov enemy3_x, 08
    mov enemy3_y, 76
    mov enemy3_x_prev, 24

    mov enemy4_x, 08
    mov enemy4_y, 92
    mov enemy4_x_prev, 24

    mov enemy5_x, 08
    mov enemy5_y, 108
    mov enemy5_x_prev, 24

    mov enemy6_x, 08
    mov enemy6_y, 124
    mov enemy6_x_prev, 24

    mov enemy7_x, 08
    mov enemy7_y, 140
    mov enemy7_x_prev, 24

    mov enemy8_x, 08
    mov enemy8_y, 156
    mov enemy8_x_prev, 24


    mov ones, 33h
    mov tens, 36h

    mov score_ones, '0'
    mov score_hund, '0'
    mov score_tens, '0'

    ret
reset_variables endp

end Main                                             ;   End the main function