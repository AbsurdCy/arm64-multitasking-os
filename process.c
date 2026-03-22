#include "libos.h"
#include "stdint.h"

#define MAX_PROCESSES 4    // maximum number of processes
#define STACK_SIZE 1024    // size of each stack

typedef struct pcb {
	uint64_t sp; //stack ptr
	uint32_t pid; //process id
	struct pcb *next; //ptr to next pcb in queue
}PCB_t;

typedef struct pcb_q {
	PCB_t *head; //ptr to first element to be dequeued
	PCB_t *tail; //ptr to last element added
}PCB_Q_t;

extern int next_pid;
extern PCB_Q_t Ready_q; 
extern PCB_t *Running;
extern void q_enqueue(PCB_Q_t *q, PCB_t *pcb);
extern PCB_t *q_dequeue(PCB_Q_t *q);
extern void dispatch();
int box(unsigned int srow, unsigned int scol, unsigned int erow, unsigned int ecol);

//arrays for stacks and pcbs
uint64_t stacks[MAX_PROCESSES][STACK_SIZE];
PCB_t pcbs[MAX_PROCESSES];

int stack_index = 0;
int pcb_index = 0;

// allocate a stack from the static array
uint64_t *alloc_stack(int size){
	(void)size;
    if(stack_index >= MAX_PROCESSES){
		return 0;
	}  //return null if no stacks left
    return stacks[stack_index++]; 
}

// allocate a pcb from the static array
PCB_t *alloc_pcb(){
    if(pcb_index >= MAX_PROCESSES){
		return 0; 
	} // return null if no pcbs left
    return &pcbs[pcb_index++];  
}



int spawn_process(int (*code_address)()) {

	//create stack
	uint64_t *stackptr = alloc_stack(1024);
	//check that stackptr is not null
	if (stackptr == 0){
		return -1;
	}
	
	uint64_t *sp = stackptr+1024;

	for (int i = 0; i <= 32; i++){
		sp--;
		*sp = 0;

	}
	*(sp+30) = (uint64_t)code_address;
	PCB_t *pcb = alloc_pcb();//allocate pcb for process
	//check if pcb = null
	if (pcb == 0){
    	return -1; 
	}

	pcb->sp = (uint64_t)sp;
	pcb->pid = next_pid;
	next_pid++;
	
	q_enqueue(&Ready_q, pcb);

	return 0;
}

int is_prime(unsigned long long n) {
	if (n < 2){
		return 0;
	}

	for(unsigned long long i=2; i <= n/2; i++){
		dispatch();
		if (n%i == 0){
			return 0;

		}
		
	}
	return 1;
	
}

//process 1
int p1(){

	char message[] = "Process 1: 0";
	// print box for p1
	box(9,23,11,39);
	//print msg
	print_to(10,25, message);
	unsigned long long num = 1;
	int count = 0;

	while(1){
		//if number is prime, add one to count, and set the message to the count
		if(is_prime(num)){
			count++;
			char countc = count + '0';
			message[11] = countc;
		}
		//print the count
		print_to(10, 25, message);
		num++;

		if(count >= 9){
			count=0;
		}
		if(num > (unsigned long long)4000000000){ //cast to unsigned long long
			num=1;
		}
	}
	

}

//process 2
int p2(){

	char message[] = "Process 2: 0";
	// print box for p2
	box(13,23,15,39);
	//print msg
	print_to(14,25, message);
	unsigned long long num = 1;
	int count = 0;

	while(1){
		//if number is prime, add one to count, and set the message to the count
		if(is_prime(num)){
			count++;
			char countc = count + '0';
			message[11] = countc;
		}
		//print the count
		print_to(14, 25, message);
		num++;

		if(count >= 9){
			count=0;
		}
		if(num > (unsigned long long)4000000000){ //cast to unsigned long long
			num=1;
		}
	}
	

}

//process 3
int p3(){

	char message[] = "Process 3: 0";
	// print box for p3
	box(9,49,11,65);
	//print msg
	print_to(10,51, message);
	unsigned long long num = 1;
	int count = 0;

	while(1){
		//if number is prime, add one to count, and set the message to the count
		if(is_prime(num)){
			count++;
			char countc = count + '0';
			message[11] = countc;
		}
		//print the count
		print_to(10, 51, message);
		num++;

		if(count >= 9){
			count=0;
		}
		if(num > (unsigned long long)4000000000){ //cast to unsigned long long
			num=1;
		}
	}
	

}

//process 4
int p4(){

	char message[] = "Process 4: 0";
	// print box for p4
	box(13,49,15,65);
	//print msg
	print_to(14,51, message);
	unsigned long long num = 1;
	int count = 0;

	while(1){
		//if number is prime, add one to count, and set the message to the count
		if(is_prime(num)){
			count++;
			char countc = count + '0';
			message[11] = countc;
		}
		//print the count
		print_to(14, 51, message);
		num++;

		if(count >= 9){
			count=0;
		}
		if(num > (unsigned long long)4000000000){ //cast to unsigned long long
			num=1;
		}
	}
	

}
