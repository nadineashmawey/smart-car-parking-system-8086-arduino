org 100h

; ---------------------------------------------------------
; Port Definitions
; ---------------------------------------------------------
GPIO_IR_PORT      equ 02h 
GPIO_LED_PORT     equ 0Eh

ENTRANCE_IR       equ 07h
EXIT_IR           equ 09h

SERVO_PORT        equ 06h

IR0_MASK  equ 01h
IR1_MASK  equ 02h
IR2_MASK  equ 04h
IR3_MASK  equ 08h

LED0_MASK equ 01h
LED1_MASK equ 02h
LED2_MASK equ 04h
LED3_MASK equ 08h 

INV_IR0_MASK  equ 0FEh
INV_IR1_MASK  equ 0FDh
INV_IR2_MASK  equ 0FBh
INV_IR3_MASK  equ 0F7h

INV_LED0_MASK equ 0FEh
INV_LED1_MASK equ 0FDh
INV_LED2_MASK equ 0FBh
INV_LED3_MASK equ 0F7h

ENTRANCE_SERVO_MASK equ 01h
EXIT_SERVO_MASK     equ 02h

MS_LOOP_COUNT equ 10

; ---------------------------------------------------------
; MAIN LOOP
; ---------------------------------------------------------
main_loop:

start:
    lea dx, actionMsg
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h

    cmp al, 'E'
    je car_enter
    cmp al, 'e'
    je car_enter

    cmp al, 'L'
    je car_leave
    cmp al, 'l'
    je car_leave

    cmp al, 'Q'
    je exit_program
    cmp al, 'q'
    je exit_program

    jmp main_loop

; ---------------------------------------------------------
; CAR ENTER
; ---------------------------------------------------------
car_enter:

    ; Open entrance gate
    mov al, ENTRANCE_SERVO_MASK
    out SERVO_PORT, al

    ; Simulate car passing gate
    lea dx, passMsg
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h          ; press any key = car passed

    ; Wait 2 seconds after passing
    call delay_2s

    lea dx, chooseSlot
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'

    cmp al, 1
    je enter0
    cmp al, 2
    je enter1
    cmp al, 3
    je enter2
    cmp al, 4
    je enter3
    jmp main_loop

enter0:
    in al, GPIO_IR_PORT
    test al, IR0_MASK
    jz slot_occupied

    and al, INV_IR0_MASK
    out GPIO_IR_PORT, al

    in al, GPIO_LED_PORT
    and al, INV_LED0_MASK
    out GPIO_LED_PORT, al
    jmp enter_done

enter1:
    in al, GPIO_IR_PORT
    test al, IR1_MASK
    jz slot_occupied

    and al, INV_IR1_MASK
    out GPIO_IR_PORT, al

    in al, GPIO_LED_PORT
    and al, INV_LED1_MASK
    out GPIO_LED_PORT, al
    jmp enter_done

enter2:
    in al, GPIO_IR_PORT
    test al, IR2_MASK
    jz slot_occupied

    and al, INV_IR2_MASK
    out GPIO_IR_PORT, al

    in al, GPIO_LED_PORT
    and al, INV_LED2_MASK
    out GPIO_LED_PORT, al
    jmp enter_done

enter3:
    in al, GPIO_IR_PORT
    test al, IR3_MASK
    jz slot_occupied

    and al, INV_IR3_MASK
    out GPIO_IR_PORT, al

    in al, GPIO_LED_PORT
    and al, INV_LED3_MASK
    out GPIO_LED_PORT, al
    jmp enter_done

slot_occupied:
    lea dx, occupiedMsg
    mov ah, 09h
    int 21h
    jmp main_loop

enter_done:
    call show_status
    mov al, 0
    out SERVO_PORT, al
    jmp main_loop

; ---------------------------------------------------------
; CAR LEAVE
; ---------------------------------------------------------
car_leave:

    ; Open exit gate
    mov al, EXIT_SERVO_MASK
    out SERVO_PORT, al

    lea dx, passMsg
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h          ; simulate car passing

    call delay_2s

    lea dx, chooseSlot
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'

    cmp al, 1
    je leave0
    cmp al, 2
    je leave1
    cmp al, 3
    je leave2
    cmp al, 4
    je leave3
    jmp main_loop

leave0:
    in al, GPIO_IR_PORT
    or al, IR0_MASK
    out GPIO_IR_PORT, al

    in al, GPIO_LED_PORT
    or al, LED0_MASK
    out GPIO_LED_PORT, al
    jmp leave_done

leave1:
    in al, GPIO_IR_PORT
    or al, IR1_MASK
    out GPIO_IR_PORT, al

    in al, GPIO_LED_PORT
    or al, LED1_MASK
    out GPIO_LED_PORT, al
    jmp leave_done

leave2:
    in al, GPIO_IR_PORT
    or al, IR2_MASK
    out GPIO_IR_PORT, al

    in al, GPIO_LED_PORT
    or al, LED2_MASK
    out GPIO_LED_PORT, al
    jmp leave_done

leave3:
    in al, GPIO_IR_PORT
    or al, IR3_MASK
    out GPIO_IR_PORT, al

    in al, GPIO_LED_PORT
    or al, LED3_MASK
    out GPIO_LED_PORT, al
    jmp leave_done

leave_done:
    call show_status
    mov al, 0
    out SERVO_PORT, al
    jmp main_loop

; ---------------------------------------------------------
; SHOW STATUS
; ---------------------------------------------------------
show_status:
    lea dx, clear
    mov ah, 09h
    int 21h

    lea dx, statusHead
    mov ah, 09h
    int 21h

    lea dx, slotStatus
    mov ah, 09h
    int 21h

    in al, GPIO_IR_PORT
    mov bl, al

    mov cx, 4
print_loop:
    mov al, bl
    and al, 01h
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    shr bl, 1
    loop print_loop

    lea dx, nl
    mov ah, 09h
    int 21h
    ret

; ---------------------------------------------------------
; DELAY 2 SECONDS
; ---------------------------------------------------------
delay_2s:
    mov cx, 10
d1:
    mov dx, MS_LOOP_COUNT
d2:
    dec dx
    jnz d2
    loop d1
    ret

; ---------------------------------------------------------
; EXIT
; ---------------------------------------------------------
exit_program:
    mov ah, 4Ch
    int 21h

; ---------------------------------------------------------
; STRINGS
; ---------------------------------------------------------
actionMsg   db 13,10,"E) Enter  L) Leave  Q) Quit : $"
chooseSlot  db 13,10,"Choose slot (1-4): $"
statusHead  db 13,10,"Parking Slots Status:",13,10,'$'
slotStatus  db "Slot statuses: $"
occupiedMsg db 13,10,"Slot already occupied! Unable to enter.$"
passMsg     db 13,10,"Press any key when car passes the gate...$"
nl          db 13,10,'$'
clear       db 13,10,'$'
