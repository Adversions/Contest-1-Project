INCLUDE Irvine32.inc


HitBoundary PROTO
AteFruit PROTO
UpdateCoordinates PROTO
GetHeadCoordinates PROTO
GetTailCoordinates PROTO
SpawnFruit PROTO
MoveSnake PROTO
MoveLeft PROTO
MoveRight PROTO
MoveDown PROTO
MoveUp PROTO
MakeBoundary PROTO
EXTERNDEF top_bottom_boundary:BYTE
EXTERNDEF side_boundary:BYTE
EXTERNDEF direction:BYTE
EXTERNDEF snake_head_pos:DWORD
EXTERNDEF snake_tail_pos:DWORD
EXTERNDEF gameOver:BYTE
EXTERNDEF fruit_pos:DWORD
EXTERNDEF map:BYTE
ExitProcess proto,dwExitCode:dword