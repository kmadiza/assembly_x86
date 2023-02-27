section .text

global binary

; Given arguments
%define		img				[ebp+8]
%define		_x0				[ebp+12]
%define		_x1				[ebp+16]
%define		_y0				[ebp+20]
%define		_y1				[ebp+24]
%define		tresh			[ebp+28]



binary:
push	ebp
mov	ebp, esp
sub    esp, 0
push esi
push ebx
push edx

mov esi, img ;loading bmp
mov edx, 0  ; used for most calculations
mov ecx, 0 ;line counter
mov ebx, 0 ;position index
find_start:
mov eax, 960
mov edx, _y0 ;loading starting position
mul edx
add esi, eax
add ebx, eax ;moving to the starting line y0
mov eax,_x0 ;loading starting position x0
mov edx, 3
mul edx
add esi, eax
add ebx, eax ;moving to first coordinate x0, y0
get_red:
mov eax, 0
mov al, BYTE[esi] ; reading red color
mov edx, 21 ; starting calculations for the output color
mul edx
mov edi, eax
get_green:
inc esi ;next value of color
inc ebx
mov eax, 0; we zero eax because we want only to get the part of color that is green
mov al, BYTE[esi]
mov edx, 72
mul edx
add edi, eax ; edi can be used as general purpose register

get_blue:
inc esi ;next value of color
inc ebx
mov eax, 0
mov al, BYTE[esi]
mov edx, 7
mul edx
add edi, eax ;calculated output to be compared with tresh, we store it at edi, because it doesnt change with mul operations

compare_with_thresh:
mov eax, tresh ;loading tresh
mov edx, 100 ;because i want to ommit floating points tresh value is multiplied by 100
mul edx
cmp edi, eax ;decision which color will be put.
jg change_W

cmp edi, eax
jle change_B

;jmp test

back:
add esi, 3  ; setting next pixel
add ebx, 3
mov edx,_y0

add edx,ecx ; adding value of our line counter
mov eax,960
mul edx
mov edi,eax 

mov eax,3
mov edx,_x1 
mul edx     
add edi,eax    ; (y0+ line number)*960+ x1*3, so we can compare pixels in the line
cmp ebx,edi

jl get_red ;if still smaller than x1 in chosen line
cmp ebx, edi

jge next_line;if our pixel is greater of equal to x1 we go to next line
jg test

next_line:
mov eax,3
mov edx,_x1
mul edx
mov edi,eax
mov eax,960
mov edx,_y1
mul edx
add edi,eax ; loading our values x1,y1 and calculating their "address"


cmp ebx, edi ; checking if we got to the end of the working space for the color change
jge exit        ;if our pixels got to this value the end of the program.

add esi, 960    ;setting next line
add ebx, 960
mov eax, _x1
mov edx, _x0
sub eax, edx    ;because we jump straight up we need to do x1-x0 so we get back to the x0 in the line
mov edx, 3
mul edx
sub esi, eax    ; we go back both in the picture and in our counter
sub ebx, eax
inc ecx         ; because we got to the next line we need to increment our line counter

jmp get_red     ; after this jump we will starting reading colors from the x0, y0+line counter


exit:       ;the end of the program
pop edx
pop ebx
pop esi		
mov	eax, eax
pop	ebp
ret



change_W:
mov BYTE[esi], 255 ;changing colors to white,
sub esi, 1  ; because we incremented them while reading them, we have to go back and change previous colors
sub ebx,1
mov BYTE[esi], 255
sub esi,1 
sub ebx,1
mov BYTE[esi], 255
jmp back

change_B:
mov BYTE[esi], 0
sub esi, 1
sub ebx,1
mov BYTE[esi], 0
sub esi,1 
sub ebx,1
mov BYTE[esi], 0
jmp back

test:
mov eax, 10
jmp exit