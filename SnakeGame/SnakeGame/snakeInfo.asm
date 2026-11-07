INCLUDE snakegame.inc

.code
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
imul eax, eax, 48			; multiplies it by 46 (length of a row) to get to the correct row on map

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
call HitBoundary
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
mov ecx, 48
div ecx						; divides eax by 46

ret
GetHeadCoordinates ENDP

END