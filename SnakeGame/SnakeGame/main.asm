INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
top_bottom_boundary BYTE "------------------------------------------------",0
side_boundary BYTE "-",0
map BYTE 874 DUP(0) ; an array the represents each point on the map
direction BYTE 'L' ;L: moving left, R: moving right, D: moving down, U: moving up
snake_head_pos DWORD (OFFSET map + 480) ; coordinates of the head position
snake_tail_pos DWORD (OFFSET map + 480) ; coordinates of the tail position
fruit_pos WORD ? ; coordinates of teh fruit position


.code
main PROC
call Randomize
call MakeBoundary
call SpawnFruit

;Creates and positions the inital snake head/tail
call GetHeadCoordinates
mov dl, al
mov dh, dl
call Gotoxy
mov al, 's'
call WriteChar

;infinate loop
GameLoop:
call ReadKey
jz noKeyPressed

cmp ah, 48h ; checks if up arrow key pressed
je move_up
cmp ah, 50h ; checks if down arrow key pressed
je move_down
cmp ah, 4Bh; checks if left arrow key pressed
je move_left
cmp ah, 4Dh ; checks if right arrow key pressed
je move_right 

;changes the direction variable depending on arrow key pressed
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

;Adds a 1 second delay between when the snake moves
mov eax, 1000
call Delay
jmp GameLoop

invoke ExitProcess,0
main ENDP

GetHeadCoordinates PROC
mov eax, snake_head_pos
sub eax, OFFSET map

xor edx, edx
mov ecx, 46
div ecx

ret
GetHeadCoordinates ENDP

GetTailCoordinates PROC
mov eax, snake_head_pos
sub eax, OFFSET map

xor edx, edx
mov ecx, 46
div ecx

ret
GetTailCoordinates ENDP

; The spawnFruit procedure does not currently work. I was just adding comments
; for all my code and didn't mean to add the spawnFruits procedure to my commit.
SpawnFruit PROC
LOCAL xpos:BYTE 
LOCAL ypos:BYTE
mov eax, 46
call RandomRange
inc eax

mov xpos, al

mov eax, 17
call RandomRange
inc eax

mov ypos, al

mov dl, xpos
mov dh, ypos
call Gotoxy
mov al, '@'
call WriteChar

mov BYTE PTR [fruit_pos + 1], dl
mov BYTE PTR fruit_pos, dh
ret
SpawnFruit ENDP

; Depending on the character in the direction variable, a specific procedure is called
MoveSnake PROC
.IF direction == 85
	call MoveUp
.ELSEIF direction == 68
	call MoveDown
.ELSEIF direction == 82
	call MoveRight
.ELSE
	call MoveLeft
.ENDIF
ret
MoveSnake ENDP

; moves the snake one space in the left direction
MoveLeft PROC
mov al, 's'
dec BYTE PTR [snake_head_pos + 1];snake_f_xpos
mov dl, BYTE PTR [snake_head_pos + 1];snake_f_xpos
mov dh, BYTE PTR snake_head_pos
call Gotoxy
call WriteChar
mov al, ' '
mov dl, BYTE PTR [snake_tail_pos + 1]
mov dh, BYTE PTR snake_tail_pos
call Gotoxy
call WriteChar

mov al, BYTE PTR [snake_head_pos + 1]
mov bl, BYTE PTR snake_head_pos

mov BYTE PTR [snake_tail_pos + 1], al
mov BYTE PTR snake_head_pos, bl

ret
MoveLeft ENDP

; Moves the snake one space right
MoveRight PROC
mov al, 's'
inc BYTE PTR [snake_head_pos + 1]
mov dl, BYTE PTR [snake_head_pos + 1]
mov dh, BYTE PTR snake_head_pos
call Gotoxy
call WriteChar
mov al, ' '
mov dl, BYTE PTR [snake_tail_pos + 1]
mov dh, BYTE PTR snake_tail_pos
call Gotoxy
call WriteChar

mov al, BYTE PTR [snake_head_pos + 1]
mov bl, BYTE PTR snake_head_pos

mov BYTE PTR [snake_tail_pos + 1], al
mov BYTE PTR snake_tail_pos, bl

ret
MoveRight ENDP

; Moves the snake one space down
MoveDown PROC
mov al, 's'
mov dl, BYTE PTR [snake_head_pos + 1]
inc BYTE PTR snake_head_pos
mov dh, BYTE PTR snake_head_pos
call Gotoxy
call WriteChar
mov al, ' '
mov dl, BYTE PTR [snake_tail_pos + 1]
mov dh, BYTE PTR snake_tail_pos
call Gotoxy
call WriteChar

mov al, BYTE PTR [snake_head_pos + 1]
mov bl, BYTE PTR snake_head_pos

mov BYTE PTR [snake_tail_pos + 1], al
mov BYTE PTR snake_tail_pos, bl

ret
MoveDown ENDP

; Moves the snake one space up
MoveUp PROC
mov al, 's'
mov dl, BYTE PTR [snake_head_pos + 1]
dec BYTE PTR snake_head_pos
mov dh, BYTE PTR snake_head_pos
call Gotoxy
call WriteChar
mov al, ' '
mov dl, BYTE PTR [snake_tail_pos + 1]
mov dh, BYTE PTR snake_tail_pos
call Gotoxy
call WriteChar

mov al, BYTE PTR [snake_head_pos + 1]
mov bl, BYTE PTR snake_head_pos

mov BYTE PTR [snake_tail_pos + 1], al
mov BYTE PTR snake_tail_pos, bl

ret
MoveUp ENDP

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