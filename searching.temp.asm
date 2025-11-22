INCLUDE c:\Users\HP\.vscode\extensions\istareatscreens.masm-runner-0.9.1\native\irvine\Irvine32.inc
.stack 100h

.data
    arr dword 500 dup(?)
    target dword ?
    n dword ?

    start_low   dword ?
    start_high  dword ?
    cycles_low  dword ?
    cycles_high dword ?

    prompt1 byte "Enter the size of array: ",0
    m1 byte "Enter the number you want to search: ",0
    m2 byte "number found at ( -1 if not found ): ",0
    linear_count byte "Linear search cycles: ",0
    binary_count byte "Binary Search cycles: ",0
    inter_count byte "interpolation search cycles: ",0
    space byte " ",0

.code
main PROC
    mov edx,offset prompt1
    call writestring
    call readint
    mov n,eax

    call gen_random_array

    mov ecx,n
    call Bubble_Sort


    mov ecx,n
    mov esi,offset arr
    call print_arr

    ; input target
    mov edx, offset m1
    call writestring
    call readint
    mov target, eax

    ; linear search
    call StartCounter
    call LinearSearch      
    mov ebx, eax           
    call EndCounter

    ; print result
    mov edx, offset m2
    call writestring
    mov eax, ebx
    call writeint
    call crlf

    ; print cycles
    mov edx, offset linear_count
    call writestring
    mov eax, cycles_high
    call WriteDec
    mov al, ':'
    call WriteChar
    mov eax, cycles_low
    call WriteDec
    call crlf

    ; binary search
    call StartCounter
    call BinarySearch      
    mov ebx, eax           
    call EndCounter

    ; print result
    mov edx, offset m2
    call writestring
    mov eax, ebx
    call writeint
    call crlf

    ; print cycles
    mov edx, offset binary_count
    call writestring
    mov eax, cycles_high
    call WriteDec
    mov al, ':'
    call WriteChar
    mov eax, cycles_low
    call WriteDec
    call crlf


    call StartCounter
    call InterpSearch
    mov ebx, eax
    call EndCounter

    mov edx, offset m2
    call writestring
    mov eax, ebx
    call writeint
    call crlf

    mov edx, offset inter_count
    call writestring
    mov eax, cycles_high
    call WriteDec
    mov al, ':'
    call WriteChar
    mov eax, cycles_low
    call WriteDec
    call crlf


    exit
main ENDP



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


print_arr PROC

    print:
        mov eax,[esi]
        call writedec
        mov edx,offset space
        call writestring
        add esi,4
        loop print
    
    call crlf        
    ret
    
print_arr ENDP


Bubble_Sort PROC
    l1:
        dec ecx
        jz done

        mov ebx,ecx
        mov esi,offset arr
    l2:
        mov eax,[esi]
        mov edx,[esi+4]

        cmp eax,edx  ; if arr[j] > arr[j+1]
        jbe dont_swap

        mov [esi],edx
        mov [esi+4],eax
    
    dont_swap:
        add esi,4
        dec ebx
        jnz l2

        jmp l1

    done:
        ret
    
Bubble_Sort ENDP



LinearSearch PROC
    mov esi, 0
LS_loop:
    cmp esi, n
    jae LS_notFound
    mov ebx, arr[esi*4]
    cmp ebx, target
    je LS_found
    inc esi
    jmp LS_loop

LS_found:
    mov eax, esi
    ret

LS_notFound:
    mov eax, -1
    ret
LinearSearch ENDP



BinarySearch PROC
    mov esi, 0           ; left
    mov edi, n
    dec edi              ; right = n-1
    mov edx, target      ; load target

BS_loop:
    cmp esi, edi
    ja BS_notFound

    mov ebx, esi
    add ebx, edi
    shr ebx, 1           ; mid

    mov ecx, arr[ebx*4]

    cmp ecx, edx
    je BS_found

    jl BS_right          ; arr[mid] < target

    ; go left
    mov edi, ebx
    dec edi
    jmp BS_loop

BS_right:
    mov esi, ebx
    inc esi
    jmp BS_loop

BS_found:
    mov eax, ebx
    ret

BS_notFound:
    mov eax, -1
    ret
BinarySearch ENDP


InterpSearch PROC
    ; Formula: pos = lo + [ (x-arr[lo])*(hi-lo) / (arr[hi]-arr[lo]) ]
    
    mov esi, 0              ; ESI = Low
    mov edi, n
    dec edi                 ; EDI = High
    mov ebx, target         ; EBX = Target (x)

IS_loop:
    cmp esi, edi
    jg IS_notfound          ; if Low > High, exit

    ; 1. Check Bounds: arr[low] <= target <= arr[high]
    mov eax, arr[esi*4]     ; arr[low]
    cmp ebx, eax
    jl IS_notfound          ; target < arr[low]
    
    mov eax, arr[edi*4]     ; arr[high]
    cmp ebx, eax
    jg IS_notfound          ; target > arr[high]

    ; 2. Avoid Division by Zero (if arr[high] == arr[low])
    mov ecx, arr[edi*4]
    sub ecx, arr[esi*4]     ; Denominator = arr[high] - arr[low]
    jz IS_check_single      ; If 0, we can't divide (means all values in range are same)

    ; 3. Calculate Numerator: (target - arr[low]) * (high - low)
    mov eax, ebx            ; target
    sub eax, arr[esi*4]     ; (target - arr[low])
    
    mov edx, edi
    sub edx, esi            ; (high - low)
    
    imul eax, edx           ; EAX = Numerator (Result fits in EAX for reasonable array sizes)
    
    ; 4. Divide: Numerator / Denominator
    ; Denominator is currently in ECX
    cdq                     ; Sign extend EAX into EDX for IDIV
    idiv ecx                ; EAX = Result
    
    ; 5. Add Low: pos = low + Result
    add eax, esi            ; EAX is now 'pos' (mid)

    ; 6. Compare arr[pos] with target
    mov edx, arr[eax*4]
    cmp edx, ebx
    je IS_found
    jl IS_goRight           ; arr[pos] < target
    
    ; Go Left (high = pos - 1)
    mov edi, eax
    dec edi
    jmp IS_loop

IS_goRight:
    ; Go Right (low = pos + 1)
    mov esi, eax
    inc esi
    jmp IS_loop

IS_check_single:
    ; If arr[low] == arr[high], just check if arr[low] is target
    mov eax, arr[esi*4]
    cmp eax, ebx
    je IS_found_low
    jmp IS_notfound

IS_found_low:
    mov eax, esi
    ret

IS_found:
    ; EAX already holds pos
    ret

IS_notfound:
    mov eax, -1
    ret
InterpSearch ENDP


end main
