.model small
.data
    balance dw 1000            ; Initial balance amount
    transaction_menu db '1. Deposit', 13, 10, '2. Withdraw', 13, 10, '3. Exit', 13, 10, '$'
    insufficient_funds_msg db 'Insufficient funds!', 13, 10, '$'

.code
org 100h ; Set the origin to 100h

_start:
    mov ax, @data
    mov ds, ax

    mov ax, 1000        ; Initial balance
    mov balance, ax

    call display_balance
    call transaction_loop

    ; Terminate program
    mov ah, 4Ch
    int 21h

display_balance:
    mov ah, 09h        ; Write string to standard output
    lea dx, balance    ; Give DX a pointer
    int 21h            ; DOS interrupt

    mov ah, 09h        ; Write string to standard output
    lea dx, '$'        ; Give DX a pointer
    int 21h            ; DOS interrupt

    ret

transaction_loop:
transaction_menu_loop:
    ; Display transaction menu
    mov ah, 09h        ; Write string to standard output
    lea dx, transaction_menu ; Give DX a pointer
    int 21h            ; DOS interrupt

    ; Get user choice
    mov ah, 01h        ; Read character from standard input
    int 21h            ; DOS interrupt

    ; Process user choice
    cmp al, '1'
    je deposit
    cmp al, '2'
    je withdraw
    cmp al, '3'
    je exit_transaction

    jmp transaction_menu_loop

deposit:
    call prompt_for_amount
    add balance, ax
    jmp transaction_menu_loop

withdraw:
    call prompt_for_amount
    cmp balance, ax
    jl insufficient_funds    ; Jump if insufficient funds
    sub balance, ax
    jmp transaction_menu_loop

insufficient_funds:
    mov ah, 09h        ; Write string to standard output
    lea dx, insufficient_funds_msg ; Give DX a pointer
    int 21h            ; DOS interrupt
    jmp transaction_menu_loop

exit_transaction:
    ret

prompt_for_amount:
    ; Prompt the user to enter an amount
    mov ah, 09h        ; Write string to standard output
    lea dx, '$'        ; Give DX a pointer
    int 21h            ; DOS interrupt

    ; Get user input
    mov ah, 01h        ; Read character from standard input
    int 21h            ; DOS interrupt
    sub al, '0'         ; Convert ASCII to integer
    mov ah, 0           ; Clear upper bits of AX
    movzx ax, al        ; Zero-extend AL to AX

    ret

End
