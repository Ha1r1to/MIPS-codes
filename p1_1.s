# Data segment
.data
A:  .word 10      # Variable A, initialized to 10
B:  .word 2       # Variable B, initialized to 6
modulo: .word 0   # Variable modulo, initialized to 0
.globl main
# Text segment
.text
main:
    # Initialize modulo with A
    lw $t0, A     # $t0 = A
    sw $t0, modulo # modulo = A
    
    loop:
        # Compare modulo with B
        lw $t1, B       # $t1 = B
        lw $t0, modulo  # $t0 = modulo
        # Load arguments
        move $a0, $t0        # $a0 = A
        move $a1, $t1        # $a1 = B

        # Call compare function and store result in modulo
        jal compare     # Call compare function
        sw $v0, modulo  # Store result in modulo
        
        #move $a0, $v0        # a0 = modulo

        bgt $t1, $t0, exit_loop # If B > modulo, exit loop

        j loop          # Go back to loop
        
    exit_loop:
        # Program finished
        li $v1, 10      # Set system call number to exit
        syscall         # Exit program

# compare function
compare:
    addi $sp, $sp, -4   # Allocate space on the stack for return address and argument
    sw $ra, 0($sp)       # Store return address on stack
    
    # Compare A and B
    beq $a0, $a1, equal  # If A == B, go to equal
    bgt $a0, $a1, greater # If A > B, go to greater
    
    # A < B, return A
    move $v0, $a0
    j done
    
    greater:
        # A > B, return A - B
        sub $v0, $a0, $a1
        j done
        
    equal:
        # A == B, return 0
        li $v0, 0
        
    done:
        # Restore return address        
        lw $ra, 0($sp)       
        addi $sp, $sp, 4    
    
        jr $ra           # Return to calling function
.end main