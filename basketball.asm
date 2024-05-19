.model small
.stack 100h

.data
    message_title db 'Blitz Ball', 13, 10, '$'
    message_start db 'Press T to start', 13, 10, '$'
    message_choose db 'Press C to choose level', 13, 10, '$'
    message_exit db 'Press E to exit', 13, 10, '$'
    keyPressed DB ?



.code
main proc
    mov ax, @data
    mov ds, ax

    ; Clear the screen
    mov ax, 13h
    int 10h

    ; Display Title
    mov ah, 02h
    mov dh, 05
    mov dl, 15
    call setcur
    lea dx, message_title
    call outstr

    ; Display "Press T to start"
    mov dh, 14
    mov dl, 12
    call setcur
    lea dx, message_start
    call outstr

    ; Display "Press C to choose level"
    mov dh, 16  ; Move to the next line
    mov dl, 09
    call setcur
    lea dx, message_choose
    call outstr

    ; Display "Press E to exit"
    mov dh, 18 ; Move to the next line
    mov dl, 12
    call setcur
    lea dx, message_exit
    call outstr

    ; Wait for user input
    call wait_input

start_game:
    ; Reset cursor position to top left corner
    mov dh, 50
	mov dl, 50	; y axis
    call setcur

    ; Call subroutine to draw and move pixel
    call SpriteAnimation

    ; Restore text mode and exit
    mov ax, 0003h
    int 10h

exit_program:
    ; Exit program
    mov ah, 4Ch
    int 21h

wait_input:
    mov ah, 01h
    int 21h
    cmp al, 'T'
    je start_game
    cmp al, 't'
    je start_game
    cmp al, 'E'
    je exit_program
    cmp al, 'e'
    je exit_program
    cmp al, 'C'
    je wait_input
    cmp al, 'c'
    je wait_input
    jmp wait_input

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

SpriteAnimation proc
    ; Your sprite animation code goes here
    mov ah, 0
    mov al, 13h
    int 10h

    mov dh, 20
    mov dl, 30

    call ShowSprite

    ; Movement of the Sprite
    infloop: 
        mov ah, 01h     ; Function 01h = Check if keybuffer is empty
        int 16h         ; int 16 = keyboard interrupt
        jz infloop      ; Check if no key pressed

        call ShowSprite ; Remove old sprite

        mov ah, 00h     ; Func 0Eh = Read a key from buffer
        int 16h         ; keyboard interrupt

        cmp ah, 48h     ; compare to UP
        jnz CurNotUp 
        cmp dl, 0
        jz CurNotUp 
        dec dl          ; Move up
    CurNotUp:

        cmp ah, 50h     ; Compare to down
        jnz CurNotDown
        cmp dl, 24      ; Check it at the bottom of the screen
        jz CurNotDown
        inc dl          ; Move down
    CurNotDown:

        cmp ah, 4BH     ; Compare to Left
        jnz CurNotLeft
        cmp dh, 0       ; Check it at the left of the screen
        jz CurNotLeft
        dec dh          ; Move Left
    CurNotLeft:

        cmp ah, 4Dh     ; Compare to right
        jnz CurNotRight
        cmp dh, 39      ; Check it at the right of the screen
        jz CurNotRight 
        inc dh          ; Move Right
    CurNotRight: 

        call ShowSprite ; Show the new sprite position
        jmp infloop     ; Repeat

    ret
SpriteAnimation endp

ShowSprite proc
    ; Your ShowSprite code goes here
    ; This procedure will display your sprite
    mov ax, 0A000H
    mov es, ax
    mov ax, @code
    mov ds, ax

    push dx
        mov ax, 8
        mul dh
        mov di, ax
        
        mov ax, 8*320
        mov bx, 0
        add bl, dl
        mul bx
        add di, ax 
    pop dx    

    mov si, offset BitmapTest
    mov cl, 8                   ; height
DrawBitmap_Yagain:
    push di
        mov ch, 8               ; width
DrawBitmap_Xagain:
        mov al, byte ptr DS:[SI]
        xor al, byte ptr ES:[DI]         ; XOR with current screen data
        mov byte ptr ES:[DI], al
        inc si
        inc di 
        dec ch 
        jnz DrawBitmap_Xagain   ; Next horizontal pixel
    pop di
    add di, 320
    inc bl
    dec cl 
    jnz DrawBitmap_Yagain
    ret
ShowSprite endp

BitmapTest:
    DB 00h,00h,0Ch,04h,0Ch,0Ch,00h,00h     
    DB 00h,0Ch,04h,0Ch,0Ch,0Ch,0Ch,00h     
    DB 0Ch,04h,0Ch,0Ch,0Ch,04h,04h,0Ch     
    DB 0Ch,04h,0Ch,0Ch,04h,0Ch,0Ch,0Ch     
    DB 04h,04h,04h,04h,04h,04h,04h,04h     
    DB 0Ch,04h,0Ch,0Ch,04h,0Ch,0Ch,0Ch     
    DB 00h,0Ch,04h,0Ch,0Ch,04h,04h,00h     
    DB 00h,00h,0Ch,04h,0Ch,0Ch,00h,00h

main endp
end main
