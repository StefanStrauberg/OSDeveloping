  ORG 0
  BITS 16
  _start:
    jmp short start ; Short jump to label 'start'
    nop             ; No operation, just a filler instruction
    
    times 33 db 0   ; Pad 33 bytes with zeros (to simulate the boot sector)

  start:
    jmp 0x7c0:step2 ; Far jump to segment 0x7C0 at the label 'step2'

  step2:
    cli             ; Disable interrupts
    mov ax, 0x7c0   ; Set Segment Registers DS and ES to segment 0x7C0 (0x7C00 = 0x7C0 * 16)
    mov ds, ax
    mov es, ax
    mov ax, 0x00    ; Set Segment Register SS to 0, so that stack starts at address 0x0000
    mov ss, ax
    mov sp, 0x7c00  ; Set pointer of stack (SP) to 0x7C00
    sti             ; Enable interrupts

    mov si, message ; Load address of the message into register SI
    call print      ; Call the print procedure
    jmp $           ; Infinite loop

  print:    
  .loop: 
    lodsb           ; Load a byte from [SI] into AL and increment SI
    cmp al, 0       ; Check if the character is a null terminator
    je .done        ; If yes, jump to done
    call print_char ; Call the print_char procedure
    jmp .loop       ; Jump back to loop
  .done:
    ret             ; Return from the procedure

  print_char:
    mov ah, 0eh     ; Set function for BIOS teletype output (0x0E)
    int 0x10        ; Call BIOS interrupt 0x10 to output the character in AL
    ret             ; Return from the procedure

  message: db 'Hello World!', 0

  times 510-($ - $$) db 0
  dw 0xAA55