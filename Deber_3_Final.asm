;Defining equivalences
SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

segment .data 
   msg1 db "Ingrese un numero", 0xA, 0xD 
   len1 equ $- msg1
   
   msg2 db "El numero no es primo", 0xA, 0xD 
   len2 equ $- msg2
   
   msg3 db "El numero es primo", 0xA, 0xD
   len3 equ $- msg3
   
segment .bss
    num resb 10  ;Solo hasta 10 caracteres (del 0-9 + salto de línea)
    
segment .text

    global _start
_start:

   ;To show the msg 1
   mov eax, SYS_WRITE         
   mov ebx, STDOUT         
   mov ecx, msg1         
   mov edx, len1 
   int 0x80                

   ;To read the value from input and save it in num
   mov eax, SYS_READ 
   mov ebx, STDIN  
   mov ecx, num 
   mov edx, 10
   int 0x80 
   
   ;Convertir la cadena ASCII ingresada en un número entero
    xor eax, eax  ; Limpiar eax (almacenará el número convertido)(ponerlo en 0)
    xor ecx, ecx  ; Limpiar ecx (contador para recorrer la cadena)(ponerlo en 0, se usará ecx como índice)

    convert_loop:
        movzx ebx, byte [num + ecx]  ; Se utiliza movzx porque carga solo 1 byte y lo extiende a 32 bits con ceros.
                                    ; Si se usara mov cargaría 4 bytes completos en EBX. Si solo queremos 1 byte, 
                                    ; los otros 3 contendrán datos basura.
        cmp ebx, 10                  ; ¿Es el salto de línea (fin de entrada)?
        je end_conversion             ; Sí, terminamos la conversión
    
        sub ebx, '0'                  ; Convertir carácter ASCII a número
        imul eax, eax, 10             ; Multiplicar el número actual por 10
        ;Se utiliza imul porque no modifica EDX (evita posibles errores). Sin embargo con mul quedaría así ↓
        ;mov ebx, 10   ; Cargar 10 en EBX
        ;mul ebx       ; EAX = EAX * EBX (resultado en EDX:EAX)
    
        add eax, ebx                  ; Agregar el nuevo dígito
        inc ecx                       ; Avanzar al siguiente carácter
        jmp convert_loop

    end_conversion:
        mov [num], eax  ; Guardar el número convertido en memoria para su uso posterior
   
        ;If num <= 1
        cmp dword [num], 1    ; num es un número entero almacenado en 4 bytes (dword), usando (byte [num]) solo se compara 1 byte.     
                                ;(cmp) puede usar un operando de memoria, pero el otro debe ser un registro o un valor inmediato.
        jle not_prime
   
   
   ;Comenzamos a verificar si el número es primo
    mov eax, [num]          ; Cargamos el número en eax
    mov ebx, 2              ; Comenzamos a dividir desde 2
    
    check_prime:
        ;Por regla matemática: Si un número N es divisible por algún número mayor que su raíz cuadrada, entonces también será divisible 
        ;por un número menor que su raíz cuadrada.
        ;Esto significa que si no hemos encontrado un divisor menor o igual a √N, entonces N es primo.
        mov ecx, ebx          ; Copiamos ebx a ecx (Guardamos ebx en ecx para calcular ebx²)
        imul ecx, ecx         ; Calculamos ebx^2 (ecx = ebx * ebx (ebx²))
        cmp ecx, eax          ; Comparamos ebx^2 con num (¿ebx² > num?)
        jg is_prime           ; Si ebx^2 > num, terminamos la verificación (es primo)

        ; Comprobar si eax % ebx == 0
        xor edx, edx            ; Limpiar edx antes de la división (Si edx contiene un valor basura xor lo limpia)
        div ebx                 ; Dividir eax por ebx, el residuo queda en edx
        cmp edx, 0              ; Comprobar si el residuo es 0
        je not_prime            ; Si es 0, no es primo

        inc ebx                 ; Incrementar ebx (probamos el siguiente divisor)
        jl check_prime          ; Si ebx < eax, seguir dividiendo
    
    
    is_prime:
        ; Si llegamos aquí, el número es primo
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, msg3
        mov edx, len3
        int 0x80
        jmp exit_program        ; Saltar al final del programa
   
    not_prime:
    ;To show the msg 2
        mov eax, SYS_WRITE         
        mov ebx, STDOUT         
        mov ecx, msg2         
        mov edx, len2 
        int 0x80  
   
    exit_program:
        ; Salir del programa
        mov eax, SYS_EXIT
        xor ebx, ebx
        int 0x80