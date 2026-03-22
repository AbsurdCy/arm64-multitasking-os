.global     box
box:
 
    // standard entry: save link and stack frame registers
    //    load the stack frame with the pointer to current frame
    stp     x29, x30, [sp, -16]!

    // Save the arguments.  Called functions may overwrite x0-x3
    sub     sp, sp, 32
    stp     x0, x1, [sp]
    stp     x2, x3, [sp, 16]

    // sr in w0, sc in w1, er int w2, ec in w3
    
    // Make sure the argument are valid

    bl      _box_check_box_
    cmp     w0, 0
    bne     _box_error_

 
    // first, draw the corners:
    // +        +
    // +        +
    ldp     x0, x1, [sp]
    ldp     x2, x3, [sp, 16]
    bl      _box_draw_corners_

    // Now, draw the top and bottom:
    // +------+
    // +------+

    // draw top/bottom
    ldp     x0, x1, [sp]
    ldp     x2, x3, [sp, 16]
    bl      _box_draw_top_bottom_

    // draw left/right
    ldp     x0, x1, [sp]
    ldp     x2, x3, [sp, 16]
    bl      _box_draw_right_left_

    mov     w0, 0
    b       _box_exit_

_box_error_:
    mov     w0, 1

_box_exit_:
    add     sp, sp, 32   // pop save arg regs

    ldp     x29, x30, [sp], 16
    ret

.global _box_check_box_
_box_check_box_:
    // SAVE REGISTER
    stp     x29, x30, [sp, -16]!

    // moving so that values are not overwritten
    mov     w4, w0   // start_row
    mov     w5, w1   // start_col
    mov     w6, w2   // end_row
    mov     w7, w3   // end_col

    bl      term_txtheight   // find txtheight

    cmp     w6, w0           // compare er and max rows
    b.ge    _check_error_     // jump if er is greater or equal

    cmp     w6, w4          // compare er and sr
    b.le    _check_error_    // jump if er is less or equal

    bl      term_txtwidth    // find txtwidth

    cmp     w7, w0          // compare ec and max cols
    b.ge    _check_error_

    cmp     w7, w5          // compaqre ec and sc
    b.le    _check_error_  


    mov     w0, 0
    ldp     x29, x30, [sp], 16 // pop

    ret

.global _box_draw_corners_

_check_error_:
    mov     w0, #1

    ret
_box_draw_corners_:

    // SAVE REGISTER
    stp     x29, x30, [sp, -16]!

    //save start/end row/col values
    mov     x5,x0  //sr
    mov     x6,x1  //sc
    mov     x7,x2  //er
    mov     x8,x3  //ec

    // top-left
    mov     x0,x5
    mov     x1,x6
    mov     w2, #'+'
    bl      putc_to

    //top-right
    mov     x0,x5
    mov     x1,x8
    mov     w2, #'+'
    bl      putc_to

    //bottom-left
    mov     x0,x7
    mov     x1,x6
    mov     w2, #'+'
    bl      putc_to

    //bottom-right
    mov     x0,x7
    mov     x1,x8
    mov     w2, #'+'
    bl      putc_to
    
    ldp     x29, x30, [sp], 16 // pop
    ret

.global _box_draw_top_bottom_
_box_draw_top_bottom_:
    // SAVE REGISTER
    stp     x29, x30, [sp, -16]!

    //save start/end row/col values
    mov     w5,w0  //sr
    mov     w6,w1  //sc
    mov     w7,w2  //er
    mov     w8,w3  //ec 

    add     w9, w6, #1 // w9 = sc + 1
    sub     w8, w8, #1 // w8 = ec - 1
_rows_loop_:
    cmp     w9, w8
    b.gt    _rows_loop_done_

    // top line
    mov     w0, w5
    mov     w1, w9
    mov     w2, #'-'
    bl      putc_to

    //bottom line

    mov     w0, w7
    mov     w1, w9
    mov     w2, #'-'
    bl      putc_to

    add     w9, w9, #1
    b       _rows_loop_

_rows_loop_done_:
    ldp     x29, x30, [sp], 16 // pop
    ret
    
.global _box_draw_right_left_
_box_draw_right_left_:

    // SAVE REGISTER
    stp     x29, x30, [sp, -16]!

    //save start/end row/col values
    mov     w5,w0  //sr
    mov     w6,w1  //sc
    mov     w7,w2  //er
    mov     w8,w3  //ec 

    mov     w9, w5      // w9 = sr
    add     w9, w9, #1  // start just below top corner
    sub     w7, w7, #1  // stop just above bottom corner

_cols_loop_:
    cmp     w9, w7
    b.gt    _cols_loop_done_

    // left line
    mov     w0, w9
    mov     w1, w6
    mov     w2, #'|'
    bl  putc_to

    //right line

    mov     w0, w9
    mov     w1, w8
    mov     w2, #'|'
    bl      putc_to

    add     w9, w9, #1
    b       _cols_loop_
_cols_loop_done_:
    ldp     x29, x30, [sp], 16 // pop
    ret