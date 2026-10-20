INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
top_bottom_boundary BYTE "------------------------------------------------",0
side_boundary BYTE "-",0
snake BYTE "s",0
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


invoke ExitProcess,0
main ENDP




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