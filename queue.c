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

void q_init(PCB_Q_t *q){
	q->head = 0;
	q->tail = 0;
}
	
void q_enqueue(PCB_Q_t *q, PCB_t *pcb){
	pcb->next = 0; 
	if (q->tail == 0){ // check if queue empty
		q->head = pcb; 
		q->tail = pcb; // pcb becomes head and tail
	}
	else{	// queue already has items
		q->tail->next = pcb;
		q->tail = pcb;	// attach pcb to end of queue and update tail
	}
}

PCB_t *q_dequeue(PCB_Q_t *q){

	// return null if queue empty
	if (q->head == 0){
		return 0;
	}
	// save current head then advance head to next item
	PCB_t *pcb = q->head;
	q->head = pcb->next;
	
	//if queue is now empty, update tail.
	if(q->head == 0){
		q->tail = 0;
	}
	// return dequeued pcb
	pcb->next = 0;
	return pcb;
}