# Copyright (c) 2023 The Popcorn Project
# See ../LICENSE for more information

.code16                     # Switch to 16-bit mode

.globl _start               # Entry point symbol

_start:
    # Set up segments (if needed)
    xorw %ax, %ax           # DS=ES=0 to ensure access to the entire 1st MiB of memory
    movw %ax, %ds
    movw %ax, %es

    # Load kernel.bin to memory
    movw $kernel_name, %si  # Pointer to the filename "kernel.bin"
    call load_kernel       # Load "kernel.bin" to memory
    jc load_error

    # Jump to the loaded kernel
    ljmp $0x1000, $0        # Assuming the loaded kernel's entry point is 0x10000 (16-byte segment)

kernel_name: .asciz "KERNEL  BIN"  # The 8.3 filename of the kernel.bin

load_kernel:
    # Disk read to load "kernel.bin" data from the storage medium
    # Load the file directly to 0x1000:0000 in memory (assuming the kernel entry point)
    movb $0x02, %ah         # BIOS read sector function
    movb $0x01, %al         # Number of sectors to read (1 sector for the file)
    movb $0x00, %ch         # Cylinder number (for the first sector)
    movb $0x02, %cl         # Sector number (1-based) for the first sector of the partition
    movb $0x00, %dh         # Head number
    movb $0x80, %dl         # Drive number (0x80 for the first hard drive)
    movw $0x1000, %bx       # Buffer address to load the kernel (segment:offset)
    int $0x13               # BIOS interrupt for disk read

    jc load_error           # Check for disk read error

    ret

load_error:
    # Handle loading error (e.g., print an error message or go to an error state)
    # For simplicity, this example loops indefinitely in case of an error.
    jmp .

.section .bss
    .skip 510-.-0, 0       # Pad the rest of the sector with zeroes

.section .data
    .word 0xAA55           # Master Boot Record signature

