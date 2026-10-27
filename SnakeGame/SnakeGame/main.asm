INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
top_bottom_boundary BYTE "------------------------------------------------",0
side_boundary BYTE "-",0
map BYTE 874 DUP(0) ; an array the represents each point on the map
direction BYTE 'L' ;L: moving left, R: moving right, D: moving down, U: moving up
snake_head_pos DWORD (OFFSET map + 480) ; coordinates of the head position
snake_tail_pos DWORD (OFFSET map + 480) ; coordinates of the tail position
fruit_pos DWORD ? ; coordinates of teh fruit position


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

; Checks if a fruit has been eaten
AteFruit PROC
mov eax, [snake_head_pos] ; position of the head put in eax
mov ebx, [fruit_pos]      ; position of the fruit put in ebx

.IF eax == ebx            ; if they equal, spawns another fruit
	call SpawnFruit
.ENDIF
ret
AteFruit ENDP

UpdateCoordinates PROC
cmp bl, 'H' ; Depending on wether the head('H') or tail('T') is being updated
jz updateHead

push edx
mov edx, [snake_tail_pos]   ; Moves the snake_tail_pos contents into edx
mov al, [edx]				; Moves what char is at the tail_pos on map into al (Ex. 'L' or 'R')
mov BYTE PTR [edx], 0		; Sets that position in the map to zero
pop edx

; Checks what character was at the tail_pos
.IF al == 85
	dec dh ; moved up
.ELSEIF al == 68
	inc dh ; moved down
.ELSEIF al == 82
	inc dl ; moved right
.ELSE
	dec dl ; moved left
.ENDIF

updateHead:					; jumps here if the head is being updated
movzx eax, dh				; moves the row (y pos) into eax
imul eax, eax, 46			; multiplies it by 46 (length of a row) to get to the correct row on map

movzx ecx, dl				; moves the column (x pos) into ecx
add eax, ecx				; adds the column pos to eax to get the correct row and col on the map

add eax, OFFSET map			; adds the offset of map to eax
cmp bl, 'T'
jz tail
mov bl, [direction]			; moves the direction character into bl
mov edx, [snake_head_pos]	; moves the old snake head pos into edx
mov [edx], bl ; moves direction char to old position of head so the tail know where to go
mov [snake_head_pos], eax	;moves the new head pos into the snake_head_pos variable
call AteFruit
ret
tail:
mov [snake_tail_pos], eax	;moves the new tail pos into the snake_tail_pos variable
ret
UpdateCoordinates ENDP

; Moves the row index into eax and the col index into edx
GetHeadCoordinates PROC
mov eax, snake_head_pos		; moves the memory location of snake_head_pos into eax
sub eax, OFFSET map			; removes the map offset

xor edx, edx				; clears the edx reg
mov ecx, 46
div ecx						; divides eax by 46

ret
GetHeadCoordinates ENDP

; Moves the row index into eax and the col index into edx
GetTailCoordinates PROC
mov eax, snake_tail_pos		; moves the memore location of snake_tail_pos in eax
sub eax, OFFSET map			; removes the map offset

xor edx, edx				; clears the edx reg
mov ecx, 46
div ecx						; divides eax by 46

ret
GetTailCoordinates ENDP

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
imul eax, eax, 46
movzx ecx, dl
add eax, ecx
add eax, OFFSET map
mov [fruit_pos], eax		; moves the fruit position into the fruit_pos variable
ret
SpawnFruit ENDP

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

call GetTailCoordinates		; gets the tail coordinates into eax and edx
mov dl, dl					; The tail col pos get decrimented in the updateCoordinates proc
mov dh, al
call Gotoxy
mov al, ' '
call WriteChar
mov bl, 'T'					;  moves the 'T' char into bl reg so updateCoordinates proc knows its updating the head pos
call UpdateCoordinates

ret
MoveLeft ENDP

; Moves the snake one space right
MoveRight PROC
call getHeadCoordinates		; get the head coordinates into eax and edx
inc dl						; increments the col pos
mov dl, dl
mov dh, al
call Gotoxy
mov al, 's'
call WriteChar
mov bl, 'H'					; moves the 'H' char into bl reg so updateCoordinates proc knows its updating the head pos
call UpdateCoordinates

call GetTailCoordinates		; gets the tail coordinates into eax and edx
mov dl, dl					; The tail col pos get incremented in the updateCoordinates proc
mov dh, al
call Gotoxy
mov al, ' '
call WriteChar
mov bl, 'T'					; moves the 'T' char into bl reg so updateCoordinates proc knows its updating the head pos
call UpdateCoordinates

ret
MoveRight ENDP

; Moves the snake one space down
MoveDown PROC
call GetHeadCoordinates
mov dl, dl
inc al
mov dh, al
call Gotoxy
mov al, 's'
call WriteChar
mov bl, 'H'
call UpdateCoordinates

call GetTailCoordinates
mov dl, dl
mov dh, al
call Gotoxy
mov al, ' '
call WriteChar
mov bl, 'T'
call UpdateCoordinates

ret
MoveDown ENDP

; Moves the snake one space up
MoveUp PROC
call GetHeadCoordinates
mov dl, dl
dec al
mov dh, al
call Gotoxy
mov al, 's'
call WriteChar
mov bl, 'H'
call UpdateCoordinates

call GetTailCoordinates
mov dl, dl
mov dh, al
call Gotoxy
mov al, ' '
call WriteChar
mov bl, 'T'
call UpdateCoordinates

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