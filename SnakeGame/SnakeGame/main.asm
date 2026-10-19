; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.code
AddThree PROC
mov eax,3
add eax,6

invoke ExitProcess,0
AddThree ENDP
end AddThree