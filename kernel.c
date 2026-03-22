#include "libos.h"
#include "stdint.h"

typedef struct pcb {
	uint64_t sp; //stack ptr
	uint32_t pid; //process id
	struct pcb *next; //ptr to next pcb in queue
}PCB_t;

typedef struct pcb_q {
	PCB_t *head; //ptr to first element to be dequeued
	PCB_t *tail; //ptr to last element added
}PCB_Q_t;

PCB_Q_t Ready_q; 
PCB_t *Running;   		
int next_pid = 0;

void q_init(PCB_Q_t *q);
void q_enqueue(PCB_Q_t *q, PCB_t *pcb);
PCB_t *q_dequeue(PCB_Q_t *q); 

int spawn_process(int (*code_address)());

int p1();
int p2();
int p3();
int p4();


extern int box(unsigned int srow, unsigned int scol, unsigned int erow, unsigned int ecol);

/*int box(unsigned unsigned int srow, unsigned unsigned int scol, unsigned unsigned int erow, unsigned unsigned int ecol);*/

 int clear_scr(unsigned int srow, unsigned int scol, unsigned int erow, unsigned int ecol){
	for (unsigned int r=srow; r <= erow; r++){
		for (unsigned int c=scol; c <= ecol; c++){
			putc_to(r, c, ' ');
		}

	}

	return 0;
}

void dispatch_select(){
	Running = q_dequeue(&Ready_q); //dequeue running process
	if (Running == 0){
		print_to(0,0, "Error during dispatch");
		while(1); // throw err
	}

}
 

int main(){
	clear_scr(0,0, term_txtheight()-1, term_txtwidth()-1);
	print_to(0,0, "Running processes...");

	q_init(&Ready_q);//initialize ready queue

	
	int retval = spawn_process(p1);// set retval to return value
	
	if (retval != 0){
		print_to(0,0, "Error spawning process p1.");
		while(1);//error
	}

	retval = spawn_process(p2);// set retval to return value
	
	if (retval != 0){
		print_to(0,0, "Error spawning process p2.");
		while(1);//error
	}


	retval = spawn_process(p3);// set retval to return value
	
	if (retval != 0){
		print_to(0,0, "Error spawning process p3.");
		while(1);//error
	}


	retval = spawn_process(p4);// set retval to return value
	
	if (retval != 0){
		print_to(0,0, "Error spawning process p4.");
		while(1);//error
	}

	asm volatile("b restore_context");

}


//TESTING
/*unsigned int main(){
    clear_scr(0, 0, 40, 120);
    prunsigned int_to(10, 10, "CLEAR SCR WORKS");
    return 0;
}*/

