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
	jmp move_right
.ELSEIF (ah == 4Bh) && (bl != 'R')		; if the left arrow key is pressed but the current direction is not right
	jmp move_left
.ELSEIF (ah == 48h) && (bl != 'D')		; if the up arrow key is pressed but the current direction is not down
	jmp move_up
.ELSEIF (ah == 50h) && (bl != 'U')		; if the down arrow key is pressed but the current direction is not up
	jmp move_down
.ENDIF

;changes the direction variable depending on arrow key pressed
jmp noKeyPressed
move_up:
mov direction, 'U'
jmp noKeyPressed
move_down:
mov direction, 'D'
jmp noKeyPressed
move_left:
mov direction, 'L'
jmp noKeyPressed
move_right:
mov direction, 'R'

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

; The spawnFruit procedure does not currently work. I was just adding comments
; for all my code and didn't mean to add the spawnFruits procedure to my commit.
SpawnFruit PROC
LOCAL xpos:BYTE				; local variable to hold x position
LOCAL ypos:BYTE				; local variable to hold y position
mov eax, 46					; moves 46 into eax so that the call to Rnadomrange generates a number from 0 to 45
call RandomRange
inc eax						; changes range to 1 to 46

mov xpos, al				; moves the random x pos into the xpos variable

mov eax, 17					; get a range from 0 to 16
call RandomRange
inc eax						; changes range to 1 to 17

mov ypos, al				; moves the random y pos into the ypos variable

mov dl, xpos				; positions the fruit col position
mov dh, ypos				; positions the fruit row position
call Gotoxy
mov al, '@'					; '@' char represents a fruit
call WriteChar

movzx eax, dh
imul eax, eax, 48
movzx ecx, dl
add eax, ecx
add eax, OFFSET map
mov [fruit_pos], eax		; moves the fruit position into the fruit_pos variable
ret
SpawnFruit ENDP

; Makes the boundary that the snake is confined too
MakeBoundary PROC
mov edx, OFFSET top_bottom_boundary
call WriteString

mov ecx, 19
mov bl, 1
mov dl, 0
mov dh, bl
L1:
call Gotoxy
mov edx, OFFSET side_boundary
call WriteString
inc ebx
mov dl, 0
mov dh, bl
LOOP L1

mov ecx, 19
mov bl, 1
mov dl, 47
mov dh, bl
L2:
call Gotoxy
mov edx, OFFSET side_boundary
call WriteString
inc ebx
mov dl, 47
mov dh, bl
LOOP L2

mov dl, 0
mov dh, 20
call Gotoxy

mov edx, OFFSET top_bottom_boundary
call WriteString

ret
MakeBoundary ENDP
end main