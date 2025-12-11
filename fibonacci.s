.section .data
format_string: .asciz "Fibonacci %d is: %d\n"

.section .text
.global main
.extern printf
.extern atoi

main:
    // Save FP and LR
    SUB SP, SP, #32
    STR X29, [SP, #0]
    STR X30, [SP, #8]
    STR X19, [SP, #16]
    STR XZR, [SP, #24]
    MOV X29, SP

    // Check if argc == 2
    CMP X0, #2
    B.NE exit

    // Load argv[1]
    LDR X0, [X1, #8]
    BL atoi

    // If n == 0, exit without output
    CMP X0, #0
    B.EQ exit

    // Load n and call fibonacci
    MOV X19, X0
    BL fibonacci

    // Call printf with fibonacci in x2 and n in x1
    MOV X2, X0
    LDR X0, =format_string 
    MOV X1, X19
    BL printf

exit:
    // Restore registers
    LDR X29, [SP, #0]
    LDR X30, [SP, #8]
    ADD SP, SP, #32

    // Terminate
    MOV X8, #93
    MOV X0, #0
    SVC #0

// Fibonacci Function - Recursive
fibonacci:
    // Save FP and LR; allocate space for n and fibonacci(n-1)
    SUB SP, SP, #32
    STR X29, [SP, #0]
    STR X30, [SP, #8]
    MOV X29, SP

    STR X0, [X29, #16]

    // Check for base cases (n == 1 or n == 2)
    CMP X0, #1
    B.EQ base_case
    CMP X0, #2
    B.EQ base_case

    // Compute fibonacci(n-1)
    SUB X0, X0, #1
    BL fibonacci
    STR X0, [X29, #24]

    // Compute fibonacci(n-2)
    LDR X0, [X29, #16]
    SUB X0, X0, #2
    BL fibonacci

    // Sum fibonacci(n-1) and fibonacci(n-2)
    LDR X1, [X29, #24]
    ADD X0, X1, X0
    B restore_fib

base_case:
    // For n==1 or n==2, fibonacci(n) = 1
    MOV X0, #1
    B restore_fib

restore_fib:
    // Restore FP and LR, deallocate stack for fibonacci
    LDR X29, [SP, #0]
    LDR X30, [SP, #8]
    ADD SP, SP, #32
    RET