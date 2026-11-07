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

END