// ARM64 Assembly - Fibonacci 
.text
.global _start
.align 2

fibonacci:
    stp     X29, X30, [SP, #-48]!
    mov     X29, SP
    stp     X19, X20, [SP, #16]
    
    cmp     X0, #0
    b.eq    fib_base0
    cmp     X0, #1
    b.eq    fib_base1
    
    mov     X19, X0
    sub     X0, X0, #1
    bl      fibonacci
    mov     X20, X0
    sub     X0, X19, #2
    bl      fibonacci
    add     X0, X20, X0
    b       fib_end

fib_base0:
    mov     X0, #0
    b       fib_end

fib_base1:
    mov     X0, #1

fib_end:
    ldp     X19, X20, [SP, #16]
    ldp     X29, X30, [SP], #48
    ret

_start:
    // Check if argument exists
    ldr     X0, [X1, #8]
    cbz     X0, no_input          // Exit if no input provided
    
    // Convert and validate input
    bl      atoi
    mov     X19, X0
    
    // Compute Fibonacci
    bl      fibonacci
    mov     X20, X0
    
    // Print result
    adr     X0, fmt
    mov     X1, X19
    mov     X2, X20
    bl      printf
    
    // Explicit exit
    mov     X0, #0
    b       exit

no_input:
    adr     X0, usage
    bl      printf

exit:
    mov     X0, #0
    mov     X8, #93                
    svc     #0                    

.data
fmt:    .asciz "Fibonacci %d is: %d\n"
usage:  .asciz "Usage: ./fibonacci <positive_integer>\n"
