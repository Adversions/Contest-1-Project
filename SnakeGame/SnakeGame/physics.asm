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

END