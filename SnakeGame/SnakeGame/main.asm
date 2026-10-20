INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
top_bottom_boundary BYTE "------------------------------------------------",0
side_boundary BYTE "-",0
snake BYTE "s",0
direction BYTE 'U'
snake_f_Xpos BYTE 20 ;front x position
snake_f_Ypos BYTE 10 ;front y position
snake_e_Xpos BYTE 20 ;end x position
snake_e_Ypos BYTE 10 ;end y position


.code
main PROC
call MakeBoundary

mov dl, snake_f_Xpos
mov dh, snake_f_Ypos
call Gotoxy
mov edx, OFFSET snake
call WriteString

GameLoop:
call ReadKey
jz noKeyPressed

cmp ah, 48h
je move_up
cmp ah, 50h
je move_down
cmp ah, 4Bh
je move_left
cmp ah, 4Dh
je move_right 

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

mov eax, 1000
call Delay
jmp GameLoop

invoke ExitProcess,0
main ENDP

MoveSnake PROC
.IF direction == 85
	call MoveUp
.ELSEIF direction == 69
	;call MoveDown
.ELSEIF direction == 82
	;call MoveRight
.ELSE
	;call MoveLeft
.ENDIF
ret
MoveSnake ENDP

MoveUp PROC
mov al, 's'
mov dl, snake_f_xpos
dec snake_f_ypos
mov dh, snake_f_ypos
call Gotoxy
call WriteChar
mov al, ' '
mov dl, snake_e_xpos
mov dh, snake_e_ypos
call Gotoxy
call WriteChar

mov al, snake_f_xpos
mov bl, snake_f_ypos

mov snake_e_xpos, al
mov snake_e_ypos, bl

ret
MoveUp ENDP

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