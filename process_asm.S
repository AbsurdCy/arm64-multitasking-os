.global dispatch
.global restore_context

dispatch:

    //sub 16*16 from the stack
    sub      sp, sp, 16*16

//copy all registers

    stp      x0, x1, [sp]
    stp      x2, x3, [sp,16]
    stp      x4, x5, [sp,32]
    stp      x6, x7, [sp,48]
    stp      x8, x9, [sp,64]
    stp      x10, x11, [sp,80]
    stp      x12, x13, [sp,96]
    stp      x14, x15, [sp,112]
    stp      x16, x17, [sp, 128]
    stp      x18, x19, [sp, 144]
    stp      x20, x21, [sp, 160]
    stp      x22, x23, [sp, 176]
    stp      x24, x25, [sp, 192]
    stp      x26, x27, [sp, 208]
    stp      x28, x29, [sp, 224]
    str      x30, [sp, 240]

	mrs x0, SPSR_EL1      // Save PSTATE
    str x0, [sp, 16*15+8]

    //store new sp value into pcb
    adr     x1, Running
    ldr     x1, [x1]  
    mov     x4, sp    
    str     x4, [x1]  

    //pass address of ready_q and the value of running before calling enqueue
    adr     x0, Ready_q
    adr     x1, Running
    ldr     x1, [x1] //dereference Running to get value rather than address
    bl      q_enqueue

restore_context:

    bl      dispatch_select
        
    //read the sp value out of the pcb at which Runnning points and put into sp register
    adr     x1, Running
    ldr     x0, [x1]
    ldr     x2, [x0]
    mov		sp, x2

    //restore PSTATE
    ldr     x0, [sp, 16*15+8]   
    msr     SPSR_EL1, x0

    //load pairs back into registers
    ldp      x0, x1, [sp]
    ldp      x2, x3, [sp,16]
    ldp      x4, x5, [sp,32]
    ldp      x6, x7, [sp,48]
    ldp      x8, x9, [sp,64]
    ldp      x10, x11, [sp,80]
    ldp      x12, x13, [sp,96]
    ldp      x14, x15, [sp,112]
    ldp      x16, x17, [sp, 128]
    ldp      x18, x19, [sp, 144]
    ldp      x20, x21, [sp, 160]
    ldp      x22, x23, [sp, 176]
    ldp      x24, x25, [sp, 192]
    ldp      x26, x27, [sp, 208]
    ldp      x28, x29, [sp, 224]
    ldr      x30, [sp, 240]


    //add 16*16 back to the stack
    add      sp, sp, 16*16

    ret