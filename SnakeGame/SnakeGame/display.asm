INCLUDE snakegame.inc

.code
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
END