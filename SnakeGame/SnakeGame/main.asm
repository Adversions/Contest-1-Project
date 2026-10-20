INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
top_bottom_boundary BYTE "------------------------------------------------",0
side_boundary BYTE "-",0
snake BYTE "s",0
direction BYTE 'R'
sXpos BYTE 20
sYpos BYTE 10

.code
main PROC
call MakeBoundary

mov dl, sXpos
mov dh, sYpos
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

jmp GameLoop

invoke ExitProcess,0
main ENDP

MoveSnake PROC
.IF 85 == direction
	call MoveUp
.ELSEIF 69 == direction
	call MoveDown
.ELSEIF 82 == direction
	call MoveRight
.ELSE
	call MoveLeft
MoveSnake ENDP


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