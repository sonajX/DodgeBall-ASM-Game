;--------------------------------------------------------------------------------------------------------------------------------
;   Goal:   is to create a pixel with player movement using WASD-
;           and create enemies (or projectiles) that ends the game when hit
;   
;   An ASM small program is divided into segments- 
;    1. Model
;    2. Stack
;    3. Data
;    4. Code
;--------------------------------------------------------------------------------------------------------------------------------
.model small    ; Sets the model to small where it can use 64K of data, this is suffficient
.stack          ; sets stack segment
.data           ; data segment is where we instantiate our DATA or WORDS

;   { Messages
    message_start db 'Press [T] - Start'
  	message_start_1 equ $-message_start
    message_info db 'Press [U] - More Info'
    message_info_1 equ $-message_info
    message_leaderboard db "Press [L] - Leaderboard"
    message_leaderboard_1 equ $-message_leaderboard
    message_character_select db 'Press [C] - Select Character'
    message_character_select1 equ $-message_character_select
    message_exit db 'Press [E] to Exit Game'
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

    message_next db 'Next [N]'
    message_next_1 equ $-message_next

    message_back db '[B] Back'
    message_back_1 equ $-message_back

    message_knight db '[1] Dodger'
    message_knight1 equ $-message_knight

    message_little_girl db '[2] Maria'
    message_little_girl1 equ $-message_little_girl

    message_knife db '[3] Knife'
    message_knife_1 equ $-message_knife

    message_mountain db '[4] Mountain'
    message_mountain1 equ $-message_mountain

    message_jgirl db '[5] Yuki'
    message_jgirl1 equ $-message_jgirl

    message_selected db 'Selected: '
    message_selected1 equ $-message_selected

    message_controls db 'Movement'
    message_controls_1 equ $-message_controls

    message_avoid db 'Avoid'
    message_avoid_1 equ $-message_avoid

    message_catch db 'Catch'
    message_catch_1 equ $-message_catch

    message_orbA db '+Health'
    message_orbA_1 equ $-message_orbA

    message_orbB db '+Points'
    message_orbB_1 equ $-message_orbB

    message_orbC db '+Immune'
    message_orbC_1 equ $-message_orbC

    message_mechanics db 'Mechanics'
    message_mechanics_1 equ $-message_mechanics

    message_mechanicsA db '1. Use WASD to move your character' 
    message_mechanicsA_1 equ $-message_mechanicsA

    message_mechanicsB db '2. Score increases as time passes'
    message_mechanicsB_1 equ $-message_mechanicsB  
                         
    message_mechanicsC db '3. Dodge hazard balls to not lose HP'
    message_mechanicsC_1 equ $-message_mechanicsC
    
    message_mechanicsD db '4. Catch bonus balls for a powerup'
    message_mechanicsD_1 equ $-message_mechanicsD

    
;    { Game Variables
    game_level dw 0      ;   Change after level selector have been implemented
    time_aux db 0           ; To Check if the time has changed
    time_tix dw 0           ; Use as variable for tick speed
    time_enemy_speed dw 0   
    time_seconds dw 63
    time_half_seconds dw 126
    immune_seconds dw 0
    player_score dw 0
    score_delay_tix dw 0
    Score_Increment_Speed dw 44

    ones dw 33h
    ones_1 equ $-ones
    tens dw 36h  
    tens_1 equ $-tens

    temp dw 0

    
    ;   character coords
    player_x dw 152 ;x = 160, default center position
    player_y dw 92 ;y = 100, default center position
    enemy_tick_speed dw 2  ;   enemy speed per tick
    prev_x dw 152
    prev_y dw 92

    skin_x dw 20
    skin_y dw 78
    skin_select dw 1
    menu_ball_x dw 238
    menu_ball_y dw 40
    menu_ball_y_prev dw 40

    ;   header
    header_Width dw 48
    header_Height dw 46
    header_x dw 60
    header_y dw 17
    
    keyPressed DB 0000h

    ;   Top left border spawn, x = 34, y = 45, add 13 on x or y
    life1_x dw 52
    life1_y dw 183
    
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

    ;   left extra
    extra1_x dw 08
    extra1_y dw 44
    extra1_x_prev dw 24

    extra3_x dw 08
    extra3_y dw 76
    extra3_x_prev dw 24

    extra5_x dw 08
    extra5_y dw 108
    extra5_x_prev dw 24

    extra7_x dw 08
    extra7_y dw 140
    extra7_x_prev dw 24
    ; Right extra
    extra10_x dw 296
    extra10_y dw 60
    extra10_x_prev dw 280 

    extra12_x dw 296
    extra12_y dw 92
    extra12_x_prev dw 280

    extra14_x dw 296
    extra14_y dw 124
    extra14_x_prev dw 280

    extra16_x dw 296
    extra16_y dw 156
    extra16_x_prev dw 280

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

playerCurrent_Skin_pattern db 225 dup(0)
playerCurrent_color_pattern db 225 dup(0)
playerPrevious_color_pattern db 225 dup(0)
playerRight_color_pattern   db 225 dup(0)
playerLeft_color_pattern    db 225 dup(0)
playerUp_color_pattern      db 225 dup(0)
;   menu ball logo

ball_logo_01    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h
    db 00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h
    db 00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h
    db 00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h
    db 00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h
    db 00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h
    db 00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h
    db 00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h
    db 00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h
    db 00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h
    db 00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h
    db 00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h
    db 00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h
    db 00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h
    db 00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h
    db 00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h
    db 00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h
    db 00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h
    db 00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h
    db 00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h
    db 00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h
    db 00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,0fh,04h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,04h,0fh,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;   Invulnerable
playerinvincible_color_pattern db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h,00h
      db 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h
      db 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h
      db 00h,00h,0Fh,0Fh,0Fh,0Fh,00h,0Fh,0Fh,0Fh,00h,0Fh,0Fh,00h,00h
      db 00h,00h,0Fh,0Fh,0Fh,0Fh,00h,0Fh,0Fh,0Fh,00h,0Fh,0Fh,00h,00h
      db 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h
      db 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h
      db 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h
      db 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h
      db 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h
      db 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h
      db 00h,00h,00h,0Fh,0Fh,0Fh,00h,00h,00h,0Fh,0Fh,0Fh,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;
playerKnightR_pattern db 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
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

playerKnightL_pattern db 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
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

playerKnightU_pattern db 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
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
;
jgirl_right_color_pattern db 00h, 00h, 00h, 00h, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 00h, 00h, 00h, 00h
						  db 00h, 00h, 0bh, 0bh, 0bh, 0bh, 00h, 00h, 0ch, 0ch, 0ch, 00h, 00h, 00h, 00h
						  db 00h, 00h, 0bh, 0bh, 0bh, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 00h, 00h
						  db 00h, 0bh, 0bh, 0bh, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 00h
						  db 00h, 0bh, 0bh, 00h, 0bh, 0bh, 0bh, 0eh, 0eh, 0eh, 0eh, 0bh, 0bh, 0bh, 00h
						  db 00h, 09h, 00h, 0bh, 0bh, 0bh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0bh, 0bh, 00h
						  db 00h, 09h, 00h, 09h, 0eh, 0bh, 02h, 00h, 0eh, 0eh, 00h, 02h, 0bh, 0bh, 00h
						  db 00h, 09h, 09h, 00h, 0eh, 0bh, 0fh, 02h, 0fh, 0fh, 02h, 0fh, 0bh, 00h, 00h
						  db 00h, 09h, 09h, 09h, 00h, 09h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 09h, 00h, 00h
						  db 00h, 00h, 09h, 09h, 00h, 09h, 00h, 0ch, 0eh, 0eh, 0ch, 00h, 09h, 00h, 00h
						  db 00h, 00h, 00h, 00h, 0dh, 09h, 0dh, 0dh, 0ch, 0ch, 0dh, 0ch, 09h, 00h, 00h
						  db 00h, 00h, 00h, 0dh, 0dh, 0ch, 0fh, 0fh, 0fh, 0fh, 0fh, 0ch, 0dh, 00h, 00h
						  db 00h, 00h, 00h, 0eh, 0eh, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 0eh, 00h, 00h
						  db 00h, 00h, 00h, 00h, 00h, 0dh, 0dh, 0dh, 0dh, 0ch, 0dh, 00h, 00h, 00h, 00h
						  db 00h, 00h, 00h, 00h, 00h, 0dh, 0dh, 0dh, 0dh, 0ch, 0dh, 00h, 00h, 00h, 00h

jgirl_left_color_pattern db 00h, 00h, 00h, 00h, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 00h, 00h, 00h, 00h
                		 db 00h, 00h, 00h, 00h, 0ch, 0ch, 0ch, 00h, 00h, 0bh, 0bh, 0bh, 0bh, 00h, 00h
                		 db 00h, 00h, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 0bh, 0bh, 0bh, 00h, 00h
                		 db 00h, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 0bh, 0bh, 0bh, 00h
                		 db 00h, 0bh, 0bh, 0bh, 0eh, 0eh, 0eh, 0eh, 0bh, 0bh, 0bh, 00h, 0bh, 0bh, 00h
                		 db 00h, 0bh, 0bh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0bh, 0bh, 0bh, 00h, 09h, 00h
                		 db 00h, 0bh, 0bh, 02h, 00h, 0eh, 0eh, 00h, 02h, 0bh, 0eh, 09h, 00h, 09h, 00h
                		 db 00h, 00h, 0bh, 0fh, 02h, 0fh, 0fh, 02h, 0fh, 0bh, 0eh, 00h, 09h, 09h, 00h
                		 db 00h, 00h, 09h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 09h, 00h, 09h, 09h, 09h, 00h
                		 db 00h, 00h, 09h, 00h, 0ch, 0eh, 0eh, 0ch, 00h, 09h, 00h, 09h, 09h, 00h, 00h
                		 db 00h, 00h, 09h, 0ch, 0dh, 0ch, 0ch, 0dh, 0dh, 09h, 0dh, 00h, 00h, 00h, 00h
                		 db 00h, 00h, 0dh, 0ch, 0fh, 0fh, 0fh, 0fh, 0fh, 0ch, 0dh, 0dh, 00h, 00h, 00h
                		 db 00h, 00h, 0eh, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 0eh, 0eh, 00h, 00h, 00h
                		 db 00h, 00h, 00h, 00h, 0dh, 0ch, 0dh, 0dh, 0dh, 0dh, 00h, 00h, 00h, 00h, 00h
                		 db 00h, 00h, 00h, 00h, 0dh, 0ch, 0dh, 0dh, 0dh, 0dh, 00h, 00h, 00h, 00h, 00h

jgirl_back_color_pattern db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
						 db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 00h, 00h
						 db 00h, 00h, 00h, 00h, 00h, 00h, 0ch, 0ch, 0ch, 00h, 00h, 0bh, 00h, 00h, 00h
						 db 00h, 00h, 00h, 00h, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 0bh, 0bh, 0bh, 00h
						 db 00h, 00h, 00h, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 0bh, 0bh, 00h
						 db 00h, 00h, 00h, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 0bh, 0bh, 00h
						 db 00h, 00h, 00h, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 00h, 0bh, 00h
						 db 00h, 00h, 00h, 00h, 09h, 0bh, 0bh, 0bh, 0bh, 0bh, 09h, 00h, 00h, 09h, 00h
						 db 00h, 00h, 00h, 00h, 00h, 0bh, 0bh, 0bh, 0bh, 0bh, 00h, 00h, 09h, 09h, 00h
						 db 00h, 00h, 00h, 00h, 0dh, 0dh, 0dh, 0dh, 0dh, 0dh, 0dh, 00h, 09h, 09h, 00h
						 db 00h, 00h, 00h, 0dh, 0dh, 0dh, 0dh, 0dh, 0dh, 0dh, 0ch, 0dh, 00h, 00h, 00h
						 db 00h, 00h, 00h, 0dh, 0ch, 0fh, 0fh, 0fh, 0fh, 0fh, 0ch, 0dh, 00h, 00h, 00h
						 db 00h, 00h, 00h, 0eh, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 0eh, 00h, 00h, 00h
						 db 00h, 00h, 00h, 00h, 0dh, 0dh, 0dh, 0dh, 0ch, 0dh, 00h, 00h, 00h, 00h, 00h
						 db 00h, 00h, 00h, 00h, 0dh, 0dh, 0dh, 0dh, 0ch, 0dh, 00h, 00h, 00h, 00h, 00h



;
little_girl_right_color_pattern db 00h, 00h, 0dh, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h, 00h
                                db 00h, 00h, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h
                                db 00h, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h
                                db 0dh, 0dh, 0dh, 06h, 06h, 06h, 06h, 0eh, 06h, 06h, 06h, 06h, 06h, 00h, 00h
                                db 06h, 0dh, 0dh, 06h, 06h, 06h, 0eh, 0eh, 0eh, 06h, 06h, 06h, 06h, 00h, 00h
                                db 06h, 06h, 0dh, 06h, 06h, 06h, 0eh, 0eh, 0eh, 0eh, 06h, 06h, 00h, 00h, 00h
                                db 06h, 06h, 06h, 0eh, 0eh, 0ch, 0eh, 0eh, 0eh, 0ch, 0eh, 0eh, 00h, 00h, 00h
                                db 00h, 06h, 06h, 0eh, 0eh, 00h, 0eh, 0eh, 0eh, 00h, 0eh, 0eh, 00h, 00h, 00h
                                db 00h, 06h, 06h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 00h, 00h, 00h
                                db 06h, 06h, 06h, 00h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 00h, 00h, 00h, 00h
                                db 06h, 06h, 00h, 00h, 07h, 09h, 09h, 0eh, 09h, 09h, 07h, 00h, 00h, 00h, 00h
                                db 00h, 00h, 00h, 09h, 0fh, 0bh, 0bh, 0fh, 0bh, 0bh, 0fh, 09h, 00h, 00h, 00h
                                db 00h, 00h, 00h, 0eh, 0bh, 0eh, 0eh, 0bh, 0eh, 0eh, 0bh, 0eh, 00h, 00h, 00h
                                db 00h, 00h, 00h, 0eh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0eh, 00h, 00h, 00h
                                db 00h, 00h, 00h, 00h, 09h, 00h, 00h, 00h, 00h, 00h, 09h, 00h, 00h, 00h, 00h

little_girl_left_color_pattern  db 00h, 00h, 00h, 00h, 06h, 06h, 06h, 06h, 06h, 06h, 0dh, 0dh, 0dh, 00h, 00h
                                db 00h, 00h, 00h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 0dh, 0dh, 00h, 00h
                                db 00h, 00h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 0dh, 0dh, 00h
                                db 00h, 00h, 06h, 06h, 06h, 06h, 06h, 0eh, 06h, 06h, 06h, 06h, 0dh, 0dh, 0dh
                                db 00h, 00h, 06h, 06h, 06h, 06h, 0eh, 0eh, 0eh, 06h, 06h, 06h, 0dh, 0dh, 06h
                                db 00h, 00h, 00h, 06h, 06h, 0eh, 0eh, 0eh, 0eh, 06h, 06h, 06h, 0dh, 06h, 06h
                                db 00h, 00h, 00h, 0eh, 0eh, 0ch, 0eh, 0eh, 0eh, 0ch, 0eh, 0eh, 06h, 06h, 06h
                                db 00h, 00h, 00h, 0eh, 0eh, 00h, 0eh, 0eh, 0eh, 00h, 0eh, 0eh, 06h, 06h, 00h
                                db 00h, 00h, 00h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 06h, 06h, 00h
                                db 00h, 00h, 00h, 00h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 00h, 06h, 06h, 06h
                                db 00h, 00h, 00h, 00h, 07h, 09h, 09h, 0eh, 09h, 09h, 07h, 00h, 00h, 06h, 06h
                                db 00h, 00h, 00h, 09h, 0fh, 0bh, 0bh, 0fh, 0bh, 0bh, 0fh, 09h, 00h, 00h, 00h
                                db 00h, 00h, 00h, 0eh, 0bh, 0eh, 0eh, 0bh, 0eh, 0eh, 0bh, 0eh, 00h, 00h, 00h
                                db 00h, 00h, 00h, 0eh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0eh, 00h, 00h, 00h
                                db 00h, 00h, 00h, 00h, 09h, 00h, 00h, 00h, 00h, 00h, 09h, 00h, 00h, 00h, 00h

little_girl_back_color_pattern  db 00h, 00h, 0dh, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h, 00h
                                db 00h, 00h, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h
                                db 00h, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h
                                db 0dh, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h
                                db 06h, 06h, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h
                                db 06h, 06h, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h
                                db 06h, 06h, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h
                                db 00h, 0dh, 0dh, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h
                                db 00h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h
                                db 06h, 06h, 06h, 00h, 06h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h, 00h
                                db 06h, 06h, 00h, 00h, 07h, 09h, 09h, 07h, 09h, 09h, 07h, 00h, 00h, 00h, 00h
                                db 00h, 00h, 00h, 09h, 0fh, 0bh, 0bh, 0fh, 0bh, 0bh, 0fh, 09h, 00h, 00h, 00h
                                db 00h, 00h, 00h, 0eh, 0bh, 0eh, 0eh, 0bh, 0eh, 0eh, 0bh, 0eh, 00h, 00h, 00h
                                db 00h, 00h, 00h, 0eh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0eh, 00h, 00h, 00h
                                db 00h, 00h, 00h, 00h, 09h, 00h, 00h, 00h, 00h, 00h, 09h, 00h, 00h, 00h, 00h
;
Jett_right_color_pattern   db 0fh, 0fh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                           db 0fh, 0fh, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 00h, 00h
                           db 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 00h
                           db 00h, 00h, 0fh, 0fh, 0fh, 06h, 06h, 06h, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h
                           db 00h, 00h, 0fh, 0fh, 06h, 06h, 06h, 06h, 06h, 0fh, 0fh, 0fh, 06h, 0fh, 00h
                           db 00h, 00h, 0fh, 06h, 06h, 06h, 06h, 06h, 00h, 06h, 0fh, 00h, 06h, 0fh, 00h
                           db 7eh, 00h, 0fh, 06h, 06h, 06h, 06h, 06h, 00h, 06h, 0fh, 00h, 06h, 06h, 00h
                           db 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 00h
                           db 00h, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 00h
                           db 00h, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 08h, 4eh, 4eh, 4eh, 00h
                           db 00h, 00h, 08h, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 08h, 4eh, 4eh, 4eh, 4eh, 00h
                           db 00h, 00h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 00h
                           db 00h, 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h
                           db 00h, 00h, 00h, 7eh, 7eh, 7eh, 00h, 00h, 00h, 00h, 7eh, 7eh, 7eh, 00h, 00h
                           db 00h, 00h, 00h, 7eh, 7eh, 7eh, 7eh, 00h, 00h, 00h, 7eh, 7eh, 7eh, 7eh, 00h

Jett_left_color_pattern   db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0fh, 0fh
                          db 00h, 00h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 0fh, 0fh
                          db 00h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h
                          db 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 06h, 06h, 06h, 0fh, 0fh, 0fh, 00h, 00h
                          db 00h, 0fh, 06h, 0fh, 0fh, 0fh, 06h, 06h, 06h, 06h, 06h, 0fh, 0fh, 00h, 00h
                          db 00h, 0fh, 06h, 00h, 0fh, 06h, 00h, 06h, 06h, 06h, 06h, 06h, 0fh, 00h, 00h
                          db 00h, 06h, 06h, 00h, 0fh, 06h, 00h, 06h, 06h, 06h, 06h, 06h, 0fh, 00h, 7eh
                          db 00h, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh
                          db 00h, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 00h
                          db 00h, 4eh, 4eh, 4eh, 08h, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 00h
                          db 00h, 4eh, 4eh, 4eh, 4eh, 08h, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 00h, 00h
                          db 00h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 00h, 00h
                          db 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h, 00h
                          db 00h, 00h, 7eh, 7eh, 7eh, 00h, 00h, 00h, 00h, 7eh, 7eh, 7eh, 00h, 00h, 00h
                          db 00h, 7eh, 7eh, 7eh, 7eh, 00h, 00h, 00h, 7eh, 7eh, 7eh, 7eh, 00h, 00h, 00h

Jett_back_color_pattern   db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                          db 00h, 00h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 00h, 00h, 00h
                          db 00h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 00h, 00h
                          db 00h, 00h, 0fh, 0fh, 0fh, 0fh, 07h, 07h, 07h, 0fh, 0fh, 0fh, 00h, 00h, 00h
                          db 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 07h, 07h, 07h, 0fh, 0fh, 0fh, 0fh, 00h, 00h
                          db 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 07h, 07h, 07h, 0fh, 0fh, 0fh, 0fh, 00h, 00h
                          db 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h
                          db 00h, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 00h, 00h
                          db 00h, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 7eh, 00h, 00h
                          db 00h, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 00h, 00h
                          db 00h, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 4eh, 00h, 00h
                          db 00h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 08h, 00h, 00h
                          db 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h, 00h
                          db 00h, 00h, 7eh, 7eh, 7eh, 00h, 00h, 00h, 00h, 7eh, 7eh, 7eh, 00h, 00h, 00h
                          db 00h, 00h, 7eh, 7eh, 7eh, 00h, 00h, 00h, 00h, 7eh, 7eh, 7eh, 00h, 00h, 00h
;
sage_right_color_pattern db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                         db 00h, 00h, 07h, 07h, 07h, 07h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                         db 00h, 07h, 07h, 07h, 06h, 06h, 00h, 07h, 07h, 07h, 00h, 00h, 00h, 00h, 00h
                         db 07h, 07h, 00h, 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h, 00h, 00h
                         db 07h, 00h, 00h, 07h, 07h, 07h, 07h, 07h, 0eh, 07h, 07h, 07h, 07h, 00h, 00h
                         db 07h, 00h, 00h, 07h, 07h, 07h, 0eh, 0eh, 0eh, 0eh, 07h, 07h, 07h, 00h, 00h
                         db 07h, 00h, 07h, 07h, 07h, 0eh, 0eh, 00h, 0eh, 00h, 0eh, 07h, 07h, 07h, 00h
                         db 07h, 00h, 07h, 07h, 0eh, 0eh, 0eh, 06h, 0eh, 06h, 0eh, 0eh, 0eh, 07h, 00h
                         db 07h, 00h, 07h, 07h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 07h, 00h
                         db 07h, 07h, 00h, 07h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 07h, 00h
                         db 07h, 07h, 00h, 00h, 00h, 0bh, 0bh, 0bh, 0fh, 0bh, 0bh, 0bh, 00h, 00h, 00h
                         db 00h, 07h, 07h, 00h, 0bh, 0bh, 0fh, 0bh, 0fh, 0bh, 0fh, 0bh, 0bh, 00h, 00h
                         db 00h, 07h, 07h, 00h, 0eh, 0bh, 0fh, 0fh, 0bh, 0fh, 0fh, 0bh, 0eh, 00h, 00h
                         db 00h, 07h, 07h, 00h, 0eh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0eh, 00h, 00h
                         db 00h, 00h, 00h, 00h, 00h, 00h, 06h, 06h, 00h, 06h, 06h, 00h, 00h, 00h, 00h

sage_left_color_pattern db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 07h, 07h, 07h, 07h, 00h, 00h
                        db 00h, 00h, 00h, 00h, 00h, 07h, 07h, 07h, 00h, 06h, 06h, 07h, 07h, 07h, 00h
                        db 00h, 00h, 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h, 00h, 07h, 07h
                        db 00h, 00h, 07h, 07h, 07h, 07h, 0eh, 07h, 07h, 07h, 07h, 07h, 00h, 00h, 07h
                        db 00h, 00h, 07h, 07h, 07h, 0eh, 0eh, 0eh, 0eh, 07h, 07h, 07h, 00h, 00h, 07h
                        db 00h, 07h, 07h, 07h, 0eh, 00h, 0eh, 00h, 0eh, 0eh, 07h, 07h, 07h, 00h, 07h
                        db 00h, 07h, 0eh, 0eh, 0eh, 06h, 0eh, 06h, 0eh, 0eh, 0eh, 07h, 07h, 00h, 07h
                        db 00h, 07h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 07h, 07h, 00h, 07h
                        db 00h, 07h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 07h, 00h, 07h, 07h
                        db 00h, 00h, 00h, 0bh, 0bh, 0bh, 0fh, 0bh, 0bh, 0bh, 00h, 00h, 00h, 07h, 07h
                        db 00h, 00h, 0bh, 0bh, 0fh, 0bh, 0fh, 0bh, 0fh, 0bh, 0bh, 00h, 07h, 07h, 00h
                        db 00h, 00h, 0eh, 0bh, 0fh, 0fh, 0bh, 0fh, 0fh, 0bh, 0eh, 00h, 07h, 07h, 00h
                        db 00h, 00h, 0eh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0eh, 00h, 07h, 07h, 00h
                        db 00h, 00h, 00h, 00h, 06h, 06h, 00h, 06h, 06h, 00h, 00h, 00h, 00h, 00h, 00h

sage_back_color_pattern db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                        db 00h, 00h, 07h, 07h, 07h, 07h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                        db 00h, 07h, 07h, 07h, 06h, 06h, 00h, 07h, 07h, 07h, 00h, 00h, 00h, 00h, 00h
                        db 07h, 07h, 00h, 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h, 00h, 00h
                        db 07h, 00h, 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h, 00h
                        db 07h, 00h, 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h, 00h
                        db 07h, 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h
                        db 07h, 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h
                        db 07h, 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h
                        db 07h, 07h, 00h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 07h, 00h
                        db 07h, 07h, 00h, 00h, 00h, 0bh, 0bh, 0fh, 0fh, 0fh, 0bh, 0bh, 00h, 00h, 00h
                        db 00h, 07h, 07h, 00h, 0bh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0bh, 00h, 00h
                        db 00h, 07h, 07h, 00h, 0eh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0eh, 00h, 00h
                        db 00h, 07h, 07h, 00h, 0eh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh, 0eh, 00h, 00h
                        db 00h, 00h, 00h, 00h, 00h, 00h, 06h, 06h, 00h, 06h, 06h, 00h, 00h, 00h, 00h
;
life_color_pattern db 00h,00h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,00h,00h
                    db 00h,07h,0fh,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,0fh,07h,00h
                    db 07h,0fh,0fh,0fh,07h,00h,00h,04h,04h,00h,04h,04h,00h,00h,07h,0fh,0fh,0fh,07h
                    db 07h,0fh,0fh,0fh,0fh,07h,04h,0fh,04h,04h,04h,04h,04h,07h,0fh,0fh,0fh,0fh,07h
                    db 07h,0fh,0fh,07h,0fh,0fh,04h,04h,04h,04h,04h,04h,04h,0fh,0fh,07h,0fh,0fh,07h
                    db 00h,07h,0fh,0fh,07h,0fh,04h,04h,04h,04h,04h,04h,04h,0fh,07h,0fh,0fh,07h,00h
                    db 00h,00h,07h,0fh,0fh,07h,00h,04h,04h,04h,04h,04h,00h,07h,0fh,0fh,07h,00h,00h
                    db 00h,00h,00h,07h,07h,00h,00h,00h,04h,04h,04h,00h,00h,00h,07h,07h,00h,00h,00h
                    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,04h,00h,00h,00h,00h,00h,00h,00h,00h,00h

                    
logo_color_pattern_0 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh
    db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

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
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

logo_color_pattern_2 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0fh,0fh,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

; wasd patterns
W db 08h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,08h
    db 01h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,01h
    db 01h,00h,0fh,0fh,0fh,0fh,00h,00h,00h,0fh,0fh,0fh,0fh,00h,01h
    db 01h,00h,0fh,01h,01h,0fh,00h,00h,00h,0fh,01h,01h,0fh,00h,01h
    db 01h,00h,0fh,01h,01h,0fh,00h,00h,00h,0fh,01h,01h,0fh,00h,01h
    db 01h,00h,0fh,01h,01h,0fh,00h,00h,00h,0fh,01h,01h,0fh,00h,01h
    db 01h,00h,0fh,01h,01h,0fh,0fh,0fh,0fh,0fh,01h,01h,0fh,00h,01h
    db 01h,00h,0fh,01h,01h,0fh,0fh,01h,0fh,0fh,01h,01h,0fh,00h,01h
    db 01h,00h,0fh,01h,01h,0fh,01h,01h,01h,0fh,01h,01h,0fh,00h,01h
    db 01h,00h,0fh,01h,01h,0fh,01h,01h,01h,0fh,01h,01h,0fh,00h,01h
    db 01h,00h,0fh,0fh,01h,01h,01h,0fh,01h,01h,01h,0fh,0fh,00h,01h
    db 01h,00h,00h,0fh,0fh,01h,0fh,00h,0fh,01h,0fh,0fh,00h,00h,01h
    db 01h,07h,00h,00h,0fh,0fh,0fh,00h,0fh,0fh,0fh,00h,00h,07h,01h
    db 01h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,01h
    db 08h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,08h

A db 08h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,08h
    db 01h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,01h
    db 01h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,0fh,0fh,0fh,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,0fh,00h,0fh,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,0fh,0fh,0fh,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,0fh,0fh,0fh,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,0fh,00h,0fh,01h,01h,0fh,00h,00h,01h
    db 01h,07h,00h,0fh,0fh,0fh,0fh,00h,0fh,0fh,0fh,0fh,00h,07h,01h
    db 01h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,01h
    db 08h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,08h

S db 08h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,08h
    db 01h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,01h
    db 01h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,0fh,0fh,0fh,0fh,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,0fh,0fh,0fh,0fh,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,01h
    db 01h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,01h
    db 01h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,01h
    db 08h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,08h

D db 08h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,08h
    db 01h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,01h
    db 01h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,0fh,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,0fh,0fh,0fh,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,0fh,00h,0fh,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,0fh,00h,0fh,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,0fh,0fh,0fh,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,01h,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,01h,01h,01h,01h,01h,01h,0fh,0fh,00h,00h,01h
    db 01h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,01h
    db 01h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,01h
    db 01h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,09h,01h
    db 08h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,08h

;ball patterns

Nineball_color_pattern  db 00h, 00h, 00h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 00h, 00h, 00h
                        db 00h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 00h
                        db 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h
                        db 00h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 00h
                        db 0eh, 0eh, 0eh, 0eh, 0eh, 0fh, 0fh, 0fh, 0fh, 0fh, 0eh, 0eh, 0eh, 0eh, 0eh
                        db 0eh, 0eh, 0eh, 0eh, 0fh, 0fh, 00h, 00h, 00h, 0fh, 0fh, 0eh, 0eh, 0eh, 0eh
                        db 0eh, 0eh, 0eh, 0eh, 0fh, 0fh, 00h, 0fh, 00h, 0fh, 0fh, 0eh, 0eh, 0eh, 0eh
                        db 0eh, 0eh, 0eh, 0eh, 0fh, 0fh, 00h, 00h, 00h, 0fh, 0fh, 0eh, 0eh, 0eh, 0eh
                        db 0eh, 0eh, 0eh, 0eh, 0fh, 0fh, 0fh, 0fh, 00h, 0fh, 0fh, 0eh, 0eh, 0eh, 0eh
                        db 0eh, 0eh, 0eh, 0eh, 0fh, 0fh, 00h, 00h, 00h, 0fh, 0fh, 0eh, 0eh, 0eh, 0eh
                        db 0eh, 0eh, 0eh, 0eh, 0eh, 0fh, 0fh, 0fh, 0fh, 0fh, 0eh, 0eh, 0eh, 0eh, 0eh
                        db 00h, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 0eh, 00h
                        db 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h
                        db 00h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 00h
                        db 00h, 00h, 00h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 00h, 00h, 00h
BeachBall_color_pattern db 00h, 00h, 00h, 00h, 0ah, 0ah, 0ah, 0ah, 0ah, 0ah, 0ah, 00h, 00h, 00h, 00h
                        db 00h, 00h, 00h, 0fh, 0ah, 0ah, 0ah, 0ah, 0ah, 0ah, 0ah, 0fh, 00h, 00h, 00h
                        db 00h, 00h, 0fh, 0fh, 0fh, 0ah, 0ah, 0ah, 0ah, 0ah, 0fh, 0fh, 0fh, 00h, 00h
                        db 00h, 0fh, 0fh, 0fh, 0fh, 0ah, 0ah, 0ah, 0ah, 0ah, 0fh, 0fh, 0fh, 0fh, 00h
                        db 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0ah, 0ah, 0ah, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh
                        db 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0ah, 0ah, 0ah, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh
                        db 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 08h, 08h, 08h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh
                        db 0fh, 0fh, 0fh, 04h, 04h, 04h, 08h, 0fh, 08h, 0bh, 0bh, 0bh, 0fh, 0fh, 0fh
                        db 0fh, 0fh, 04h, 04h, 04h, 04h, 08h, 08h, 08h, 0bh, 0bh, 0bh, 0bh, 0fh, 0fh
                        db 04h, 04h, 04h, 04h, 04h, 04h, 0fh, 0fh, 0fh, 0bh, 0bh, 0bh, 0bh, 0bh, 0fh
                        db 04h, 04h, 04h, 04h, 04h, 04h, 0fh, 0fh, 0fh, 0bh, 0bh, 0bh, 0bh, 0bh, 0bh
                        db 00h, 04h, 04h, 04h, 04h, 0fh, 0fh, 0fh, 0fh, 0fh, 0bh, 0bh, 0bh, 0bh, 00h
                        db 00h, 00h, 04h, 04h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0bh, 0bh, 00h, 00h
                        db 00h, 00h, 00h, 04h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0bh, 00h, 00h, 00h
                        db 00h, 00h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 00h, 00h




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

soccer_color_pattern    db 00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h
                        db 00h,00h,00h,0Fh,0Fh,07h,08h,08h,08h,07h,0Fh,0Fh,00h,00h,00h
                        db 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,07h,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h
                        db 00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h
                        db 00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,07h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h
                        db 08h,07h,0Fh,0Fh,0Fh,07h,08h,08h,08h,07h,0Fh,0Fh,0Fh,07h,08h
                        db 08h,08h,0Fh,0Fh,0Fh,08h,08h,08h,08h,08h,0Fh,0Fh,0Fh,08h,08h
                        db 08h,08h,07h,0Fh,07h,08h,08h,08h,08h,08h,07h,0Fh,07h,08h,08h
                        db 08h,08h,0Fh,0Fh,0Fh,08h,08h,08h,08h,08h,0Fh,0Fh,0Fh,08h,08h
                        db 08h,07h,0Fh,0Fh,0Fh,07h,08h,08h,08h,07h,0Fh,0Fh,0Fh,07h,08h
                        db 00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,07h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h
                        db 00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h
                        db 00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,07h,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h
                        db 00h,00h,00h,0Fh,0Fh,07h,08h,08h,08h,07h,0Fh,0Fh,00h,00h,00h
                        db 00h,00h,00h,00h,00h,08h,08h,08h,08h,08h,00h,00h,00h,00h,00h
basketball_color_pattern db 00h,00h,00h,00h,00h,06h,06h,08h,06h,06h,00h,00h,00h,00h,00h
                         db 00h,00h,00h,06h,06h,06h,06h,08h,06h,06h,06h,06h,00h,00h,00h
                         db 00h,00h,08h,08h,06h,06h,06h,08h,06h,06h,06h,08h,08h,00h,00h
                         db 00h,06h,06h,08h,08h,06h,06h,08h,06h,06h,08h,08h,06h,06h,00h
                         db 00h,06h,06h,06h,08h,08h,08h,08h,08h,08h,08h,06h,06h,06h,00h
                         db 06h,06h,06h,06h,06h,06h,06h,08h,06h,06h,06h,06h,06h,06h,06h
                         db 06h,06h,06h,06h,06h,06h,06h,08h,06h,06h,06h,06h,06h,06h,06h
                         db 08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h,08h
                         db 06h,06h,06h,06h,06h,06h,06h,08h,06h,06h,06h,06h,06h,06h,06h
                         db 06h,06h,06h,06h,06h,06h,06h,08h,06h,06h,06h,06h,06h,06h,06h
                         db 00h,06h,06h,06h,08h,08h,08h,08h,08h,08h,08h,06h,06h,06h,00h
                         db 00h,06h,06h,08h,08h,06h,06h,08h,06h,06h,08h,08h,06h,06h,00h
                         db 00h,00h,08h,08h,06h,06h,06h,08h,06h,06h,06h,08h,08h,00h,00h
                         db 00h,00h,00h,06h,06h,06h,06h,08h,06h,06h,06h,06h,00h,00h,00h
                         db 00h,00h,00h,00h,00h,06h,06h,08h,06h,06h,00h,00h,00h,00h,00h

baseball_color_pattern  db 00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h
                        db 00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h
                        db 00h,00h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,00h,00h
                        db 00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h
                        db 00h,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,00h
                        db 0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                        db 0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh
                        db 0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                        db 0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,0fh,0fh
                        db 0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                        db 00h,0fh,0fh,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,0fh,0fh,00h
                        db 00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h
                        db 00h,00h,04h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,04h,00h,00h
                        db 00h,00h,00h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,00h,00h,00h
                        db 00h,00h,00h,00h,00h,0fh,0fh,0fh,0fh,0fh,00h,00h,00h,00h,00h



Snowflake_color_pattern db 00h,00h,00h,00h,00h,00h,0Bh,00h,0Bh,00h,00h,00h,00h,00h,00h
                        db 00h,00h,00h,00h,00h,00h,00h,0Bh,00h,00h,00h,00h,00h,00h,00h
                        db 00h,00h,00h,0Bh,00h,00h,00h,0Bh,00h,00h,00h,0Bh,00h,00h,00h
                        db 00h,00h,0Bh,0Bh,00h,00h,0Bh,0Bh,0Bh,00h,00h,0Bh,0Bh,00h,00h
                        db 00h,00h,00h,00h,0Bh,00h,0Bh,00h,0Bh,00h,0Bh,00h,00h,00h,00h
                        db 00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h
                        db 0Bh,00h,00h,0Bh,0Bh,0Bh,00h,0Bh,00h,0Bh,0Bh,0Bh,00h,00h,0Bh
                        db 00h,0Bh,0Bh,0Bh,00h,0Bh,0Bh,00h,0Bh,0Bh,00h,0Bh,0Bh,0Bh,00h
                        db 0Bh,00h,00h,0Bh,0Bh,0Bh,00h,0Bh,00h,0Bh,0Bh,0Bh,00h,00h,0Bh
                        db 00h,00h,00h,00h,00h,0Bh,0Bh,0Bh,0Bh,0Bh,00h,00h,00h,00h,00h
                        db 00h,00h,00h,00h,0Bh,00h,0Bh,00h,0Bh,00h,0Bh,00h,00h,00h,00h
                        db 00h,00h,0Bh,0Bh,00h,00h,0Bh,0Bh,0Bh,00h,00h,0Bh,0Bh,00h,00h
                        db 00h,00h,00h,0Bh,00h,00h,00h,0Bh,00h,00h,00h,0Bh,00h,00h,00h
                        db 00h,00h,00h,00h,00h,00h,00h,0Bh,00h,00h,00h,00h,00h,00h,00h
                        db 00h,00h,00h,00h,00h,00h,0Bh,00h,0Bh,00h,00h,00h,00h,00h,00h
;
redorb_color_pattern db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,0Ch,0Fh,0Ch,0Ch,04h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,0Fh,0Ch,0Ch,0Ch,0Ch,04h,04h,00h,00h,00h,00h
    db 00h,00h,00h,0Fh,0Fh,0Ch,0Ch,0Ch,04h,04h,04h,04h,00h,00h,00h
    db 00h,00h,00h,0Fh,0Ch,0Ch,0Ch,0Ch,04h,04h,04h,04h,00h,00h,00h
    db 00h,00h,00h,0Ch,0Ch,0Ch,0Ch,04h,04h,04h,04h,04h,00h,00h,00h
    db 00h,00h,00h,0Ch,0Ch,04h,04h,04h,04h,04h,04h,04h,00h,00h,00h
    db 00h,00h,00h,04h,04h,04h,04h,04h,04h,04h,04h,04h,00h,00h,00h
    db 00h,00h,00h,00h,04h,04h,04h,04h,04h,04h,04h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,04h,04h,04h,04h,04h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

greenorb_color_pattern db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Ah,0Fh,0Ah,0Ah,02h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,0Fh,0Ah,0Ah,0Ah,0Ah,02h,02h,00h,00h,00h,00h
      db 00h,00h,00h,0Fh,0Fh,0Ah,0Ah,0Ah,02h,02h,02h,02h,00h,00h,00h
      db 00h,00h,00h,0Fh,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,00h,00h,00h
      db 00h,00h,00h,0Ah,0Ah,0Ah,0Ah,02h,02h,02h,02h,02h,00h,00h,00h
      db 00h,00h,00h,0Ah,0Ah,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h
      db 00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h
      db 00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

yelloworb_color_pattern db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0fh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,0fh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h
      db 00h,00h,00h,0fh,0fh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
      db 00h,00h,00h,0fh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
      db 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
      db 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
      db 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h
      db 00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

      ; titles
selectcharacter_color_pattern_0 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
      db 00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

selectcharacter_color_pattern_1 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

selectcharacter_color_pattern_2 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

selectcharacter_color_pattern_3 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h



      youwin_color_pattern_0 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

youwin_color_pattern_1 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

youwin_color_pattern_2 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

youwin_color_pattern_3 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h


      leaderboard_color_pattern_0 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh
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

leaderboard_color_pattern_1 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
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

leaderboard_color_pattern_2 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h
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

leaderboard_color_pattern_3 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
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


      gameover_color_pattern_0 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

gameover_color_pattern_1 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

gameover_color_pattern_2 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

gameover_color_pattern_3 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h

howtoplay_color_pattern_0 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h
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

howtoplay_color_pattern_1 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 00h,00h,00h,0Fh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h
      db 00h,00h,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
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

howtoplay_color_pattern_2 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh
      db 0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,0Eh,0Eh,0Eh
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

howtoplay_color_pattern_3 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
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
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
      db 0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h
      db 0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0Eh,0Eh,0Eh,0Eh,0Eh,0Fh,00h,00h
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

; logo size
    poppedValues db 10 dup(?)
    logo_width dw 48
    logo_height dw 46
    ;   logo coordinates
    logo_x dw 45
    logo_y dw 40

    ;   player size
    player_size dw 0Fh  ; size of player = 15
    player_velocity dw 16 ; speed is 16
    player_life dw 0  ; starting hp
    
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

    extra1_flag db 0    
    extra3_flag db 0    
    extra5_flag db 0    
    extra7_flag db 0    
    extra10_flag db 0  
    extra12_flag db 0   
    extra14_flag db 0   
    extra16_flag db 0   

    ; file mngment
    file_name db 'lddata.txt', 0
    file_handle dw ?
    leaderboard_scores db 00h, 6*50 dup (0)
    user_name db 'JSN$'
    input_score db 000h, 010h
    string_buffer db 4 dup(?)
    score_buffer db 00h

    prompt_name db 'Enter your name (3 Characters)'
    prompt_name_1 equ $-prompt_name
    
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
        cmp al, 'C'
        JE Character_Select
        cmp al, 'c'
        JE Character_Select
        cmp al, 'U'
        JE Open_More_Info
        cmp al, 'u'
        JE Open_More_Info
        cmp al, 'L'
        JE Open_Leaderboard
        cmp al, 'l'
        JE Open_Leaderboard
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
    
    Character_Select:
        call Select_Character_Screen

    Open_More_Info:
        call display_more_info
        jmp Start

    Open_Leaderboard:
        call display_leaderboard
        jmp Start

    Back: 
        call clear_screen
        jmp Start

    Stop:
        call clear_screen
        call exit_program
    
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
        call display_game_hud
        call drawBorder
        call draw_life
        call draw_life
        call draw_life

        call Set_Skin

        mov si, offset playerRight_color_pattern
        mov di, offset playerCurrent_color_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb             ; Copy bytes from DS:SI to ES:DI

        call drawPlayer    ; drawPlayer at center
        
    Check_Time:         ;   infinite tix++ loop, increments tix per cycle
        mov ah, 2Ch         ;   Set configuration for getting time
        int 21h             ;   CH = hour, CL = minute, DH = second, DL = 1/100 seconds
        cmp dl, time_aux
        JE Check_Time       
        mov time_aux, dl    ;   update time
        ;   Start of game ticks below
        call check_enemy_collision_player
        call check_extra_collision_player
        
        call drawPlayer
        
        call move_player    ;   Get key press and execute movement, if no key press return early
        call display_score
        inc time_tix   ; 0 start   
        inc time_enemy_speed    ; 0 start
        inc score_delay_tix     ; 0 start

        mov bx, enemy_tick_speed
        cmp time_enemy_speed, bx        ;   Enemy moves every 10 tix
        JNE Next_Tix
            
            Check_Level1:
                cmp game_level, 1
                JNE Check_Level2
                    call move_level1

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
        cmp time_tix, 22            ;   seconds timer, 20 tix is approx 1 second
        JNE dont_decrement_seconds  ;   every 20 tix, decrement second 

        
        call countdown              ; display decrementing countdown
        
        
        ;   if immune_seconds == 0,  jump to immune_next, else, decrement by 1 per second
        cmp immune_seconds, 0
        JE immune_next

            dec immune_seconds
            cmp immune_seconds, 0   ;   cmp again if immune_seconds is now 0, set skin to right face
                JNE immune_next

                mov si, offset playerRight_color_pattern
                mov di, offset playerCurrent_color_pattern
                mov cx, 225          ; Number of bytes to copy
                rep movsb             ; Copy bytes from DS:SI to ES:DI

                call drawPlayer
            

        immune_next:
        mov time_tix, 0             ;   reset tix to 0
        dec time_seconds
        dont_decrement_seconds:

        mov bx, Score_Increment_Speed
        cmp score_delay_tix, bx
        JNE dont_display_Score
            add player_score, 5
    
            mov score_delay_tix, 0
        dont_display_Score:
        
        JMP Check_Time

        exit_game_over:
            call game_over

    ret
Main endp                   ;   endp is End Procedure (End Function)
; ------------------------------------------------------------------------------
;   End of Main Function
; ------------------------------------------------------------------------------

Set_Skin proc near
    ;   Set skin to default skin
    cmp skin_select, 1
    JE Skin1_Right
    cmp skin_select, 2
    JE Skin2_Right
    cmp skin_select, 3
    JE Skin3_Right
    cmp skin_select, 4
    JE Skin4_Right
    cmp skin_select, 5
    JE Skin5_Right

    call exit_program

    Skin1_Right:
    mov si, offset playerKnightR_pattern
    jmp Set_Right_Skin

    Skin2_Right:
    mov si, offset little_girl_right_color_pattern
    jmp Set_Right_Skin

    Skin3_Right:
    mov si, offset Jett_right_color_pattern
    jmp Set_Right_Skin

    Skin4_Right:
    mov si, offset sage_right_color_pattern
    jmp Set_Right_Skin

    Skin5_Right:
    mov si, offset jgirl_right_color_pattern
    jmp Set_Right_Skin

    Set_Right_Skin:
    mov di, offset playerRight_color_pattern
    mov cx, 225          ; Number of bytes to copy
    rep movsb             ; Copy bytes from DS:SI to ES:DI

    cmp skin_select, 1
    JE Skin1_Left
    cmp skin_select, 2
    JE Skin2_Left
    cmp skin_select, 3
    JE Skin3_Left
    cmp skin_select, 4
    JE Skin4_Left
    cmp skin_select, 5
    JE Skin5_Left

    call exit_program

    Skin1_Left:
    mov si, offset playerKnightL_pattern
    jmp Set_Left_Skin

    Skin2_Left:
    mov si, offset little_girl_Left_color_pattern
    jmp Set_Left_Skin

    Skin3_Left:
    mov si, offset Jett_Left_color_pattern
    jmp Set_Left_Skin

    Skin4_Left:
    mov si, offset sage_left_color_pattern
    jmp Set_Left_Skin

    Skin5_Left:
    mov si, offset jgirl_left_color_pattern
    jmp Set_Left_Skin

    Set_Left_Skin:
    mov di, offset playerLeft_color_pattern
    mov cx, 225          ; Number of bytes to copy
    rep movsb             ; Copy bytes from DS:SI to ES:DI

    cmp skin_select, 1
    JE Skin1_Up
    cmp skin_select, 2
    JE Skin2_Up
    cmp skin_select, 3
    JE Skin3_Up
    cmp skin_select, 4
    JE Skin4_Up
    cmp skin_select, 5
    JE Skin5_Up

    call exit_program

    Skin1_Up:
    mov si, offset playerKnightU_pattern
    jmp Set_Up_Skin

    Skin2_Up:
    mov si, offset little_girl_back_color_pattern
    jmp Set_Up_Skin

    Skin3_Up:
    mov si, offset Jett_back_color_pattern
    jmp Set_Up_Skin

    Skin4_Up:
    mov si, offset sage_back_color_pattern
    jmp Set_Up_Skin

    Skin5_Up:
    mov si, offset jgirl_back_color_pattern
    jmp Set_Up_Skin

    Set_Up_Skin:
    mov di, offset playerUp_color_pattern
    mov cx, 225          ; Number of bytes to copy
    rep movsb             ; Copy bytes from DS:SI to ES:DI


    ret
Set_Skin endp

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
        jne dont_check_collision_up    ;   replaced je due to out of bounds
        jmp check_collision         ;   jump has unlimited range

        dont_check_collision_up:
        sub player_y, ax
        
        cmp immune_seconds, 0
        JNE move_up_next

        mov si, offset playerUp_color_pattern
        mov di, offset playerCurrent_color_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb             ; Copy bytes from DS:SI to ES:DI

        move_up_next:
        jmp move_next

    Move_Player_Down:
        mov ax, player_velocity
        cmp player_y, 156
        je check_collision
        add player_y, ax
        
        cmp immune_seconds, 0
        JNE move_down_next

        mov si, offset playerRight_color_pattern
        mov di, offset playerCurrent_color_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb             ; Copy bytes from DS:SI to ES:DI

        move_down_next:
        jmp move_next

    Move_Player_Left:
        mov ax, player_velocity
        cmp player_x, 24
        je check_collision
        SUB player_x, ax

        cmp immune_seconds, 0
        JNE move_left_next
        
        mov si, offset playerLeft_color_pattern
        mov di, offset playerCurrent_color_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb             ; Copy bytes from DS:SI to ES:DI

        move_left_next:
        jmp move_next

    Move_Player_Right:
        mov ax, player_velocity
        cmp player_x, 280
        je check_collision
        add player_x, ax

        cmp immune_seconds, 0
        JNE move_right_next
        
        mov si, offset playerRight_color_pattern
        mov di, offset playerCurrent_color_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb             ; Copy bytes from DS:SI to ES:DI

        move_right_next:
        jmp move_next

    check_collision:
        call border_collision
        cmp immune_seconds, 0
        JNE dont_immune_player1
        mov immune_seconds, 2

        dont_immune_player1:
        mov si, offset playerinvincible_color_pattern
        mov di, offset playerCurrent_color_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb

    move_next:

        call drawPlayer
        call erasePlayer

    stop_move:
        ret

move_player endp

display_choose_level proc near
    call clear_screen
    ; Back prompt
    mov ax, 1300h
    mov dh, 22              ;   y
    mov dl, 02              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_back_1  ;   msg length
    lea bp, message_back    ;   msg
    int 10h

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
      ;   call 3 times to draw 3 life, every call increments by 23px x position    
    

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

display_menu proc near
    call clear_screen
    call menu_drawTopBorder
    call menu_drawBottomBorder
    call draw_logo
    call Draw_Main_Menu_Ball

    ; Display Start Prompt
    mov ax, 1300h           ;   set configuration to ah 13h, al 01h
    mov dh, 14              ;   y
    mov dl, 07              ;   x
    mov bx, 000Ah           ;   bh = page , bl = color
    mov cx, message_start_1 ;   msg length
    lea bp, message_start   ;   msg
    int 10h
    
    ; Display Information Prompt
    mov dh, 16              ;   y
    mov dl, 07              ;   x
    mov bx, 0009h           ;   page + color
    mov cx, message_info_1  ;   msg length
    lea bp, message_info    ;   msg 
    int 10h

    ; Display Extras Prompt
    mov dh, 18              ;   y
    mov dl, 07              ;   x
    mov bx, 000Ch           ;   page + color
    mov cx, message_leaderboard_1 ;   msg length
    lea bp, message_leaderboard   ;   msg 
    int 10h

    ; CS
    mov dh, 20              ;   y
    mov dl, 07              ;   x
    mov bx, 000Dh           ;   page+color
    mov cx, message_character_select1  ;   msg length
    lea bp, message_character_select    ;   msg
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
draw_life proc near
        inc player_life
        add life1_x, 23

        mov cx, life1_x ; CX = X, set initial x coordinates 
        mov dx, life1_y ; DX = Y, set initial y coordinates
        mov si, offset life_color_pattern

    Draw_Life_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel                000000000
        mov al, [si] ;color                               000000000
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, life1_x ; x
        cmp ax, life_width     ;  ZF is -7 on first run 
        JNE Draw_Life_Horizontal  ; (ax != player_size)
        mov cx, life1_x ; x
        inc dx
        mov ax, dx
        sub ax, life1_y ; y
        cmp ax, life_height
        jne Draw_Life_Horizontal    
   
    ret
draw_life endp

erase_life proc near
        
        mov cx, life1_x ; CX = X, set initial x coordinates 
        mov dx, life1_y ; DX = Y, set initial y coordinates

    Erase_Life_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel            
        mov al, 00h                           
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, life1_x ; x
        cmp ax, life_width     ;  ZF is -7 on first run 
        JNE Erase_Life_Horizontal  ; (ax != player_size)
        mov cx, life1_x ; x
        inc dx
        mov ax, dx
        sub ax, life1_y ; y
        cmp ax, life_height
        jne Erase_Life_Horizontal
    sub life1_x, 23       
    ret
erase_life endp

move_extra1 proc near
    cmp extra1_flag, 1
    JE next_move_extra1
    ret

    next_move_extra1:

    add extra1_x, 16
    call erase_extra1
    cmp extra1_x, 296
    JE reset_extra1

    call draw_extra1
    ret

    reset_extra1:
    mov extra1_x, 08
    mov extra1_x_prev, 24
    mov extra1_flag, 0
    ret

move_extra1 endp

draw_extra1 proc near
    mov cx, extra1_x ; CX = X, set initial x coordinates 
    mov dx, extra1_y ; DX = Y, set initial y coordinates
    mov si, offset greenorb_color_pattern
    mov extra1_x_prev, cx
    Draw_extra1_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, extra1_x
        cmp ax, player_size         ;   15
        JNE Draw_extra1_Horizontal
        mov cx, extra1_x
        inc dx
        mov ax, dx
        sub ax, extra1_y
        cmp ax, player_size
        jne Draw_extra1_Horizontal        
    ret
draw_extra1 endp
erase_extra1 proc near 
    mov cx, extra1_x_prev ; CX = X, set initial x coordinates 
    mov dx, extra1_y ; DX = Y, set initial y coordinates

    Erase_extra1_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 00h ;color black
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, extra1_x_prev
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Erase_extra1_Horizontal  ; !(ax > player_size)
        mov cx, extra1_x_prev
        inc dx
        mov ax, dx
        sub ax, extra1_y
        cmp ax, player_size
        jne Erase_extra1_Horizontal        
    ret
erase_extra1 endp

move_extra3 proc near
    cmp extra3_flag, 1
    je next_move_extra3
    ret

    next_move_extra3:

    add extra3_x, 16
    call erase_extra3
    cmp extra3_x, 296
    je reset_extra3

    call draw_extra3
    ret

    reset_extra3:
    mov extra3_x, 08
    mov extra3_x_prev, 24
    mov extra3_flag, 0
    ret
move_extra3 endp

draw_extra3 proc near
    mov cx, extra3_x
    mov dx, extra3_y
    mov si, offset greenorb_color_pattern
    mov extra3_x_prev, cx
    Draw_extra3_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, extra3_x
        cmp ax, player_size
        jne Draw_extra3_Horizontal
        mov cx, extra3_x
        inc dx
        mov ax, dx
        sub ax, extra3_y
        cmp ax, player_size
        jne Draw_extra3_Horizontal        
    ret
draw_extra3 endp

erase_extra3 proc near 
    mov cx, extra3_x_prev
    mov dx, extra3_y
    Erase_extra3_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, extra3_x_prev
        cmp ax, player_size
        jne Erase_extra3_Horizontal
        mov cx, extra3_x_prev
        inc dx
        mov ax, dx
        sub ax, extra3_y
        cmp ax, player_size
        jne Erase_extra3_Horizontal        
    ret
erase_extra3 endp

move_extra5 proc near
    cmp extra5_flag, 1
    je next_move_extra5
    ret

    next_move_extra5:

    add extra5_x, 16
    call erase_extra5
    cmp extra5_x, 296
    je reset_extra5

    call draw_extra5
    ret

    reset_extra5:
    mov extra5_x, 08
    mov extra5_x_prev, 24
    mov extra5_flag, 0
    ret
move_extra5 endp

draw_extra5 proc near
    mov cx, extra5_x
    mov dx, extra5_y
    mov si, offset greenorb_color_pattern
    mov extra5_x_prev, cx
    Draw_extra5_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, extra5_x
        cmp ax, player_size
        jne Draw_extra5_Horizontal
        mov cx, extra5_x
        inc dx
        mov ax, dx
        sub ax, extra5_y
        cmp ax, player_size
        jne Draw_extra5_Horizontal        
    ret
draw_extra5 endp

erase_extra5 proc near 
    mov cx, extra5_x_prev
    mov dx, extra5_y
    Erase_extra5_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, extra5_x_prev
        cmp ax, player_size
        jne Erase_extra5_Horizontal
        mov cx, extra5_x_prev
        inc dx
        mov ax, dx
        sub ax, extra5_y
        cmp ax, player_size
        jne Erase_extra5_Horizontal        
    ret
erase_extra5 endp

move_extra7 proc near
    cmp extra7_flag, 1
    je next_move_extra7
    ret

    next_move_extra7:

    add extra7_x, 16
    call erase_extra7
    cmp extra7_x, 296
    je reset_extra7

    call draw_extra7
    ret

    reset_extra7:
    mov extra7_x, 08
    mov extra7_x_prev, 24
    mov extra7_flag, 0
    ret
move_extra7 endp

draw_extra7 proc near
    mov cx, extra7_x
    mov dx, extra7_y
    mov si, offset greenorb_color_pattern
    mov extra7_x_prev, cx
    Draw_extra7_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, extra7_x
        cmp ax, player_size
        jne Draw_extra7_Horizontal
        mov cx, extra7_x
        inc dx
        mov ax, dx
        sub ax, extra7_y
        cmp ax, player_size
        jne Draw_extra7_Horizontal        
    ret
draw_extra7 endp

erase_extra7 proc near 
    mov cx, extra7_x_prev
    mov dx, extra7_y
    Erase_extra7_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, extra7_x_prev
        cmp ax, player_size
        jne Erase_extra7_Horizontal
        mov cx, extra7_x_prev
        inc dx
        mov ax, dx
        sub ax, extra7_y
        cmp ax, player_size
        jne Erase_extra7_Horizontal        
    ret
erase_extra7 endp


move_extra10 proc near
    cmp extra10_flag, 1
    JE next_move_extra10
    ret

    next_move_extra10:

    sub extra10_x, 16
    call erase_extra10
    cmp extra10_x, 08
    JE reset_extra10

    call draw_extra10
    ret

    reset_extra10:
    mov extra10_x, 296
    mov extra10_x_prev, 280
    mov extra10_flag, 0
    ret
move_extra10 endp

draw_extra10 proc near
    mov cx, extra10_x ; CX = X, set initial x coordinates 
    mov dx, extra10_y ; DX = Y, set initial y coordinates
    mov si, offset yelloworb_color_pattern
    mov extra10_x_prev, cx
    Draw_extra10_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, extra10_x
        cmp ax, player_size         ;   15
        JNE Draw_extra10_Horizontal
        mov cx, extra10_x
        inc dx
        mov ax, dx
        sub ax, extra10_y
        cmp ax, player_size
        jne Draw_extra10_Horizontal        
    ret
draw_extra10 endp

erase_extra10 proc near 
    mov cx, extra10_x_prev ; CX = X, set initial x coordinates 
    mov dx, extra10_y ; DX = Y, set initial y coordinates

    Erase_extra10_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 00h ;color black
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc cx  ; initial is cx ++, 161 0000 0000 
        mov ax, cx
        sub ax, extra10_x_prev
        cmp ax, player_size      ;  ZF is -7 on first run 
        JNE Erase_extra10_Horizontal  ; !(ax > player_size)
        mov cx, extra10_x_prev
        inc dx
        mov ax, dx
        sub ax, extra10_y
        cmp ax, player_size
        jne Erase_extra10_Horizontal        
    ret
erase_extra10 endp

move_extra12 proc near
    cmp extra12_flag, 1
    JE next_move_extra12
    ret

    next_move_extra12:
    sub extra12_x, 16
    call erase_extra12
    cmp extra12_x, 08
    JE reset_extra12

    call draw_extra12
    ret

    reset_extra12:
    mov extra12_x, 296
    mov extra12_x_prev, 280
    mov extra12_flag, 0
    ret
move_extra12 endp

draw_extra12 proc near
    mov cx, extra12_x
    mov dx, extra12_y
    mov si, offset greenorb_color_pattern
    mov extra12_x_prev, cx
    Draw_extra12_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, extra12_x
        cmp ax, player_size
        JNE Draw_extra12_Horizontal
        mov cx, extra12_x
        inc dx
        mov ax, dx
        sub ax, extra12_y
        cmp ax, player_size
        jne Draw_extra12_Horizontal        
    ret
draw_extra12 endp

erase_extra12 proc near 
    mov cx, extra12_x_prev
    mov dx, extra12_y

    Erase_extra12_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, extra12_x_prev
        cmp ax, player_size
        JNE Erase_extra12_Horizontal
        mov cx, extra12_x_prev
        inc dx
        mov ax, dx
        sub ax, extra12_y
        cmp ax, player_size
        jne Erase_extra12_Horizontal        
    ret
erase_extra12 endp


move_extra14 proc near
    cmp extra14_flag, 1
    JE next_move_extra14
    ret

    next_move_extra14:
    sub extra14_x, 16
    call erase_extra14
    cmp extra14_x, 08
    JE reset_extra14

    call draw_extra14
    ret

    reset_extra14:
    mov extra14_x, 296
    mov extra14_x_prev, 280
    mov extra14_flag, 0
    ret
move_extra14 endp

draw_extra14 proc near
    mov cx, extra14_x
    mov dx, extra14_y
    mov si, offset greenorb_color_pattern
    mov extra14_x_prev, cx
    Draw_extra14_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, extra14_x
        cmp ax, player_size
        JNE Draw_extra14_Horizontal
        mov cx, extra14_x
        inc dx
        mov ax, dx
        sub ax, extra14_y
        cmp ax, player_size
        jne Draw_extra14_Horizontal        
    ret
draw_extra14 endp

erase_extra14 proc near 
    mov cx, extra14_x_prev
    mov dx, extra14_y

    Erase_extra14_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, extra14_x_prev
        cmp ax, player_size
        JNE Erase_extra14_Horizontal
        mov cx, extra14_x_prev
        inc dx
        mov ax, dx
        sub ax, extra14_y
        cmp ax, player_size
        jne Erase_extra14_Horizontal        
    ret
erase_extra14 endp

move_extra16 proc near
    cmp extra16_flag, 1
    JE next_move_extra16
    ret

    next_move_extra16:
    sub extra16_x, 16
    call erase_extra16
    cmp extra16_x, 08
    JE reset_extra16

    call draw_extra16
    ret

    reset_extra16:
    mov extra16_x, 296
    mov extra16_x_prev, 280
    mov extra16_flag, 0
    ret
move_extra16 endp

draw_extra16 proc near
    mov cx, extra16_x
    mov dx, extra16_y
    mov si, offset redorb_color_pattern
    mov extra16_x_prev, cx
    Draw_extra16_Horizontal:
        mov ah, 0Ch
        mov al, [si]
        mov bh, 00h
        int 10h
        inc si
        inc cx
        mov ax, cx
        sub ax, extra16_x
        cmp ax, player_size
        JNE Draw_extra16_Horizontal
        mov cx, extra16_x
        inc dx
        mov ax, dx
        sub ax, extra16_y
        cmp ax, player_size
        jne Draw_extra16_Horizontal        
    ret
draw_extra16 endp

erase_extra16 proc near 
    mov cx, extra16_x_prev
    mov dx, extra16_y

    Erase_extra16_Horizontal:
        mov ah, 0Ch
        mov al, 00h
        mov bh, 00h
        int 10h
        inc cx
        mov ax, cx
        sub ax, extra16_x_prev
        cmp ax, player_size
        JNE Erase_extra16_Horizontal
        mov cx, extra16_x_prev
        inc dx
        mov ax, dx
        sub ax, extra16_y
        cmp ax, player_size
        jne Erase_extra16_Horizontal        
    ret
erase_extra16 endp

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
    mov si, offset Nineball_color_pattern
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
    mov si, offset BeachBall_color_pattern
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
    mov si, offset BeachBall_color_pattern
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
    mov si, offset volleyball_color_pattern
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
    mov si, offset soccer_color_pattern
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
    mov si, offset basketball_color_pattern
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
    mov si, offset baseball_color_pattern
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
    mov si, offset Snowflake_color_pattern
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
    mov si, offset playerCurrent_color_pattern

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
    mov dx, 13      ; DX = Y, set initial y coordinates
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
        sub ax, 13
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
    cmp player_score, 50
    JLE dont_sub_score

        sub player_score, 20

        cmp player_score, 100
        jg dont_sub_score

        mov ah, 02h
        mov dh, 03     ;y
        mov dl, 12     ;x
        int 10h   
        ; print backspace at third column
        mov ah, 09h
        mov cx, 1
        mov ah, 09h    ;   set configuration for displaying with graphics
        mov al, 20h    ;
        mov bx, 000Ah ;page+color
        int 10h

    dont_sub_score:

    cmp immune_seconds, 0
    JNE border_collision_exit;   if immune_seconds = 0, do nothing

    dec player_life
    call erase_life
    mov player_y, 92 ; update to reference centered position
    mov player_x, 152
    cmp player_life, 0
    JE collision_game_over
    ret

    collision_game_over:
        jmp exit_game_over

    border_collision_exit:
    ret

    
border_collision endp

game_over proc near
        call clear_screen
        call menu_drawBottomBorder
        call menu_drawTopBorder
        call gameover_draw_header
        call reset_variables
        ; Return to Menu Prompt
        mov ax, 1300h
        mov dh, 16              ;   y
        mov dl, 12              ;   x
        mov bx, 000Dh           ;   page+color
        mov cx, message_menu_1  ;   msg length
        lea bp, message_menu    ;   msg
        int 10h
        ;   loop for user response
        Loop_Game_Over:
            mov ah, 01h         ;   check if which key is being pressed
            int 16h             ;   ZF = 1 when there is no key press
            JZ Loop_Game_Over
        
            mov ah, 00h
            int 16h

            cmp al, 'b'
            JNE Next_Game_Over
            JMP start

            Next_Game_Over:
            cmp al, 'B'
            JNE Next_Game_Over1
            call reset_variables
            JMP start

            Next_Game_Over1:

        JMP Loop_Game_Over
    ret
game_over endp

exit_program proc near
    mov ah, 4ch ;  Set configuration to exit with return
    int 21h
    ret
exit_program endp

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

check_extra_collision_player proc near
    next_ex_collision1:
        mov ax, extra1_x
        cmp player_x, ax
        je check_ex_y1
        JNE next_ex_collision3

    check_ex_y1:
        mov ax, extra1_y
        cmp player_y, ax
        JNE next_ex_collision3

            mov extra1_flag, 0
            mov extra1_x, 08
            call drawPlayer
            jmp ex_collision_exp

    next_ex_collision3:
        mov ax, extra3_x
        cmp player_x, ax
        je check_ex_y3
        JNE next_ex_collision5

    check_ex_y3:
        mov ax, extra3_y
        cmp player_y, ax
        JNE next_ex_collision5
            mov extra3_flag, 0
            mov extra3_x, 08
            call drawPlayer
            jmp ex_collision_exp

    next_ex_collision5:
        mov ax, extra5_x
        cmp player_x, ax
        je check_ex_y5
        JNE next_ex_collision7

    check_ex_y5:
        mov ax, extra5_y
        cmp player_y, ax
        JNE next_ex_collision7
            mov extra5_flag, 0
            mov extra5_x, 08
            call drawPlayer
            jmp ex_collision_exp


    next_ex_collision7:
        mov ax, extra7_x
        cmp player_x, ax
        je check_ex_y7
        JNE next_ex_collision10

    check_ex_y7:
        mov ax, extra7_y
        cmp player_y, ax
        JNE next_ex_collision10
            mov extra7_flag, 0
            mov extra7_x, 08
            call drawPlayer
            jmp ex_collision_exp

    next_ex_collision10:
        mov ax, extra10_x
        cmp player_x, ax
        je check_ex_y10
        JNE next_ex_collision12

    check_ex_y10:
        mov ax, extra10_y
        cmp player_y, ax
        JNE next_ex_collision12
            mov extra10_flag, 0
            mov extra10_x, 296
            call drawPlayer
            jmp ex_collision_immune

    next_ex_collision12:
        mov ax, extra12_x
        cmp player_x, ax
        je check_ex_y12
        JNE next_ex_collision14

    check_ex_y12:
        mov ax, extra12_y
        cmp player_y, ax
        JNE next_ex_collision14
            mov extra12_flag, 0
            mov extra12_x, 296
            call drawPlayer
            jmp ex_collision_exp

    next_ex_collision14:
        mov ax, extra14_x
        cmp player_x, ax
        je check_ex_y14
        JNE next_ex_collision16

    check_ex_y14:
        mov ax, extra14_y
        cmp player_y, ax
        JNE next_ex_collision16
            mov extra14_flag, 0
            mov extra14_x, 296
            call drawPlayer
            jmp ex_collision_exp
        
    next_ex_collision16:
        mov ax, extra16_x
        cmp player_x, ax
        je check_ex_y16
        JNE exit_ex_collision

    check_ex_y16:
        mov ax, extra16_y
        cmp player_y, ax
        JNE exit_ex_collision
            mov extra16_flag, 0
            mov extra16_x, 296
            call drawPlayer
            jmp ex_collision_life

    exit_ex_collision:
        ret
    ex_collision_exp:
        add player_score, 15
        ret
    
    ex_collision_life:
        call draw_life
        ret

    ex_collision_immune:
        mov si, offset playerinvincible_color_pattern
        mov di, offset playerCurrent_color_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb
        call drawPlayer
        mov immune_seconds, 4
        ret

    ret
check_extra_collision_player endp

check_enemy_collision_player proc near
    cmp immune_seconds, 0
    JE next_collision1
    ret

    next_collision1:
    mov ax, enemy1_x
    cmp player_x, ax
    JE  check_y1
    JNE next_collision2
    ; Check for y pos collision
    check_y1:
    mov ax, enemy1_y
    cmp player_y, ax
    JNE next_collision2

    jmp collision_detected

    next_collision2:
        mov ax, enemy2_x
        cmp player_x, ax
        JE  check_y2
        JNE next_collision3
        ; Check for y pos collision
        check_y2:
        mov ax, enemy2_y
        cmp player_y, ax
        JNE next_collision3

        jmp collision_detected

    next_collision3:
        mov ax, enemy3_x
        cmp player_x, ax
        JE  check_y3
        JNE next_collision4
        ; Check for y pos collision
        check_y3:
        mov ax, enemy3_y
        cmp player_y, ax
        JNE next_collision4

        jmp collision_detected

    next_collision4:
        mov ax, enemy4_x
        cmp player_x, ax
        JE  check_y4
        JNE next_collision5
        ; Check for y pos collision
        check_y4:
        mov ax, enemy4_y
        cmp player_y, ax
        JNE next_collision5

        jmp collision_detected

    next_collision5:
        mov ax, enemy5_x
        cmp player_x, ax
        JE  check_y5
        JNE next_collision6
        ; Check for y pos collision
        check_y5:
        mov ax, enemy5_y
        cmp player_y, ax
        JNE next_collision6

        jmp collision_detected

    next_collision6:
        mov ax, enemy6_x
        cmp player_x, ax
        JE  check_y6
        JNE next_collision7
        ; Check for y pos collision
        check_y6:
        mov ax, enemy6_y
        cmp player_y, ax
        JNE next_collision7

        jmp collision_detected

    next_collision7:
        mov ax, enemy7_x
        cmp player_x, ax
        JE  check_y7
        JNE next_collision8
        ; Check for y pos collision
        check_y7:
        mov ax, enemy7_y
        cmp player_y, ax
        JNE next_collision8

        jmp collision_detected

    next_collision8:
        mov ax, enemy8_x
        cmp player_x, ax
        JE  check_y8
        JNE next_collision9
        ; Check for y pos collision
        check_y8:
        mov ax, enemy8_y
        cmp player_y, ax
        JNE next_collision9

        jmp collision_detected

    next_collision9:
        mov ax, enemy9_x
        cmp player_x, ax
        JE  check_y9
        JNE next_collision10
        ; Check for y pos collision
        check_y9:
        mov ax, enemy9_y
        cmp player_y, ax
        JNE next_collision10

        jmp collision_detected

    next_collision10:
        mov ax, enemy10_x
        cmp player_x, ax
        JE  check_y10
        JNE next_collision11
        ; Check for y pos collision
        check_y10:
        mov ax, enemy10_y
        cmp player_y, ax
        JNE next_collision11

        jmp collision_detected

    next_collision11:
        mov ax, enemy11_x
        cmp player_x, ax
        JE  check_y11
        JNE next_collision12
        ; Check for y pos collision
        check_y11:
        mov ax, enemy11_y
        cmp player_y, ax
        JNE next_collision12

        jmp collision_detected

    next_collision12:
        mov ax, enemy12_x
        cmp player_x, ax
        JE  check_y12
        JNE next_collision13
        ; Check for y pos collision
        check_y12:
        mov ax, enemy12_y
        cmp player_y, ax
        JNE next_collision13

        jmp collision_detected

    next_collision13:
        mov ax, enemy13_x
        cmp player_x, ax
        JE  check_y13
        JNE next_collision14
        ; Check for y pos collision
        check_y13:
        mov ax, enemy13_y
        cmp player_y, ax
        JNE next_collision14

        jmp collision_detected

    next_collision14:
        mov ax, enemy14_x
        cmp player_x, ax
        JE  check_y14
        JNE next_collision15
        ; Check for y pos collision
        check_y14:
        mov ax, enemy14_y
        cmp player_y, ax
        JNE next_collision15

        jmp collision_detected

    next_collision15:
        mov ax, enemy15_x
        cmp player_x, ax
        JE  check_y15
        JNE next_collision16
        ; Check for y pos collision
        check_y15:
        mov ax, enemy15_y
        cmp player_y, ax
        JNE next_collision16

        jmp collision_detected

    next_collision16:
        mov ax, enemy16_x
        cmp player_x, ax
        JE  check_y16
        JNE end_collision_checks
        ; Check for y pos collision
        check_y16:
        mov ax, enemy16_y
        cmp player_y, ax
        JNE end_collision_checks

    collision_detected:
        ;   set skin to immune for 2 seconds


        mov si, offset playerinvincible_color_pattern
        mov di, offset playerCurrent_color_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb  

        call border_collision

        cmp immune_seconds, 0
        JNE dont_immune_player
        mov immune_seconds, 2

        dont_immune_player:

        call drawPlayer
        ret


    end_collision_checks:
    ret
check_enemy_collision_player endp

Move_Level1 proc near

    ;   1st projectile
    cmp time_seconds, 63
    JNE lvl1_next0
        mov enemy_tick_speed, 4
        mov Score_Increment_Speed, 88
        

    lvl1_next0:             ;   set specified time on when will the projectiles spawn
    cmp time_seconds, 60
    JNE lvl1_next1
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy16_flag
        mov extra7_flag, 1

    lvl1_next1:
    cmp time_seconds, 56
    JNE lvl1_next2
        call set_enemy1_flag
        call set_enemy3_flag
        call set_enemy5_flag
        call set_enemy7_flag
        mov extra14_flag, 1
    

    lvl1_next2:
    cmp time_seconds, 52
    JNE lvl1_next3
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy6_flag
        call set_enemy15_flag

    lvl1_next3:
    cmp time_seconds, 48
    JNE lvl1_next4
        call set_enemy3_flag
        call set_enemy5_flag
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy6_flag
        call set_enemy7_flag
        call set_enemy16_flag
      
    lvl1_next4:
    cmp time_seconds, 44
    JNE lvl1_next5
        call set_enemy9_flag
        call set_enemy2_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy14_flag
        call set_enemy13_flag
        
    lvl1_next5:
    cmp time_seconds, 40
    JNE lvl1_next6
        mov enemy_tick_speed, 3
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy6_flag
        call set_enemy15_flag
        call set_enemy8_flag
        mov extra16_flag, 1
   
    lvl1_next6:
    cmp time_seconds, 37
    JNE lvl1_next7
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy13_flag
        call set_enemy14_flag
        call set_enemy15_flag 
        mov extra7_flag, 1


    lvl1_next7:
    cmp time_seconds, 33
    JNE lvl1_next8
    call set_enemy1_flag
    call set_enemy3_flag
    call set_enemy4_flag
    call set_enemy5_flag
    call set_enemy6_flag
    call set_enemy15_flag
    call set_enemy16_flag
    call set_enemy12_flag
    mov extra10_flag, 1

    lvl1_next8:
    cmp time_seconds, 29
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
    cmp time_seconds, 26
    JNE lvl1_next10
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy6_flag
        call set_enemy7_flag
       
    lvl1_next10:
    cmp time_seconds, 23
    JNE lvl1_next11
        call set_enemy1_flag
        call set_enemy4_flag
        call set_enemy6_flag
        call set_enemy16_flag
        call set_enemy12_flag
    lvl1_next11:
    cmp time_seconds, 20
    JNE lvl1_next12
        mov enemy_tick_speed, 2
        call set_enemy1_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy15_flag
        call set_enemy16_flag
        call set_enemy12_flag
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
    cmp time_seconds, 18
    JNE lvl1_next15
        
        call set_enemy11_flag
        call set_enemy12_flag
        call set_enemy5_flag
        call set_enemy6_flag
        call set_enemy7_flag
        call set_enemy8_flag
        call set_enemy16_flag
        mov extra14_flag, 1
      
    lvl1_next15:
    cmp time_seconds, 15
    JNE lvl1_next16
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy14_flag
        call set_enemy13_flag
        call set_enemy1_flag
      
    lvl1_next16:
    cmp time_seconds, 12
    JNE lvl1_next17
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy6_flag
        call set_enemy15_flag
        call set_enemy16_flag

      
    lvl1_next17:
    cmp time_seconds, 9
    JNE lvl1_next18
        call set_enemy2_flag
        call set_enemy4_flag
        call set_enemy6_flag
        call set_enemy8_flag
        call set_enemy13_flag
      
    lvl1_next18:
    cmp time_seconds, 6
    JNE lvl1_next19
        call set_enemy10_flag
        call set_enemy12_flag
        call set_enemy14_flag
        call set_enemy16_flag
        call set_enemy7_flag
      
    lvl1_next19:
    cmp time_seconds, 3
    JNE lvl1_next20
        call set_enemy9_flag
        call set_enemy10_flag
        call set_enemy11_flag
        call set_enemy4_flag
        call set_enemy13_flag
        call set_enemy14_flag
        call set_enemy15_flag
        call set_enemy7_flag
    lvl1_next20:
    cmp time_seconds, 0
    JNE lvl1_next21
        call clear_screen
        call display_victory

    lvl1_next21:

    

    move_enemies_lvl1:    
        call move_projectiles

    ret
move_level1 endp


Move_Level2 proc near
    cmp time_seconds, 63
    JNE lvl2_next0
        mov enemy_tick_speed, 3
        mov Score_Increment_Speed, 66



    lvl2_next0:             ;   set specified time on when will the projectiles spawn
    cmp time_seconds, 60
    JNE lvl2_next1
        call set_enemy2_flag
        call set_enemy12_flag
        call set_enemy9_flag
        call set_enemy15_flag
        call set_enemy16_flag
        mov extra1_flag, 1

    lvl2_next1:
    cmp time_seconds, 55
    JNE lvl2_next2
        call set_enemy14_flag
        call set_enemy7_flag
        call set_enemy3_flag
        call set_enemy8_flag
        call set_enemy10_flag
        call set_enemy13_flag

    lvl2_next2:
    cmp time_seconds, 52
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
    cmp time_seconds, 47
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
        mov extra10_flag, 1
    
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
        mov enemy_tick_speed, 3
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
    cmp time_seconds, 31
    JNE lvl2_next11
        call set_enemy1_flag
        call set_enemy9_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy6_flag
        call set_enemy7_flag
        call set_enemy8_flag
        mov extra16_flag, 1
        call set_enemy15_flag
        call set_enemy14_flag

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
        call set_enemy12_flag


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
        mov extra14_flag, 1

lvl2_next13:
    cmp time_seconds, 22
    JNE lvl2_next14
        mov enemy_tick_speed, 2
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
        mov extra14_flag, 1

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
        mov extra16_flag, 1

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
    cmp time_seconds, 6
    JNE lvl2_next21
        mov enemy_tick_speed, 3
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
        mov extra1_flag, 1
    lvl2_next23:
    cmp time_seconds, 0
    JNE lvl2_next24
        call clear_screen
        call display_victory

    lvl2_next24:

    move_enemies_lvl2:    
        call move_projectiles

        
    ret
Move_Level2 endp


Move_Level3 proc near

    cmp time_seconds, 63
    JNE lvl3_next0
        mov enemy_tick_speed, 3
        mov Score_Increment_Speed, 44

    lvl3_next0:             
    cmp time_seconds, 60
    JNE lvl3_next1
        call set_enemy1_flag
        call set_enemy2_flag
        call set_enemy3_flag
        call set_enemy4_flag
        call set_enemy5_flag
        call set_enemy15_flag
        mov extra16_flag, 1


    lvl3_next1:
    cmp time_seconds, 57
    JNE lvl3_next2
        mov enemy_tick_speed, 2
        call set_enemy16_flag
        call set_enemy15_flag
        call set_enemy14_flag
        call set_enemy13_flag
        call set_enemy12_flag
        call set_enemy2_flag
        call set_enemy1_flag

    lvl3_next2:
    cmp time_seconds, 54
    JNE lvl3_next3
        call set_enemy9_flag
        call set_enemy10_flag
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
        mov extra10_flag, 1
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
        mov extra1_flag, 1
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
        mov extra3_flag, 1
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
        call set_enemy1_flag
        mov extra10_flag, 1

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
        call set_enemy7_flag

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
        mov extra7_flag, 1
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

    cmp time_seconds, 0
    JNE lvl3_next24
        call clear_screen
        call display_victory

    lvl3_next24:

    move_enemies_lvl3:    
        call move_projectiles

    ret
Move_Level3 endp

move_projectiles proc near
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
        call move_extra1
        call move_extra3
        call move_extra5
        call move_extra7
        call move_extra10
        call move_extra12
        call move_extra14
        call move_extra16
        ret
move_projectiles endp

reset_variables proc near
    ;   clear the stack of pushed values on dx reg


    mov Score_Increment_Speed, 44
    mov score_delay_tix, 0
    mov game_level, 0
    mov time_aux, 0
    mov time_tix, 0
    mov time_enemy_speed, 0 
    mov score_delay_tix, 0
    mov immune_seconds, 0
    mov player_score, 0
    
    mov player_x, 152 
    mov player_y, 92 
    mov prev_x, 152
    mov prev_y, 92
    mov time_seconds, 63
    mov player_life, 0
    mov life1_x, 52
    mov life1_y, 183

    mov enemy1_flag, 0    ;   0 = false, 1 = true
    mov enemy3_flag, 0    ;   0 = false, 1 = true
    mov enemy2_flag, 0    ;
    mov enemy4_flag, 0
    mov enemy5_flag, 0    ;   0 = false, 1 = true
    mov enemy6_flag, 0    ;
    mov enemy7_flag, 0    ;   0 = false, 1 = true
    mov enemy8_flag, 0
    mov enemy9_flag, 0    ;   0 = false, 1 = true
    mov enemy10_flag, 0    ;   0 = false, 1 = true
    mov enemy11_flag, 0    ;
    mov enemy12_flag, 0
    mov enemy13_flag, 0    ;   0 = false, 1 = true
    mov enemy14_flag, 0    ;
    mov enemy15_flag, 0    ;   0 = false, 1 = true
    mov enemy16_flag, 0

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

    mov enemy9_x, 296
    mov enemy9_y, 44
    mov enemy9_x_prev, 280

    mov enemy10_x, 296
    mov enemy10_y, 60
    mov enemy10_x_prev, 280

    mov enemy11_x, 296
    mov enemy11_y, 76
    mov enemy11_x_prev, 280

    mov enemy12_x, 296
    mov enemy12_y, 92
    mov enemy12_x_prev, 280

    mov enemy13_x, 296
    mov enemy13_y, 108
    mov enemy13_x_prev, 280

    mov enemy14_x, 296
    mov enemy14_y, 124
    mov enemy14_x_prev, 280

    mov enemy15_x, 296
    mov enemy15_y, 140
    mov enemy15_x_prev, 280

    mov enemy16_x, 296
    mov enemy16_y, 156
    mov enemy16_x_prev, 280

    mov extra1_flag, 0    ;   0 = false, 1 = true
    mov extra3_flag, 0    ;   0 = false, 1 = true
    mov extra5_flag, 0    ;   0 = false, 1 = true
    mov extra7_flag, 0    ;   0 = false, 1 = true
    mov extra10_flag, 0
    mov extra12_flag, 0    ;   0 = false, 1 = true
    mov extra14_flag, 0    ;   0 = false, 1 = true
    mov extra16_flag, 0

    mov extra1_x, 08
    mov extra1_y, 44
    mov extra1_x_prev, 24

    mov extra3_x, 08
    mov extra3_y, 76
    mov extra3_x_prev, 24


    mov extra5_x, 08
    mov extra5_y, 108
    mov extra5_x_prev, 24

    mov extra7_x, 08
    mov extra7_y, 140
    mov extra7_x_prev, 24

    mov extra10_x, 296
    mov extra10_y, 60
    mov extra10_x_prev, 280

    mov extra12_x, 296
    mov extra12_y, 92
    mov extra12_x_prev, 280

    mov extra14_x, 296
    mov extra14_y, 124
    mov extra14_x_prev, 280

    mov extra16_x, 296
    mov extra16_y, 156
    mov extra16_x_prev, 280

    mov ones, 33h
    mov tens, 36h
    

    ret
reset_variables endp

Draw_Main_Menu_Ball proc near

    mov cx, menu_ball_x ; CX = X, set initial x coordinates, 0
    mov dx, menu_ball_y ; DX = Y, set initial y coordinates, 0
    mov si, offset ball_logo_01

    Draw_Ball_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, menu_ball_x
        cmp ax, 40         
        JNE Draw_Ball_Horizontal
        mov cx, menu_ball_x
        inc dx
        mov ax, dx
        sub ax, menu_ball_y
        cmp ax, 40
        jne Draw_Ball_Horizontal
    
    ret
Draw_Main_Menu_Ball endp

Erase_Main_Menu_Ball proc near

    mov cx, menu_ball_x ; CX = X, set initial x coordinates, 0
    mov dx, menu_ball_y_prev ; DX = Y, set initial y coordinates, 0

    Erase_Ball_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, 00h ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, menu_ball_x
        cmp ax, 40         
        JNE Erase_Ball_Horizontal
        mov cx, menu_ball_x
        inc dx
        mov ax, dx
        sub ax, menu_ball_y
        cmp ax, 40
        jne Erase_Ball_Horizontal
    ret
Erase_Main_Menu_Ball endp

Move_Menu_Ball proc near
    ret
Move_Menu_Ball endp

delay proc   
    mov cx, 7
    mov dx, 0A120h
    mov ah, 86h    ;WAIT.
    int 15h
    ret
delay endp 

display_score PROC
    cmp time_seconds, 60
    jg score_exit

    ; set cursor
    mov dl, 10      ;x
    mov dh, 03      ;y
    call setcur

    ; iterate score and put it in ax
    
    mov ax, player_score 

    ; Initialize count
    mov cx,0
    mov dx,0

    extract_digit:
        ; If ax is zero
        cmp ax,0
        je print_score

        ; Initialize bx to 10
        mov bx, 10

        ; Extract the last digit
        div bx

        ; Push it in the stack
        
        push dx

        ; Increment the count
        inc cx

        ; Set dx to 0 
        xor dx, dx
        jmp extract_digit
    
        print_score:
        ; Check if count is greater than zero
        cmp cx,0
        je score_exit

        ; Pop the top of stack
        pop dx

        ; Add 48 so that it represents the ASCII value of digits
        add dx,48

        ; Interrupt to print a character
        mov ah, 0Eh           ; Teletype output
        mov al, dl            ; Character to print
        mov bl, 0Dh
        int 10h              ; BIOS video interrupt

        ; Decrease the count
        dec cx
        jmp print_score
score_exit:
    ret
display_score ENDP

victory_display_score PROC
    cmp time_seconds, 60
    jg victory_score_exit
    ; set cursor
    mov dl, 23      ;x
    mov dh, 12      ;y
    call setcur

    ; iterate score and put it in ax
    
    mov ax, player_score 

    ; Initialize count
    mov cx,0
    mov dx,0

    victory_extract_digit:
        ; If ax is zero
        cmp ax,0
        je victory_print_score

        ; Initialize bx to 10
        mov bx, 10

        ; Extract the last digit
        div bx

        ; Push it in the stack
        
        push dx

        ; Increment the count
        inc cx

        ; Set dx to 0 
        xor dx, dx
        jmp victory_extract_digit
    
    victory_print_score:    
        ; Check if count is greater than zero
        cmp cx,0
        je victory_score_exit

        ; Pop the top of stack
        pop dx

        ; Add 48 so that it represents the ASCII value of digits
        add dx,48

        ; Interrupt to print a character
        mov ah, 0Eh           ; Teletype output
        mov al, dl            ; Character to print
        mov bl, 0Dh
        int 10h              ; BIOS video interrupt

        ; Decrease the count
        dec cx
        jmp victory_print_score
victory_score_exit:
    ret
victory_display_score ENDP

display_victory proc near
    call clear_screen
    call menu_drawBottomBorder
    call menu_drawTopBorder
    call victory_draw_header
    call victory_display_score

    ; Display Score
    mov ax, 1300h   ;   set configuration for displaying with graphics
    mov dh, 12     ;y
    mov dl, 15     ;x
    mov bx, 000Ch ;page+color
    mov cx, message_score_1 ;msg length
    lea bp, message_score   ;msg
    int 10h

    ; Display Save to Leaderboard Prompt
    mov ax, 1300h           ;   set configuration to ah 13h, al 01h
    mov dh, 16              ;   y
    mov dl, 10              ;   x
    mov bx, 000Bh           ;   page + color
    mov cx, message_save_1  ;   msg length
    lea bp, message_save   ;   msg 
    int 10h

    ; Return to Menu Prompt
    mov dh, 18              ;   y
    mov dl, 13              ;   x
    mov bx, 000Bh           ;   page + color
    mov cx, message_menu_1 ;   msg length
    lea bp, message_menu   ;   msg 
    int 10h

    victory_wait_resp:
        mov ah, 01h         
        int 16h             
        jz victory_wait_resp     
        mov ah, 00h        
        int 16h             
        cmp al, 'S'
        je save_score   
        cmp al, 's'
        je save_score   
        cmp al, 'B'
        je exit_victory
        cmp al, 'b'
        je exit_victory
        jmp victory_wait_resp 
    
    save_score:
        call save_user_score
    exit_victory:
        call reset_variables
        jmp Start
    
    ret
display_victory endp

Select_Character_Screen proc near
    ;   Start of Select Character Screen
    mov skin_x, 20
    mov skin_y, 78

    call clear_screen
    call draw_character_select_header

    mov si, offset playerKnightR_pattern
    mov di, offset playerCurrent_Skin_pattern
    mov cx, 225          ; Number of bytes to copy
    rep movsb             ; Copy bytes from DS:SI to ES:DI
    call draw_skin
    add skin_y, 30

    mov si, offset little_girl_right_color_pattern
    mov di, offset playerCurrent_Skin_pattern
    mov cx, 225          ; Number of bytes to copy
    rep movsb             ; Copy bytes from DS:SI to ES:DI
    call Draw_Skin
    add skin_y, 30

    mov si, offset Jett_right_color_pattern
    mov di, offset playerCurrent_Skin_pattern
    mov cx, 225          ; Number of bytes to copy
    rep movsb             ; Copy bytes from DS:SI to ES:DI
    call Draw_Skin
    mov skin_y, 78
    mov skin_x, 160

    mov si, offset sage_right_color_pattern
    mov di, offset playerCurrent_Skin_pattern
    mov cx, 225          ; Number of bytes to copy
    rep movsb             ; Copy bytes from DS:SI to ES:DI
    call Draw_Skin
    add skin_y, 30

    mov si, offset jgirl_right_color_pattern
    mov di, offset playerCurrent_Skin_pattern
    mov cx, 225          ; Number of bytes to copy
    rep movsb             ; Copy bytes from DS:SI to ES:DI
    call Draw_Skin
    add skin_y, 30

    mov dh, 200      ;   x
    mov dl, 180       ;   y
    
    ; Back prompt
    mov ax, 1300h
    mov dh, 22              ;   y
    mov dl, 02              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_back_1  ;   msg length
    lea bp, message_back    ;   msg
    int 10h

    ; Dodger
    mov dh, 10              ;   y
    mov dl, 06              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_knight1  ;   msg length
    lea bp, message_knight    ;   msg
    int 10h

    ; Maria
    mov dh, 14              ;   y
    mov dl, 06              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_little_girl1  ;   msg length
    lea bp, message_little_girl    ;   msg
    int 10h
    ;   Knife
    mov dh, 18              ;   y
    mov dl, 06              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_knife_1  ;   msg length
    lea bp, message_knife    ;   msg
    int 10h
    ;   Mountain
    mov dh, 10              ;   y
    mov dl, 24              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_mountain1  ;   msg length
    lea bp, message_mountain    ;   msg
    int 10h
    ;   Yuki
    mov dh, 14              ;   y
    mov dl, 24              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_jgirl1  ;   msg length
    lea bp, message_jgirl    ;   msg
    int 10h

    ;
    mov dh, 18
    mov dl, 20
    mov bx, 000Fh           ;   page+color
    mov cx, message_selected1  ;   msg length
    lea bp, message_selected    ;   msg
    int 10h
    mov skin_x, 240

    ;   Get currently Selected Skin
        cmp skin_select, 1
        JNE next_skin_select2
        JMP draw_dodger
    next_skin_select2:
        cmp skin_select, 2
        JNE next_skin_select3
        JMP draw_maria
    next_skin_select3:
        cmp skin_select, 3
        JNE next_skin_select4
        JMP draw_knife
    next_skin_select4:
        cmp skin_select, 4
        JNE next_skin_select5
        JMP draw_mountain
    next_skin_select5:
        cmp skin_select, 5
        JNE next_skin_select6
        JMP draw_yuki
    next_skin_select6:
        call exit_program

    Select_Skin_Loop:
        mov ah, 01h         ;   check if which key is being pressed
        int 16h             ;   ZF = 1 when there is no key press
        JNZ Select_Skin_Loop
    
        mov ah, 00h
        int 16h

            cmp al, '1'
            JE draw_dodger

            cmp al, '2'
            JE draw_maria

            cmp al, '3'
            JE draw_knife

            cmp al, '4'
            JE draw_mountain

            cmp al, '5'
            JE draw_yuki
        ;   Jump Back to Start
            cmp al, 'b'
            JNE Next_Select_Skin1
            JMP Start
        Next_Select_Skin1:
            cmp al, 'B'
            JNE Next_Select_Skin2
            JMP Start
        Next_Select_Skin2:

    JMP Select_Skin_Loop

    draw_dodger:
        mov skin_select, 1
        mov si, offset playerKnightR_pattern
        mov di, offset playerCurrent_Skin_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb             ; Copy bytes from DS:SI to ES:DI
        JMP Draw_Selected_Skin
    draw_maria:
        mov skin_select, 2
        mov si, offset little_girl_right_color_pattern
        mov di, offset playerCurrent_Skin_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb             ; Copy bytes from DS:SI to ES:DI
        JMP Draw_Selected_Skin
    draw_knife:
        mov skin_select, 3
        mov si, offset Jett_right_color_pattern
        mov di, offset playerCurrent_Skin_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb             ; Copy bytes from DS:SI to ES:DI
        JMP Draw_Selected_Skin
    draw_mountain:
        mov skin_select, 4
        mov si, offset sage_right_color_pattern
        mov di, offset playerCurrent_Skin_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb             ; Copy bytes from DS:SI to ES:DI
        JMP Draw_Selected_Skin
    draw_yuki:
        mov skin_select, 5
        mov si, offset jgirl_right_color_pattern
        mov di, offset playerCurrent_Skin_pattern
        mov cx, 225          ; Number of bytes to copy
        rep movsb             ; Copy bytes from DS:SI to ES:DI
        JMP Draw_Selected_Skin
   
    Draw_Selected_Skin:
        call draw_skin

    JMP Select_Skin_Loop

    call exit_program
    ret
Select_Character_Screen endp

draw_skin proc near
    mov cx, skin_x ; CX = X, set initial x coordinates, 0
    mov dx, skin_y ; DX = Y, set initial y coordinates, 0
    mov si, offset playerCurrent_Skin_pattern

    Draw_Skin_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, skin_x
        cmp ax, player_size         ;   15
        JNE Draw_skin_Horizontal
        mov cx, skin_x
        inc dx
        mov ax, dx
        sub ax, skin_y
        cmp ax, player_size
        jne Draw_skin_Horizontal
    
    ret
draw_skin endp

draw_character_select_header proc near
    mov si, offset selectcharacter_color_pattern_0
    call draw_character_select2_header

    mov si, offset selectcharacter_color_pattern_1
    call draw_character_select2_header

    mov si, offset selectcharacter_color_pattern_2
    call draw_character_select2_header

    mov si, offset selectcharacter_color_pattern_3
    call draw_character_select2_header
    
    mov header_x, 60 ; reset header after the whole thing is printed
 ret
draw_character_select_header endp

draw_character_select2_header proc near 
    mov cx, header_x               ; CX = X,set initial x coordinates
    mov dx, header_y                ; DX = Y,set initial y coordinates

    victory_Draw_Select_Horizontal:
        mov ah,0Ch               ; function 0Ch - write pixel in graphics mode
        mov al,[si]              ; AL = color
        mov bh,00h               ; BH = page number (disregard)
        int 10h                   ; call BIOS video interrupt
        inc si
        inc cx
        mov ax,cx
        sub ax, header_x
        cmp ax, header_Width
        jne victory_Draw_Select_Horizontal
        mov cx, header_x
        inc dx
        mov ax,dx
        sub ax, header_y
        cmp ax, header_Height
        jne victory_Draw_Select_Horizontal

    add header_x, 48
    ret
draw_character_select2_header endp

display_more_info proc near
    more_info_page_one:
    call clear_screen
    call moreinfo_draw_header
    call draw_wasd
    call draw_balls

    ; Controls Guide
    mov ax, 1300h
    mov dh, 09              ;   y
    mov dl, 16              ;   x
    mov bx, 000Ah           ;   page+color
    mov cx, message_controls_1  ;   msg length
    lea bp, message_controls    ;   msg
    int 10h

    ; Avoiding Guide
    mov dh, 09              ;   y
    mov dl, 31              ;   x
    mov bx, 000Ch           ;   page+color
    mov cx, message_avoid_1  ;   msg length
    lea bp, message_avoid    ;   msg
    int 10h

    ; Catching Guide
    mov dh, 09              ;   y
    mov dl, 04              ;   x
    mov bx, 0009h           ;   page+color
    mov cx, message_catch_1  ;   msg length
    lea bp, message_catch    ;   msg
    int 10h

    ; Red Orb Guide
    mov dh, 14              ;   y
    mov dl, 05              ;   x
    mov bx, 0004h           ;   page+color
    mov cx, message_orbA_1  ;   msg length
    lea bp, message_orbA    ;   msg
    int 10h

    ; Green Orb Guide
    mov dh, 12              ;   y
    mov dl, 05              ;   x
    mov bx, 0002h           ;   page+color
    mov cx, message_orbB_1  ;   msg length
    lea bp, message_orbB    ;   msg
    int 10h

    ; Yellow Orb Guide
    mov dh, 16              ;   y
    mov dl, 05              ;   x
    mov bx, 0006h           ;   page+color
    mov cx, message_orbC_1  ;   msg length
    lea bp, message_orbC    ;   msg
    int 10h

    ; Next prompt
    mov dh, 21              ;   y
    mov dl, 30              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_next_1  ;   msg length
    lea bp, message_next    ;   msg
    int 10h

    ; Back prompt
    mov dh, 21              ;   y
    mov dl, 02              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_back_1  ;   msg length
    lea bp, message_back    ;   msg
    int 10h
    jmp page1_wait_resp

    page2_wait_resp:
        mov ah, 01h         
        int 16h             
        jz page2_wait_resp       
        mov ah, 00h        
        int 16h             
        cmp al, 'b' ; left arrow key
        je goto_page_one
        cmp al, 'n' ; right arrow key
        jne page2_wait_resp
        jmp more_info_exit
    
    goto_page_one:
    jmp more_info_page_one
    
    page1_wait_resp:
        mov ah, 01h         
        int 16h             
        jz page1_wait_resp       
        mov ah, 00h        
        int 16h             
        cmp al, 'b' ; left arrow key
        je more_info_exit
        cmp al, 'n' ; right arrow key
        je more_info_page_two
        jmp page1_wait_resp

    more_info_page_two:
    call clear_screen
    call moreinfo_draw_header

    mov ax, 1300h

    ; Mechanics 
    mov dh, 09              ;   y
    mov dl, 16              ;   x
    mov bx, 000Ah           ;   page+color
    mov cx, message_mechanics_1  ;   msg length
    lea bp, message_mechanics   ;   msg
    int 10h

    ; 1
    mov dh, 12              ;   y
    mov dl, 02              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_mechanicsA_1  ;   msg length
    lea bp, message_mechanicsA   ;   msg
    int 10h

    mov dh, 14              ;   y
    mov dl, 02              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_mechanicsB_1  ;   msg length
    lea bp, message_mechanicsB   ;   msg
    int 10h

    mov dh, 16              ;   y
    mov dl, 02              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_mechanicsC_1  ;   msg length
    lea bp, message_mechanicsC   ;   msg
    int 10h

    mov dh, 18              ;   y
    mov dl, 02              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_mechanicsD_1  ;   msg length
    lea bp, message_mechanicsD   ;   msg
    int 10h

    ; Next prompt
    mov dh, 22              ;   y
    mov dl, 30              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_next_1  ;   msg length
    lea bp, message_next    ;   msg
    int 10h

    ; Back prompt
    mov dh, 22              ;   y
    mov dl, 02              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_back_1  ;   msg length
    lea bp, message_back    ;   msg
    int 10h
    jmp page2_wait_resp

    more_info_exit:
    ret
display_more_info endp

draw_balls proc near
    mov cx, 20 ; CX = X, set initial x coordinates, 0
    mov dx, 92 ; DX = Y, set initial y coordinates, 0
    mov si, offset greenorb_color_pattern

    Draw_GreenOrb_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 20 ; x
        cmp ax, 15       ;   size
        JNE Draw_GreenOrb_Horizontal
        mov cx, 20 ; x
        inc dx
        mov ax, dx
        sub ax, 92 ; y
        cmp ax, 15 ; size
        jne Draw_GreenOrb_Horizontal
    
    mov cx, 20 ; CX = X, set initial x coordinates, 0
    mov dx, 108 ; DX = Y, set initial y coordinates, 0
    mov si, offset redorb_color_pattern

    Draw_RedOrb_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 20 ; x
        cmp ax, 15       ;   size
        JNE Draw_RedOrb_Horizontal
        mov cx, 20 ; x
        inc dx
        mov ax, dx
        sub ax, 108 ; y
        cmp ax, 15 ; size
        jne Draw_RedOrb_Horizontal

    mov cx, 20 ; CX = X, set initial x coordinates, 0
    mov dx, 124 ; DX = Y, set initial y coordinates, 0
    mov si, offset yelloworb_color_pattern

    Draw_YellowOrb_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 20 ; x
        cmp ax, 15       ;   size
        JNE Draw_YellowOrb_Horizontal
        mov cx, 20 ; x
        inc dx
        mov ax, dx
        sub ax, 124 ; y
        cmp ax, 15 ; size
        jne Draw_YellowOrb_Horizontal

    mov cx, 230 ; CX = X, set initial x coordinates, 0
    mov dx, 95 ; DX = Y, set initial y coordinates, 0
    mov si, offset baseball_color_pattern

    Draw_Baseball_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 230 ; x
        cmp ax, 15       ;   size
        JNE Draw_Baseball_Horizontal
        mov cx, 230
        inc dx
        mov ax, dx
        sub ax, 95 ; y
        cmp ax, 15 ; size
        jne Draw_Baseball_Horizontal

    mov cx, 250 ; CX = X, set initial x coordinates, 0
    mov dx, 95 ; DX = Y, set initial y coordinates, 0
    mov si, offset basketball_color_pattern

    Draw_Basketball_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 250 ; x
        cmp ax, 15       ;   size
        JNE Draw_Basketball_Horizontal
        mov cx, 250
        inc dx
        mov ax, dx
        sub ax, 95 ; y
        cmp ax, 15 ; size
        jne Draw_Basketball_Horizontal

    mov cx, 270 ; CX = X, set initial x coordinates, 0
    mov dx, 95 ; DX = Y, set initial y coordinates, 0
    mov si, offset Nineball_color_pattern

    Draw_Nineball_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 270 ; x
        cmp ax, 15       ;   size
        JNE Draw_Nineball_Horizontal
        mov cx, 270
        inc dx
        mov ax, dx
        sub ax, 95 ; y
        cmp ax, 15 ; size
        jne Draw_Nineball_Horizontal
    
    mov cx, 290 ; CX = X, set initial x coordinates, 0
    mov dx, 95 ; DX = Y, set initial y coordinates, 0
    mov si, offset volleyball_color_pattern

    Draw_Volleyball_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 290 ; x
        cmp ax, 15       ;   size
        JNE Draw_Volleyball_Horizontal
        mov cx, 290
        inc dx
        mov ax, dx
        sub ax, 95 ; y
        cmp ax, 15 ; size
        jne Draw_Volleyball_Horizontal

    mov cx, 230 ; CX = X, set initial x coordinates, 0
    mov dx, 115 ; DX = Y, set initial y coordinates, 0
    mov si, offset Snowflake_color_pattern

    Draw_Snowflake_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 230 ; x
        cmp ax, 15       ;   size
        JNE Draw_Snowflake_Horizontal
        mov cx, 230
        inc dx
        mov ax, dx
        sub ax, 115 ; y
        cmp ax, 15 ; size
        jne Draw_Snowflake_Horizontal

    mov cx, 250 ; CX = X, set initial x coordinates, 0
    mov dx, 115 ; DX = Y, set initial y coordinates, 0
    mov si, offset BeachBall_color_pattern

    Draw_BeachBall_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 250 ; x
        cmp ax, 15       ;   size
        JNE Draw_BeachBall_Horizontal
        mov cx, 250
        inc dx
        mov ax, dx
        sub ax, 115 ; y
        cmp ax, 15 ; size
        jne Draw_BeachBall_Horizontal
    
    mov cx, 270 ; CX = X, set initial x coordinates, 0
    mov dx, 115 ; DX = Y, set initial y coordinates, 0
    mov si, offset Soccer_color_pattern

    Draw_Soccer_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 270 ; x
        cmp ax, 15       ;   size
        JNE Draw_Soccer_Horizontal
        mov cx, 270
        inc dx
        mov ax, dx
        sub ax, 115 ; y
        cmp ax, 15 ; size
        jne Draw_Soccer_Horizontal

    mov cx, 290 ; CX = X, set initial x coordinates, 0
    mov dx, 115 ; DX = Y, set initial y coordinates, 0
    mov si, offset tennis_color_pattern

    Draw_Tennis_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 290 ; x
        cmp ax, 15       ;   size
        JNE Draw_Tennis_Horizontal
        mov cx, 290
        inc dx
        mov ax, dx
        sub ax, 115 ; y
        cmp ax, 15 ; size
        jne Draw_Tennis_Horizontal

    ret
draw_balls endp

draw_wasd proc near
    mov cx, 152 ; CX = X, set initial x coordinates, 0
    mov dx, 105 ; DX = Y, set initial y coordinates, 0
    mov si, offset W

    Draw_W_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 152 ; x
        cmp ax, 15       ;   size
        JNE Draw_W_Horizontal
        mov cx, 152
        inc dx
        mov ax, dx
        sub ax, 105 ; y
        cmp ax, 15 ; size
        jne Draw_W_Horizontal

    mov cx, 152 ; CX = X, set initial x coordinates, 0
    mov dx, 125 ; DX = Y, set initial y coordinates, 0
    mov si, offset S

    Draw_S_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 152 ; x
        cmp ax, 15       ;   size
        JNE Draw_S_Horizontal
        mov cx, 152
        inc dx
        mov ax, dx
        sub ax, 125 ; y
        cmp ax, 15 ; size
        jne Draw_S_Horizontal

    mov cx, 132 ; CX = X, set initial x coordinates, 0
    mov dx, 125 ; DX = Y, set initial y coordinates, 0
    mov si, offset A

    Draw_A_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 132 ; x
        cmp ax, 15       ;   size
        JNE Draw_A_Horizontal
        mov cx, 132
        inc dx
        mov ax, dx
        sub ax, 125 ; y
        cmp ax, 15 ; size
        jne Draw_A_Horizontal

    mov cx, 172 ; CX = X, set initial x coordinates, 0
    mov dx, 125 ; DX = Y, set initial y coordinates, 0
    mov si, offset D

    Draw_D_Horizontal:
        mov ah, 0Ch ;configuration to printing pixel
        mov al, [si] ;color pattern
        mov bh, 00h ;page number (disregard)
        int 10h ; call dos for printing pixel
        inc si
        inc cx  ; 
        mov ax, cx
        sub ax, 172 ; x
        cmp ax, 15       ;   size
        JNE Draw_D_Horizontal
        mov cx, 172 ; x
        inc dx
        mov ax, dx
        sub ax, 125 ; y
        cmp ax, 15 ; size
        jne Draw_D_Horizontal
    ret
draw_wasd endp

display_leaderboard proc near
    call clear_screen
    call menu_drawTopBorder
    call menu_drawBottomBorder
    call leaderboard_draw_header
    
    ; Back prompt
    mov ax, 1300h
    mov dh, 20              ;   y
    mov dl, 02              ;   x
    mov bx, 000Fh           ;   page+color
    mov cx, message_back_1  ;   msg length
    lea bp, message_back    ;   msg
    int 10h

    ; Set cursor position to x=20, y=12
    mov ah, 02h  ; Set cursor position function
    mov bh, 00h  ; Page number
    mov dh, 08   ; Row 
    mov dl, 14h  ; Column (x = 20)
    int 10h      ; Call BIOS video services interrupt
    
    ; open file
    mov ax, 3d02h
    lea dx, file_name
    int 21h
    mov file_handle, ax

    ;seek to start of file
    mov ax, 4200h
    mov bx, file_handle
    mov cx, 0
    mov dx, 0
    int 21h

    ;read from file
    mov ah, 3fh
    mov bx, file_handle
    mov cx, 1fh
    lea dx, leaderboard_scores
    int 21h

    lea si, leaderboard_scores
    mov ch, byte ptr [si]
    ;ch = number of records
    inc si
    iter_scores:
        lea di, string_buffer
        mov cl, 04h

        ldbuf:
            mov dl, byte ptr [si]
            mov byte ptr [di], dl
            inc di
            inc si
            dec cl
            jnz ldbuf

        mov ah, 02h
        mov dl, 0ah
        int 21h 

        push cx
        mov cx, 16
        space: 
            mov ah, 02h
            mov dl, 20h
            int 21h 
        loop space
       
        pop cx
        lea dx, string_buffer
        mov ah, 09h
        int 21h

        mov ah, 02h
        mov dl, 20h
        int 21h
        
        mov ah, byte ptr [si]
        inc si
        mov al, byte ptr [si]
        push cx
        mov cx, 03h
        int_score:         
            xor dx, dx
            mov bx, 0ah
            div bx
            push dx
        loop int_score
        mov cx, 03h
        printnum:
            pop dx
            add dx, '0'
            mov ah, 02 
            int 21h
        loop printnum
        inc si
        pop cx
        dec ch
        mov ah, 02h
        mov dl, 10
        int 21h
    jnz iter_scores

    leaderboard_wait_resp:
        mov ah, 01h         
        int 16h             
        jz leaderboard_wait_resp       
        mov ah, 00h        
        int 16h             
        cmp al, 'B'
        je exit_leaderboard
        cmp al, 'b'
        je exit_leaderboard
    jmp leaderboard_wait_resp

    exit_leaderboard:
    ret
display_leaderboard endp

save_user_score proc near
        call clear_screen
        mov ax, 1301h   
        lea bp, prompt_name
        mov bh, 00h   ;page
        mov bl, 0Fh
        mov cx, prompt_name_1
        mov dh, 07
        mov dl, 06
        int 10h
        
        mov cx, 3
        mov bp, 0
        
        lea si, user_name 
        mov cx, 3
        mov bp, 0
        get_user_name:
            mov ah, 7
            int 21h
            
            mov ah, 2
            mov dh, 12 
            mov dl, 18
            add dx, bp 
            inc bp
            mov bh, 0
            int 10h

            cmp al, 8
            jne print_char

            mov ah, 2
            dec dx 
            dec bp
            dec bp
            dec si
            mov bh, 0
            int 10h

            mov ax, 0a20h
            mov bh, 0
            mov cx, 1
            int 10h 

            jmp get_user_name

        print_char:
            mov ah, 0ah
            mov bh, 0
            mov bl, 0Bh
            push cx
            mov cx, 1
            int 10h
            pop cx
            
            mov byte ptr [si], al
            inc si
        cmp bp, 3
        je confirm_user_name
        jmp get_user_name
        
        confirm_user_name:
            mov byte ptr [si], '$'
            mov ax, player_score
            lea si, input_score 
            mov byte ptr [si+1], al
            
        ;open file  
        mov ax, 3d02h
        lea dx, file_name
        int 21h
        mov file_handle, ax

        ;seek to start of file
        mov ax, 4200h
        mov bx, file_handle
        mov cx, 0
        mov dx, 0
        int 21h

        ;read from file
        mov ah, 3fh
        mov bx, file_handle
        mov cx, 1fh
        lea dx, leaderboard_scores
        int 21h
        
        ;insert
        lea di, leaderboard_scores
        xor ax, ax
        mov al, byte ptr [di]
        mov bl, 06h ;go to the last score record
        mul bl
        xor ah, ah
        add di, ax ;move di to the the last byte of the last record
        add di, 01h
        ins_rec:
            lea si, user_name
            mov cx, 04h
            inp_name:
                mov dl, byte ptr [si]
                mov byte ptr [di], dl
                inc si
                inc di
                loop inp_name
            lea si, input_score
            mov dh, byte ptr [si]
            mov dl, byte ptr [si+1]
            mov byte ptr [di], dh
            mov byte ptr [di+1], dl
        
        ;increment score size 
        lea si, leaderboard_scores
        mov ch, byte ptr [si]
        inc ch
        mov byte ptr [si], ch
        
        ;SORTING
        mov dh, ch
        ;ch = outer loop counter
        ;dh = inner loop counter
        out_sort:
            lea si, leaderboard_scores ;reset pointers
            lea di, leaderboard_scores
            add si, 06h
            add di, 06h
            push cx
            mov ch, dh
            in_sort:
                mov di, si
                mov al, byte ptr [si]
                mov ah, byte ptr [si-1]
                mov bl, byte ptr [si+6]
                mov bh, byte ptr [si+5]
                cmp ax, bx
                jge no_swap
                add di, 01h
                sub si, 05h
                mov dl, 06h
                swap_score:
                    mov bh, byte ptr [di]
                    mov bl, byte ptr [si]
                    mov byte ptr [di], bl
                    mov byte ptr [si], bh
                    inc si
                    inc di
                    dec dl
                    jnz swap_score
                no_swap:
                add si, 06h
                dec ch 
            jnz in_sort
            pop cx
            dec dh
            dec ch
        jnz out_sort

        ;cap score size for storage
        lea si, leaderboard_scores
        mov al, byte ptr [si]
        cmp al, 05h
        jle under_cap
        mov al, 05h
        under_cap:
        mov byte ptr[si], al
            
        ;seek to start of file
        mov ax, 4200h
        mov bx, file_handle
        mov cx, 0
        mov dx, 0
        int 21h
        ;write to file
        mov ah, 40h
        mov bx, file_handle
        lea dx, leaderboard_scores
        mov cx, 1fh;
        int 21h
        ;close file
        mov ah, 3eh
        mov bx, file_handle
        int 21h

        ret
save_user_score endp

victory_draw_header proc near

    mov header_y, 30

    mov si, offset youwin_color_pattern_0
    call victory_draw2_header

    mov si, offset youwin_color_pattern_1
    call victory_draw2_header

    mov si, offset youwin_color_pattern_2
    call victory_draw2_header

    mov si, offset youwin_color_pattern_3
    call victory_draw2_header
    
    mov header_x, 60 ; reset header x and y after the whole thing is printed
    mov header_y, 17
 ret
victory_draw_header endp

victory_draw2_header proc near 
    mov cx, header_x               ; CX = X,set initial x coordinates
    mov dx, header_y                ; DX = Y,set initial y coordinates

    victory_Draw_Horizontal:
        mov ah,0Ch               ; function 0Ch - write pixel in graphics mode
        mov al,[si]              ; AL = color
        mov bh,00h               ; BH = page number (disregard)
        int 10h                   ; call BIOS video interrupt
        inc si
        inc cx
        mov ax,cx
        sub ax, header_x
        cmp ax, header_Width
        jne victory_Draw_Horizontal
        mov cx, header_x
        inc dx
        mov ax,dx
        sub ax, header_y
        cmp ax, header_Height
        jne victory_Draw_Horizontal

    add header_x, 48
    ret
victory_draw2_header endp

gameover_draw_header proc near

    mov header_y, 30

    mov si, offset gameover_color_pattern_0
    call gameover_draw2_header

    mov si, offset gameover_color_pattern_1
    call gameover_draw2_header

    mov si, offset gameover_color_pattern_2
    call gameover_draw2_header

    mov si, offset gameover_color_pattern_3
    call gameover_draw2_header
    
    mov header_x, 60 ; reset header x and y after the whole thing is printed
    mov header_y, 17
 ret
gameover_draw_header endp

gameover_draw2_header proc near 
    mov cx, header_x               ; CX = X,set initial x coordinates
    mov dx, header_y                ; DX = Y,set initial y coordinates

    gameover_Draw_Horizontal:
        mov ah,0Ch               ; function 0Ch - write pixel in graphics mode
        mov al,[si]              ; AL = color
        mov bh,00h               ; BH = page number (disregard)
        int 10h                   ; call BIOS video interrupt
        inc si
        inc cx
        mov ax,cx
        sub ax, header_x
        cmp ax, header_Width
        jne gameover_Draw_Horizontal
        mov cx, header_x
        inc dx
        mov ax,dx
        sub ax, header_y
        cmp ax, header_Height
        jne gameover_Draw_Horizontal

    add header_x, 48
    ret
gameover_draw2_header endp

moreinfo_draw_header proc near
    mov si, offset howtoplay_color_pattern_0
    call gameover_draw2_header

    mov si, offset howtoplay_color_pattern_1
    call gameover_draw2_header

    mov si, offset howtoplay_color_pattern_2
    call gameover_draw2_header

    mov si, offset howtoplay_color_pattern_3
    call gameover_draw2_header
    
    mov header_x, 60 ; reset header after the whole thing is printed
 ret
moreinfo_draw_header endp

moreinfo_draw2_header proc near 
    mov cx, header_x               ; CX = X,set initial x coordinates
    mov dx, header_y                ; DX = Y,set initial y coordinates

    moreinfo_Draw_Horizontal:
        mov ah,0Ch               ; function 0Ch - write pixel in graphics mode
        mov al,[si]              ; AL = color
        mov bh,00h               ; BH = page number (disregard)
        int 10h                   ; call BIOS video interrupt
        inc si
        inc cx
        mov ax,cx
        sub ax, header_x
        cmp ax, header_Width
        jne moreinfo_Draw_Horizontal
        mov cx, header_x
        inc dx
        mov ax,dx
        sub ax, header_y
        cmp ax, header_Height
        jne moreinfo_Draw_Horizontal

    add header_x, 48
    ret
moreinfo_draw2_header endp

leaderboard_draw_header proc near
    mov si, offset leaderboard_color_pattern_0
    call gameover_draw2_header

    mov si, offset leaderboard_color_pattern_1
    call gameover_draw2_header

    mov si, offset leaderboard_color_pattern_2
    call gameover_draw2_header

    mov si, offset leaderboard_color_pattern_3
    call gameover_draw2_header
    
    mov header_x, 60 ; reset header after the whole thing is printed
 ret
leaderboard_draw_header endp

leaderboard_draw2_header proc near 
    mov cx, header_x               ; CX = X,set initial x coordinates
    mov dx, header_y                ; DX = Y,set initial y coordinates

    leaderboard_Draw_Horizontal:
        mov ah,0Ch               ; function 0Ch - write pixel in graphics mode
        mov al,[si]              ; AL = color
        mov bh,00h               ; BH = page number (disregard)
        int 10h                   ; call BIOS video interrupt
        inc si
        inc cx
        mov ax,cx
        sub ax, header_x
        cmp ax, header_Width
        jne leaderboard_Draw_Horizontal
        mov cx, header_x
        inc dx
        mov ax,dx
        sub ax, header_y
        cmp ax, header_Height
        jne leaderboard_Draw_Horizontal

    add header_x, 48
    ret
leaderboard_draw2_header endp


end Main                                             ;   End the main function
