INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
top_bottom_boundary BYTE "------------------------------------------------",0
side_boundary BYTE "-",0
snake WORD 828 DUP(?)
	  WORD 140Ah ;x pos stored in the upper 8 bits and y pos stored in the lower 8 bits
direction BYTE 'L'
headIndex DWORD 828
snake_head_pos WORD 140Ah
snake_tail_pos WORD 140Ah
fXpos BYTE ? ;fruit x position
fYpos BYTE ? ;fruit y position


.code
main PROC
call MakeBoundary

mov dl, BYTE PTR [snake_head_pos + 1]
mov dh, BYTE PTR snake_head_pos
call Gotoxy
mov al, 's'
call WriteChar

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
.ELSEIF direction == 68
	call MoveDown
.ELSEIF direction == 82
	call MoveRight
.ELSE
	call MoveLeft
.ENDIF
ret
MoveSnake ENDP

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