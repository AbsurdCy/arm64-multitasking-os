all: kernel.elf

# kernel.elf <- kernel.o, boot.o, box.o, process.o, queue.o, process.asm.o libos.a
kernel.elf: kernel.o boot.o box.o process.o queue.o process_asm.o libos.a
	aarch64-linux-gnu-ld -g -N -Ttext=0x10000 -o kernel.elf kernel.o boot.o box.o process.o queue.o process_asm.o libos.a

# kernel.o <- kernel.c
kernel.o: kernel.c
	aarch64-linux-gnu-gcc -g -pedantic -Wall -Wextra -fPIC -std=gnu2x -MMD -c kernel.c -o kernel.o

# boot.o <- boot.S
boot.o: boot.S
	aarch64-linux-gnu-gcc -g -MMD -c boot.S -o boot.o

# box.o <- box.S
box.o: box.S
	aarch64-linux-gnu-gcc -g -MMD -c box.S -o box.o

#process.o <- process.c
process.o: process.c
	aarch64-linux-gnu-gcc -g -pedantic -Wall -Wextra -fPIC -std=gnu2x -MMD -c process.c -o process.o

#queue.o <- queue.c
queue.o: queue.c
	aarch64-linux-gnu-gcc -g -pedantic -Wall -Wextra -fPIC -std=gnu2x -MMD -c queue.c -o queue.o

# process_asm.o <- process_asm.S
process_asm.o: process_asm.S
	aarch64-linux-gnu-gcc -g -MMD -c process_asm.S -o process_asm.o

#make run
run: kernel.elf
	qemu-system-aarch64 -machine raspi3b -cpu cortex-a53 -kernel kernel.elf

#make debug
debug: kernel.elf 
	qemu-system-aarch64 -machine raspi3b  -S -s -kernel kernel.elf &
	ddd --debugger 'gdb-multiarch -ex "target remote localhost:1234" -ex "break main" -ex "continue"' kernel.elf

#make clean
clean:
	rm kernel.elf *.o *.d
