asect 0


ldi r3, 0
ldi r1, 0xf3

loop11:
ldi r2, 0
	loop12:
	ldi r0, 0
	add r3, r0
	shla r0
	shla r0
	add r2, r0
	shla r0
	shla r0
	inc r0
	inc r0
	st r1, r0
	inc r2
	ldi r0, 2
	sub r2, r0
	ble loop12
inc r3
ldi r0, 2
sub r3, r0
ble loop11

ldi r3, 0
ldi r1, 0xf3

loop21:
ldi r2, 0
	loop22:
	ldi r0, 0
	add r3, r0
	shla r0
	shla r0
	add r2, r0
	shla r0
	shla r0	
	st r1, r0
	inc r2
	ldi r0, 2
	sub r2, r0
	ble loop22
inc r3
ldi r0, 2
sub r3, r0
ble loop21

halt

end
