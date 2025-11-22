include Irvine32.inc
.stack 100h

.data
    arr         dword 500 dup(?)
    orig        dword 500 dup(?)
    n           dword ?


    start_low   dword ?
    start_high  dword ?
    cycles_low  dword ?
    cycles_high dword ?

    msg_n       byte "Enter size: ",0
    msg_elem    byte "Enter element: ",0
    msg_res     byte "Sorted result: ",0

    msg_bub     byte "Bubble Sort cycles: ",0
    msg_sel     byte "Selection Sort cycles: ",0
    msg_ins     byte "Insertion Sort cycles: ",0
    msg_quick   byte "Quick Sort cycles: ",0
    msg_shell   byte "Shell Sort cycles: ",0

    space       byte " ",0

.code


StartCounter PROC
    rdtsc
    mov start_low, eax
    mov start_high, edx
    ret
StartCounter ENDP

EndCounter PROC
    rdtsc
    sub eax, start_low
    mov cycles_low, eax
    sbb edx, start_high
    mov cycles_high, edx
    ret
EndCounter ENDP



main PROC

    mov edx, OFFSET msg_n
    call WriteString
    call ReadInt
    mov n, eax


    ;call read_array
    call gen_random_array

    ; save original -> orig
    call save_original

    ; BUBBLE SORT
    call restore_original
    call StartCounter

    mov ecx,n
    call Bubble_Sort

    call EndCounter

    mov edx, OFFSET msg_bub
    call WriteString
    mov eax, cycles_high
    call WriteDec
    mov al, ':'
    call WriteChar
    mov eax, cycles_low
    call WriteDec
    call Crlf


    ; Selection SORT
    call restore_original
    call StartCounter

    mov ecx,n
    call Selection_Sort

    call EndCounter

    mov edx, OFFSET msg_sel
    call WriteString
    mov eax, cycles_high
    call WriteDec
    mov al, ':'
    call WriteChar
    mov eax, cycles_low
    call WriteDec
    call Crlf


    ;INSERTION SORT
    call restore_original
    call StartCounter

    mov ecx,n
    call insertion_Sort

    call EndCounter

    mov edx, OFFSET msg_ins
    call WriteString
    mov eax, cycles_high
    call WriteDec
    mov al, ':'
    call WriteChar
    mov eax, cycles_low
    call WriteDec
    call Crlf


    ;Quick SORT
    call restore_original
    call StartCounter

    mov ecx,n
    call Quick_Sort

    call EndCounter

    mov edx, OFFSET msg_quick
    call WriteString
    mov eax, cycles_high
    call WriteDec
    mov al, ':'
    call WriteChar
    mov eax, cycles_low
    call WriteDec
    call Crlf


    ; SHELL SORT
    call restore_original
    call StartCounter

    mov ecx,n
    call shellSort

    call EndCounter

    mov edx, OFFSET msg_shell
    call WriteString
    mov eax, cycles_high
    call WriteDec
    mov al, ':'
    call WriteChar
    mov eax, cycles_low
    call WriteDec
    call Crlf


    ; print sorted array
    mov edx, OFFSET msg_res
    call WriteString
    call Crlf
    call print_array

    exit
main ENDP


gen_random_array PROC
    mov ecx, n
    mov esi, OFFSET arr

gen_loop:
    mov eax, 1000         ; upper bound
    call RandomRange      ; eax = random 0–999
    mov [esi], eax

    add esi, 4
    loop gen_loop
    ret
gen_random_array ENDP


read_array PROC
    mov ecx, n
    mov esi, OFFSET arr
read_loop:
    mov edx, OFFSET msg_elem
    call WriteString
    call ReadInt
    mov [esi], eax
    add esi, 4
    loop read_loop
    ret
read_array ENDP


; Save original array
save_original PROC
    mov ecx, n
    mov esi, OFFSET arr
    mov edi, OFFSET orig
saveloop:
    mov eax, [esi]
    mov [edi], eax
    add esi, 4
    add edi, 4
    loop saveloop
    ret
save_original ENDP


; Restore original for next sort
restore_original PROC
    mov ecx, n
    mov esi, OFFSET orig
    mov edi, OFFSET arr
restloop:
    mov eax, [esi]
    mov [edi], eax
    add esi, 4
    add edi, 4
    loop restloop
    ret
restore_original ENDP


print_array PROC
    mov ecx, n
    mov esi, OFFSET arr
p_loop:
    mov eax, [esi]
    call WriteDec
    mov edx, OFFSET space
    call WriteString
    add esi, 4
    loop p_loop
    call Crlf
    ret
print_array ENDP






Bubble_Sort PROC
l1:
    dec ecx
    jz done
    mov ebx,ecx
    mov esi,offset arr
l2:
    mov eax,[esi]
    mov edx,[esi+4]
    cmp eax,edx
    jbe no_swap
    mov [esi],edx
    mov [esi+4],eax
no_swap:
    add esi,4
    dec ebx
    jnz l2
    jmp l1
done:
    ret
Bubble_Sort ENDP



Selection_Sort PROC
l1:
    dec ecx
    jz done
    mov esi,offset arr
    mov eax,n
    sub eax,ecx
    dec eax
    shl eax,2
    add esi,eax
    mov edx,esi
    mov ebx,esi
    add ebx,4
l2:
    mov eax, ebx
    sub eax, OFFSET arr
    shr eax, 2
    cmp eax, n
    jge end_l2
    mov eax,[ebx]
    mov edi,[edx]
    cmp eax,edi
    jge not_min
    mov edx,ebx
not_min:
    add ebx,4
    jmp l2
end_l2:
    mov eax,[esi]
    mov ebx,[edx]
    mov [esi],ebx
    mov [edx],eax
    jmp l1
done:
    ret
Selection_Sort ENDP



insertion_Sort PROC
    dec ecx
    mov ebx,1
l1:
    mov esi,offset arr
    mov eax,ebx
    shl eax,2
    add esi,eax
    mov eax,[esi]
    mov edi,esi
l2:
    sub edi,4
    cmp edi,offset arr
    jl set_key
    mov edx,[edi]
    cmp edx,eax
    jle set_key
    mov [edi+4],edx
    jmp l2
set_key:
    mov [edi+4],eax
    inc ebx
    loop l1
done:
    ret
insertion_Sort ENDP



Quick_Sort PROC
    mov eax, n
    dec eax
    push eax
    push 0
    call QuickSort
    add esp,8
    ret
Quick_Sort ENDP

QuickSort PROC
    push ebp
    mov  ebp, esp
    mov eax, [ebp+8]
    mov edx, [ebp+12]
    cmp eax, edx
    jge end_qs

    push edx
    push eax
    call Partition
    add esp,8
    mov ecx, eax

    mov ebx, ecx
    dec ebx
    push ebx
    push [ebp+8]
    call QuickSort
    add esp,8

    mov ebx, ecx
    inc ebx
    push [ebp+12]
    push ebx
    call QuickSort
    add esp,8
end_qs:
    pop ebp
    ret
QuickSort ENDP


Partition PROC
    push ebp
    mov ebp, esp

    mov esi, [ebp+8]
    mov edi, [ebp+12]

    mov eax, edi
    shl eax, 2
    mov eax, [arr + eax]

    mov ebx, esi
    dec ebx
    mov ecx, esi

partition_loop:
    cmp ecx, edi
    jge partition_end

    mov edx, ecx
    shl edx, 2
    mov edx, [arr + edx]

    cmp edx, eax
    jg skip_swap

    inc ebx 
    mov ebp, ebx
    shl ebp, 2
    mov ebp, [arr + ebp]

    mov esi, ecx
    shl esi, 2
    mov esi, [arr + esi]

    mov [arr + ebx*4], esi
    mov [arr + ecx*4], ebp
skip_swap:
    inc ecx
    jmp partition_loop

partition_end:
    inc ebx
    mov ecx, ebx
    shl ecx, 2
    mov edx, [arr + ecx]

    mov esi, edi
    shl esi, 2
    mov ebp, [arr + esi]

    mov [arr + ecx], ebp
    mov [arr + esi], edx

    mov eax, ebx

    pop ebp
    ret
Partition ENDP



shellSort PROC
    mov eax, n
    shr eax, 1
shell_gap_loop:
    cmp eax, 0
    jle shell_done
    mov ebx, eax
    mov ecx, ebx
shell_i_loop:
    cmp ecx, n
    jge shell_gap_reduce
    mov edx, ecx
    shl edx, 2
    mov esi, [arr + edx]
    mov edi, ecx
shell_shift_loop:
    cmp edi, ebx
    jl shell_insert
    mov edx, edi
    sub edx, ebx
    shl edx, 2
    mov eax, [arr + edx]
    cmp eax, esi
    jle shell_insert
    mov edx, edi
    shl edx, 2
    mov [arr + edx], eax
    sub edi, ebx
    jmp shell_shift_loop
shell_insert:
    mov edx, edi
    shl edx, 2
    mov [arr + edx], esi
    inc ecx
    jmp shell_i_loop
shell_gap_reduce:
    shr ebx, 1
    mov eax, ebx
    jmp shell_gap_loop
shell_done:
    ret
shellSort ENDP

END main
