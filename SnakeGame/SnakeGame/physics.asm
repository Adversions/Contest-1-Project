INCLUDE snakegame.inc

.code
; Depending on the character in the direction variable, a specific procedure is called
MoveSnake PROC
.IF direction == 85			; 'U' characher
	call MoveUp
.ELSEIF direction == 68		; 'D' character
	call MoveDown
.ELSEIF direction == 82		; 'R' character
	call MoveRight
.ELSE						; 'L' character
	call MoveLeft
.ENDIF
ret
MoveSnake ENDP

; Checks if the snakes head has hit the snake or a boundary wall
HitBoundary PROC USES eax ebx ecx edx
mov eax, [snake_head_pos]		; moves the snakes pos into eax
mov bl, [eax]					; moves that char at the snake pos into al

sub eax, OFFSET map
xor edx, edx
mov ecx, 48
div ecx							; row pos is stored in al, col pos is stored in dl

.IF bl != 0						; if the char does not equal to 0, it means a part of the snake is at that pos
	mov [gameOver], 1					; moves 0 into ecx which is checked before the game loops in main proc
.ELSEIF dl == 0 || dl == 47
	mov [gameOver], 1
.ELSEIF al == 0 || al == 20
	mov [gameOver], 1
.ENDIF

ret
HitBoundary ENDP

; Checks if a fruit has been eaten
AteFruit PROC
mov eax, [snake_head_pos] ; position of the head put in eax
mov ebx, [fruit_pos]      ; position of the fruit put in ebx

.IF eax == ebx            ; if they equal, spawns another fruit
	call SpawnFruit
	mov eax, 0
.ENDIF
ret
AteFruit ENDP

; moves the snake one space in the left direction
MoveLeft PROC
call GetHeadCoordinates		; gets the head coordinates into eax and edx
dec dl						; decriments the col
mov dl, dl
mov dh, al
call Gotoxy
mov al, 's'
call WriteChar
mov bl, 'H'					; moves the 'H' char into bl reg so updateCoordinates proc knows its updating the head pos
call UpdateCoordinates
cmp eax, 0
jz T1 

call GetTailCoordinates		; gets the tail coordinates into eax and edx
mov dl, dl					; The tail col pos get decrimented in the updateCoordinates proc
mov dh, al
call Gotoxy
mov al, ' '
call WriteChar
mov bl, 'T'					;  moves the 'T' char into bl reg so updateCoordinates proc knows its updating the head pos
call UpdateCoordinates

T1:
ret
MoveLeft ENDP

END