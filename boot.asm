ORG 0
BITS 16

jmp 0x7c0:start

start:
  cli 
  mov ax, 0x7c0   ; Устанавливает сегментные регистры DS и ES на адрес 0x7C0
  mov ds, ax
  mov es, ax
  mov ax, 0x00    ; Устанавливает сегментный регистр SS на 0, чтобы стек начинался с адреса 0x0000
  mov ss, ax
  mov sp, 0x7c00  ;   Устанавливает указатель стека (SP) на 0x7C00
  sti
  mov si, message ; Загружаем адрес строки в регистр SI
  call print      ; Вызываем процедуру для печати строки
  jmp $           ; Бесконечный цикл

print:    
.loop: 
  lodsb           ; Загружаем байт из [SI] в AL и увеличиваем SI
  cmp al, 0       ; Проверяем, является ли символ нулевым байтом
  je .done        ; Если да, завершить печать
  call print_char ; Вызов процедуры вывода символа
  jmp .loop       ; Переход к следующему символу
.done:
  ret             ; Возврат из процедуры

print_char:
  mov ah, 0eh     ; Функция вывода символа BIOS
  int 0x10        ; Вызов прерывания BIOS для вывода символа
  ret             ; Возврат из процедуры

message: db 'Hello World!', 0

times 510-($ - $$) db 0
dw 0xAA55