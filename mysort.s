#Program: Sorting an array in non-decreasing order
#Author: Yves Semana Gisubizo
#Date: 11/05/2021
#CPSC275
#Assignment 3

.LC0:
    .string "%d"               #for scanning array elements
.LC1:
    .string "%d "              #for printing array elements
.LC2:
    .string "%d\n"             #for printing N


    .globl main
main:
    pushl    %ebp                 #save main procedure frame pointer
    movl     %esp,%ebp            #adjust stack top pointer

    subl    $2064,%esp            #creating room for 500 integers in array and extra for the local variables
    leal    -2000(%ebp),%ebx      #getting the address of the Array
    pushl   %ebx                  #pushing the array base address into the stack to be retrieved from anywhere at 8(%ebp)
    leal    -2004(%ebp),%edi      #loading address in which to store N
    pushl   %edi                  #pushing N address on the stack to be retrieved from anywhere

    call    readarr
    call    bubblesort
    call    printarr

.ENDMAIN:
    leave                          #restore the current activation
    ret                            #return to caller

readarr:
    pushl    %ebp                  #save readarr procedure frame pointer
    movl     %esp, %ebp            #adjust stack top pointer

    movl     12(%ebp), %ebx         #retrieving the address of the base array that I saved from the main
    movl     8(%ebp), %edi          #retrieving the address of N in which to read the value of N

    pushl    %edi                   #pushing address of N onto the stack for scanning
    pushl    $.LC0                  #pushing scanning string
    call     scanf                  #scanning in N

    movl    (%edi),%eax             #saving N for return
    movl    %eax, (%edx)             #saving N into its memory address

    pushl    %eax                   #printing N
    pushl    $.LC2
    call     printf

    movl   $0, %esi                 #starting array index at 0

.INPUT:
    movl     8(%ebp), %edi          #retrieving the address of N in which to read the value of N
    movl    (%edi),%ecx             #retrieving N value
    cmpl    %ecx,%esi               #checking if index has reached N
    je      .ENDREAD                #if index = N, then go out of readarr procedure

    leal    (%ebx,%esi,4),%edi      #loading the array address in which to input the values
    pushl   %edi                    #pushing that address onto the stack
    pushl   $.LC0                   #pushing string for N to be scanned
    call    scanf                   #scanning in N from the redirected input
    incl    %esi                    #increasing array index
    jmp     .INPUT                  #if index < N, continue reading in values

.ENDREAD:
    leave                           #restore the current activation
    ret                             #return to caller


printarr:
    pushl   %ebp                    #save main procedure frame pointer
    movl    %esp,%ebp               #adjust stack top pointer

    movl    12(%ebp),%ebx           #getting the address of the base array that I saved from the main
    movl    8(%ebp), %edi           #retrieving the address of N in which to read the value of N

    movl    $0,%esi                 #starting index to 0

.OUTPUT:
    movl    (%edi),%ecx            #retrieving N value from the memory
    cmpl     %ecx,%esi             #comparing index to N
    je      .ENDPRINT              #if index >= N, then go out of the printarr procedure

    movl    (%ebx,%esi,4),%edx
    pushl   %edx                    #pushing value of the array to be printed
    pushl   $.LC1                   #pushing the printing string
    call    printf                  #printing the value at index
    incl    %esi                    #index++
    jmp     .OUTPUT                 #back to the top of the loop

.ENDPRINT:
    leave                           #restore the current activation
    ret                             #return to caller


bubblesort:
     pushl    %ebp                  #save bubblesort procedure frame pointer
     movl     %esp, %ebp            #adjust stack top pointer

     movl    12(%ebp), %ebx         #getting the address of the base array that I saved from the main

     movl    $0, %ecx               #i (for outer loop)

.sort:
     movl     8(%ebp), %edi         #retrieving the address of N in which to read the value of N
     movl     (%edi), %esi          #retrieving N
     subl     $1, %esi              #N-1
     movl     $0, %edx              #resetting j (for nested loop) to 0 everytime
     cmpl     %esi, %ecx            #comparing i to N-1
     je      .ENDBUBBLE             #going to push %ebx(base address) and then print

.nestedloop:
     movl   12(%ebp),%ebx            #retrieving base array address everytime you enter nested loop to obtain the elements based on it
     movl   8(%ebp), %esi            #getting address of N
     movl   (%esi), %esi             #retrieving N
     subl   $1, %esi                 #N-1
     subl   %ecx,%esi                #getting N-1-i

     cmpl    %esi,%edx               #comparing j to n-i (because for bubble sort nested look it's j < N-i-1)
     je      .increasei              #if j >= N-i, go increase outer loop index i

     movl    (%ebx,%edx,4),%esi      #getting element before
     movl    4(%ebx,%edx,4),%edi     #getting element after
     cmpl    %edi,%esi               #comparing consecutive elements
     jg      .callswap               #if element before > element after, then swap
.increasej:
     incl   %edx                     #increase j
     jmp    .nestedloop              #back to nested loop

.increasei:
     incl   %ecx                    #increasing i
     jmp    .sort                   #back to top of the sorting

.callswap:
     leal    (%ebx,%edx,4),%esi      #loading address of the element before
     leal    4(%ebx,%edx,4),%edi     #loading address of the element after
     pushl   %edi                    #pushing the address of second element
     pushl   %esi                    #pushing the address of first element

     call    swap                    #swapping them
     jmp     .increasej              #increasing index of nested loop j

.ENDBUBBLE:
     leave                           #restore the current activation
     ret                             #return to caller



swap:
    pushl    %ebp                    #save swap procedure frame pointer
    movl     %esp,%ebp               #adjust stack top pointer

    movl 8(%ebp), %esi               #getting address of element before
    movl 12(%ebp), %edi              #getting address of element after

    movl (%esi), %ebx                #moving element before to ebx
    movl (%edi), %eax                #moving element after to eax
    movl %eax, (%esi)                #swapping
    movl %ebx, (%edi)                #swapping

.ENDSWAP:
    leave                           #restore the current activation
    ret                             #return to caller
