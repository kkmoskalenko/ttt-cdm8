asect 0x00

ldi r3, io_addr

readloop:
ld r3, r0
ldi r1, 0x80
add r0, r1
bls readloop

shla r0
shla r0
ldi r1, 3
add r1, r0
st r3, r0
br readloop



asect 0xf3
io_addr:
	dc 0b10000101
	
end

