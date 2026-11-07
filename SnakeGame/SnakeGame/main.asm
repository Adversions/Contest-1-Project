;INCLUDE Irvine32.inc
INCLUDE snakegame.inc


.data
top_bottom_boundary BYTE "------------------------------------------------",0
side_boundary BYTE "-",0
map BYTE 912 DUP(0) ; an array the represents each point on the map
direction BYTE 'L' ;L: moving left, R: moving right, D: moving down, U: moving up
snake_head_pos DWORD (OFFSET map + 500) ; coordinates of the head position
snake_tail_pos DWORD (OFFSET map + 500) ; coordinates of the tail position
fruit_pos DWORD ? ; coordinates of teh fruit position
gameOver BYTE 0 ; 0 if the game is not over, 1 if the game has ended


.code
main PROC
call Randomize
call MakeBoundary
call SpawnFruit

;Creates and positions the inital snake head/tail
call GetHeadCoordinates
mov dl, dl
mov dh, al
call Gotoxy
mov al, 's'
call WriteChar

;infinate loop
GameLoop:
call ReadKey
jz noKeyPressed

; compares the scan code of the pressed key and the direction character
mov bl, [direction]						
.IF (ah == 4Dh) && (bl != 'L')			; if the right arrow key is pressed but the current direction is not left
	mov direction, 'R'
.ELSEIF (ah == 4Bh) && (bl != 'R')		; if the left arrow key is pressed but the current direction is not right
	mov direction, 'L'
.ELSEIF (ah == 48h) && (bl != 'D')		; if the up arrow key is pressed but the current direction is not down
	mov direction, 'U'
.ELSEIF (ah == 50h) && (bl != 'U')		; if the down arrow key is pressed but the current direction is not up
	mov direction, 'D'
.ENDIF

noKeyPressed:
call MoveSnake

.IF gameOver == 1
	jmp Ex
.ENDIF

;Adds a 0.25 second delay between when the snake moves
mov eax, 250
call Delay
jmp GameLoop

Ex:
invoke ExitProcess,0
main ENDP
end main