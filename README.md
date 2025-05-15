# Verificador de Números Primos en Ensamblador x86

## 📋 Descripción

Este programa en lenguaje ensamblador (NASM, arquitectura x86) permite verificar si un número ingresado por el usuario es un número primo. El programa se ejecuta en sistemas Linux y utiliza llamadas al sistema (`int 0x80`) para realizar operaciones de entrada/salida y finalización.

---

## 🛠️ Tecnologías

- NASM (Netwide Assembler)
- Linux (llamadas al sistema)
- Arquitectura x86 (32 bits)

---

## 📂 Estructura
.
├── primo.asm   # Código fuente del verificador de primos

---
## 🧾 Instrucciones de compilación y ejecución
nasm -f elf32 primo.asm -o primo.o
ld -m elf_i386 primo.o -o primo
./primo



