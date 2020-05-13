asect 0
cells:
#dc 0, 0, 0, 0
#dc 0, 0, 0, 0
#dc 0, 0, 0, 0
#dc 0, 0, 0, 0

addsp -16

ldi r2, 1
readloop:
ldi r3, 0xf3
ld r3, r1 #get the cell address
 
ldi r3, 0x80
add r3, r1	#if carry is clear: loop
bcc readloop

ld r1, r3
tst r3
bnz readloop
st r1, r2 #store the symbol

ldi r3, 3
xor r3, r2 #swap symbol

save r1
save r2
jsr gamestat
restore
restore

shla r1
shla r1
add r0, r1 #r1 has the cell addr bits
add r2, r1 #r2 has the symbol bits
	#r0 has the gamestate bits

ldi r3, 0xf3 #ttt io addr
st r3, r1

if
	tst r0
is nz
	halt
fi

br readloop

gamestat: #probably overrites every reg
		  #output in r0
	push r3
	ldi r3, table
	ldi r0, 9
	gsloop:
	if 
		dec r0
	is eq
	then
		clr r0
		pop r3
		rts
	fi	
		
	ldc r3, r1
	ld r1, r1
	inc r3
	ldc r3, r2
	ld r2, r2
	inc r3	
	if
		cmp r1, r2
	is ne, or
		tst r1
	is z, or
		tst r2
	is z
	then
		inc r3
		br gsloop
	fi
	
	ldc r3, r1
	ld r1, r1
	inc r3
	tst r1
	bz gsloop
	
	cmp r1, r2
	bnz gsloop
	
	ldi r0, 0b01000000
	pop r3
	rts
	

table: 
	dc 0,1,2 #h
	dc 4,5,6
	dc 8,9,10
	
	dc 0,4,8 #v
	dc 1,5,9
	dc 2,6,10
	
	dc 0,5,10 #d
	dc 8,5,2

asect 0xf3
iostuff:
#dc 0b10000101
end