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
.data           ; data segment is where we instantiate our DATA or SENTENCES

Message1 db 'Welcome to the game ', 0Ah, 0Dh, '$'   ;   combine Line Feed and Carriage return to set cursor to the next line 
                                                       
.code                                               ;   Code Segment where we write our main program

main PROC near                                      ;   PROC means Procedure (or Function)

    mov ax, @data
    mov ds, ax

    lea dx, Message1                                ;   LEA is Load Effective Address
    call printLine
    call exit

main endp                                           ;   endp is End Procedure (End Function)

printLine proc near
	mov ah, 09
	int 21h
    ret
printLine endp

setCurPos
    mov ah, 02
	mov bh, 00
	int 10h
	ret

setCurPos endp






exit proc near ;                
    mov ah, 4ch
    int 21h
exit endp                                            ;   exit the function

end Main                                             ;   End the main function