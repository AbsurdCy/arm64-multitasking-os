# Cooperative Multitasking OS

A bare-metal ARM64 operating system kernel implementing cooperative multitasking. Written for a Raspberry Pi 3B target and run on QEMU. Implements process creation, a ready queue, context switching, and four concurrent processes that each count prime numbers on screen.

This was built as a course assignment for CSC 4100.

## Setup

You will need aarch64-linux-gnu-gcc and qemu-system-aarch64 installed.

To build: `make`

To run: `make run`

To debug with GDB/DDD: `make debug`

To clean: `make clean`

## How It Works

### Process Creation
spawn_process() in process.c allocates a static stack and PCB for a new process, sets up an initial register context on the stack with all registers zeroed (except x30 which is set to the process entry point), and enqueues the PCB onto the ready queue.

### Ready Queue
queue.c implements a linked-list queue of PCBs with q_init(), q_enqueue(), and q_dequeue(). The queue uses a next pointer embedded directly in the PCB struct so no dynamic memory allocation is needed. No standard library calls are used.

### Context Switching
dispatch() and restore_context in process_asm.S handle context switching in ARM64 assembly. dispatch() saves all general purpose registers and PSTATE onto the current process's stack, stores the new sp into the PCB, enqueues the current process, then falls through to restore_context. restore_context calls dispatch_select() to dequeue the next process, loads its saved sp, restores PSTATE and all registers, and returns into the next process.

### Kernel Main
kernel.c initializes the screen, calls q_init(), spawns four processes, then jumps directly to restore_context via inline assembly to start the first process running. It never returns.

### Processes
The four processes (p1-p4) are defined in process.c. Each draws a box on screen and counts prime numbers in an infinite loop, printing the running count inside its box. The prime checker calls dispatch() on every iteration so processes yield cooperatively. Processes 1 and 2 are in the left half of the screen, processes 3 and 4 are on the right.

## Files

- kernel.c — main entry point, process spawning, dispatch_select
- process.c — spawn_process, process functions p1-p4, prime checker
- queue.c — PCB queue implementation
- process_asm.S — dispatch and restore_context in ARM64 assembly
- boot.S — boot code
- box.S — draws a box on the terminal
- libos.h / libos.a — OS library providing print_to, putc_to, term_txtheight, term_txtwidth
- makefile — builds and runs the kernel with QEMU
