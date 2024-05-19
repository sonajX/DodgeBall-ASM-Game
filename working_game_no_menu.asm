.model small
.stack 100h

.data
    message_title db 'Blitz Ball', 13, 10, '$'
    message_start db 'Press T to start', 13, 10, '$'
    message_choose db 'Press C to choose level', 13, 10, '$'
    message_exit db 'Press E to exit', 13, 10, '$'
    row DW ?
    col DW ?
    prevRow DW ?
    prevCol DW ?
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

start:
    ; Initialize position of pixel
    mov row, 100  ; Initial position of pixel (100, 100)
    mov col, 160

    ; Set video mode
    mov ax, 0013h  ; Mode 13h (320x200, 256 colors)
    int 10h

    ; Call subroutine to draw and move pixel
    call DrawPixel

exit_program:
    ; Restore text mode
    mov ax, 0003h
    int 10h

    ; Exit program
    mov ah, 4Ch
    int 21h

wait_input:
    mov ah, 01h
    int 21h
    cmp al, 'T'
    je start
    cmp al, 't'
    je start
    cmp al, 'E'
    je exit_program
    cmp al, 'e'
    je exit_program
    cmp al, 'C'
    je wait_input
    cmp al, 'c'
    je wait_input
    jmp wait_input

DrawPixel:
    ; Erase the pixel from its previous position
    mov ah, 0Ch  ; Set pixel color
    mov al, 00h  ; Black color (erase with black pixel)
    mov cx, prevCol  ; Column
    mov dx, prevRow  ; Row
    int 10h

    ; Draw the pixel at the current position
    mov ah, 0Ch  ; Set pixel color
    mov al, 0Fh  ; White color
    mov cx, col  ; Column
    mov dx, row  ; Row
    int 10h

    ; Remember current position as previous position
    mov ax, row
    mov prevRow, ax
    mov ax, col
    mov prevCol, ax

    ; Wait for key press
    mov ah, 00h
    int 16h
    mov keyPressed, ah

    ; Check arrow key input
    cmp keyPressed, 48h  ; Up arrow
    je MoveUp
    cmp keyPressed, 4Bh  ; Left arrow
    je MoveLeft
    cmp keyPressed, 4Dh  ; Right arrow
    je MoveRight
    cmp keyPressed, 50h  ; Down arrow
    je MoveDown

    jmp DrawPixel

DrawProjectile:
    mov ah, 0Ch  ; Draw pixel 
    mov al, 04  ; Set pixel to red color
    mov cx, col  ; Column
    mov dx, row  ; Row

MoveUp:
    sub row, 1
    jmp DrawPixel

MoveLeft:
    sub col, 1
    jmp DrawPixel

MoveRight:
    add col, 1
    jmp DrawPixel

MoveDown:
    add row, 1
    jmp DrawPixel

outstr proc near
    mov ah, 09
    int 21h
    ret
outstr endp

setcur proc near
    mov ah, 02
    mov bh, 00
    int 10h
    ret
setcur endp

main endp
end main
