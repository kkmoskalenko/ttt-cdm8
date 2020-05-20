asect 0

addsp -16

ldi r2, 2
ldi r3, 0xf3
readloop:
ld r3, r1 #get the cell address
 
shla r1	#if ready is 0: loop
bcc readloop

shra r1
ld r1, r0 #test the cell for emptiness
tst r0
bnz readloop

jsr sendStuff

dec r2 #change symbol

AIturn0:
ldi r3, 0xf4 #(rng io addr)

AIturn:

st r3, r2
ld r3, r1 #take rng and test it
ldi r0, 8

	cmp r0, r1
bls AIturn

ldi r3, table #get what's in the cell
add r1, r3
ldc r3, r1
push r1
ld r1, r1


tst r1 #test the cell for emptiness
pop r1	
bnz AIturn0


ldi r3, 0xf3 #(ttt io addr)

jsr sendStuff

inc r2 #change symbol

br readloop
#

gamestat: #overrites every reg
		  #output in r0 (bits 6 and 7)
	push r2
	ldi r3, table #init loop
	ldi r0, 9
	gsloop:
	if 
		dec r0 #iterate
	is z
	then
		pop r1 #if the number on top
		if     #of the stack is 0 
			tst r1 #then it's a draw
		is nz
			ldi r0, 0b11000000
		fi
		rts
	fi	
		
	push r0
	ldc r3, r0
	ld r0, r0
	inc r3
	
	ldc r3, r1 #r0, r1, r2 have thee symbols
	ld r1, r1  #of a single line
	inc r3	
	
	ldc r3, r2
	ld r2, r2
	inc r3
	if
		tst r0
	is z, or
		tst r1
	is z, or
		tst r2
	is z
	then
		pop r0 #if any one of them is 0
		pop r2 #set the flag on stack to 0 and loop
		clr r2
		push r2
		br gsloop
	fi
	
	if
		cmp r1, r2
	is ne, or
		cmp r0, r2
	is ne
	then
		pop r0 #if any pair is ne - loop
		br gsloop
	fi
	
	pop r0 #preventing stack overflow
	
	#choosing the winner
	if 
		dec r1
	is z
		ldi r0, 0b01000000
	else
		ldi r0, 0b10000000
	fi	
	pop r1 #preventing stack overflow
	
	rts
#
	
sendStuff:
	st r1, r2 #store the symbol
	
	save r1 #save everything bc gamestat
	save r2 #ovewrites all regs
	save r3
	jsr gamestat #checks for the game's end
	restore 
	restore
	restore
	
	#r1 has the cell addr bits
	#r2 has the symbol bits
	#r0 has the gamestate bits
	shla r1
	shla r1
	add r0, r1 #put package into r1
	add r2, r1
	
	st r3, r1 #send the package
	
	if
		tst r0 #if game ended, stop
	is nz
		halt
	fi

	rts
#

table: 
	dc 0,1,2 #h
	dc 4,5,6
	dc 8,9,10
	
	dc 0,4,8 #v
	dc 1,5,9
	dc 2,6,10
	
	dc 0,5,10 #d
	dc 8,5,2

end