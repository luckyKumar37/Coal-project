INCLUDE c:\Users\HP\.vscode\extensions\istareatscreens.masm-runner-0.9.1\native\irvine\Irvine32.inc
.Stack 100h

.data
    arr dword 100 dup(?)
    temp dword 100 dup(?) 
    n dword ?
    c1 dword ?


    prompt1 byte "Enter the size of array: ",0
    prompt2 byte "Enter element: ",0
    msg1 byte "Original array: ",0
    msg2 byte "Sorted array: ",0
    space byte " ",0
    choice_msg byte "which sort do you want to use? ",0
    prompt3 byte "Enter your choice: ",0
    bubble byte "1.Bubble Sort",0
    selection byte "2.Selection Sort",0
    insertion byte "3.Insertion Sort",0
    Quick_msg byte "4.Quick Sort",0
    shell_msg byte "5.Shell Sort",0

.code
    main PROC
        
        mov edx,offset prompt1
        call writestring
        call readint
        mov n,eax
        mov ecx,n
        mov esi,offset arr

        call input_arr

        choice:
            mov edx,offset choice_msg
            call writestring
            call crlf
            mov edx,offset bubble
            call writestring
            call crlf
            mov edx,offset selection
            call writestring
            call crlf 
            mov edx,offset insertion
            call writestring
            call crlf 
            mov edx,offset Quick_msg
            call writestring
            call crlf 
            mov edx,offset shell_msg
            call writestring
            call crlf
            mov edx,offset prompt3
            call writestring
            call readint

            mov c1,eax
        




        mov edx,offset msg1
        call writestring
        call crlf
        mov ecx,n
        mov esi,offset arr
        call print_arr


        mov ecx,n


        mov eax,c1

        cmp eax,1
        jz call_bubble
        cmp eax,2
        jz call_selection
        cmp eax,3
        jz call_insertion
        cmp eax,4
        jz call_merge
        cmp eax,5
        jz call_shellSort

        jmp choice

        call_bubble:
            call Bubble_Sort

            mov edx,offset msg2
            call writestring
            call crlf
            mov ecx,n
            mov esi,offset arr

            call print_arr
            jmp End_proc
        call_selection:
            call Selection_Sort

            mov edx,offset msg2
            call writestring
            call crlf
            mov ecx,n
            mov esi,offset arr

            call print_arr
            jmp End_proc
        call_insertion:
            call insertion_Sort

            mov edx,offset msg2
            call writestring
            call crlf
            mov ecx,n
            mov esi,offset arr

            call print_arr
            jmp End_proc
        call_merge:
            call Quick_Sort
            mov edx,offset msg2
            call writestring
            call crlf
            mov ecx,n
            mov esi,offset arr

            call print_arr
            jmp End_proc

        call_shellSort:
            call shellSort
            mov edx,offset msg2
            call writestring
            call crlf
            mov ecx,n
            mov esi,offset arr
            
            call print_arr
            jmp End_proc

        End_proc:
            exit

    main ENDP

    input_arr PROC
        l1:
            mov edx,offset prompt2
            call writestring
            call readint
            mov [esi],eax
            add esi,4
            loop l1

        ret
        
    input_arr ENDP

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
        dec eax             ; right = n - 1
        push eax
        push 0              ; left = 0
        call QuickSort
        add esp, 8
        ret
    Quick_Sort ENDP



    QuickSort PROC
        push ebp
        mov  ebp, esp

        mov eax, [ebp+8]      ; left
        mov edx, [ebp+12]     ; right
        cmp eax, edx
        jge end_qs            ; if left >= right return

        ; call Partition(left, right)
        push edx
        push eax
        call Partition
        add esp, 8

        mov ecx, eax          ; pivot index (returned in eax)

        ; QuickSort(left, pivot-1)
        mov ebx, ecx
        dec ebx
        push ebx
        push [ebp+8]          ; left
        call QuickSort
        add esp, 8

        ; QuickSort(pivot+1, right)
        mov ebx, ecx
        inc ebx
        push [ebp+12]         ; right
        push ebx
        call QuickSort
        add esp, 8

    end_qs:
        pop ebp
        ret
    QuickSort ENDP



    Partition PROC
        push ebp
        mov  ebp, esp

        mov esi, [ebp+8]      ; left
        mov edi, [ebp+12]     ; right

        ; pivot = arr[right]
        mov eax, edi
        shl eax, 2
        mov eax, [arr + eax]  ; eax = pivot

        mov ebx, esi
        dec ebx                ; i = left - 1

        mov ecx, esi           ; j = left

    partition_loop:
        cmp ecx, edi
        jge partition_end

        ; load arr[j]
        mov edx, ecx
        shl edx, 2
        mov edx, [arr + edx]

        cmp edx, eax           ; arr[j] <= pivot ?
        jg skip_swap

        inc ebx                ; i++
        ; swap arr[i] and arr[j]
        mov ebp, ebx
        shl ebp, 2
        mov ebp, [arr + ebp]

        mov esi, ecx
        shl esi, 2

        mov esi, [arr + esi]   ; arr[j]
        mov [arr + ebx*4], esi ; arr[i] = arr[j]
        mov [arr + ecx*4], ebp ; arr[j] = old arr[i]

    skip_swap:
        inc ecx
        jmp partition_loop

    partition_end:
        inc ebx               ; i + 1

        ; swap arr[i+1] with arr[right]
        mov ecx, ebx
        shl ecx, 2
        mov edx, [arr + ecx]  ; arr[i+1]

        mov esi, edi
        shl esi, 2
        mov ebp, [arr + esi]  ; arr[right]

        mov [arr + ecx], ebp  
        mov [arr + esi], edx

        mov eax, ebx          ; return pivot index in eax

        pop ebp
        ret
    Partition ENDP


    shellSort PROC
        mov eax, n
        shr eax, 1           ; gap = n / 2

    shell_gap_loop:
        cmp eax, 0
        jle shell_done       ; if gap <= 0, finish

        mov ebx, eax         ; ebx = gap
        mov ecx, ebx         ; i = gap

    shell_i_loop:
        cmp ecx, n
        jge shell_gap_reduce ; i >= n → reduce gap

        ; temp = arr[i]
        mov edx, ecx
        shl edx, 2
        mov esi, [arr + edx] ; temp = arr[i]

        mov edi, ecx         ; j = i

    shell_shift_loop:
        ; if j < gap → stop
        cmp edi, ebx
        jl shell_insert

        ; if arr[j - gap] <= temp → stop
        mov edx, edi
        sub edx, ebx          ; j - gap
        shl edx, 2
        mov eax, [arr + edx]  ; arr[j - gap]

        cmp eax, esi          ; arr[j-gap] <= temp ?
        jle shell_insert

        ; shift arr[j-gap] into arr[j]
        mov edx, edi
        shl edx, 2
        mov [arr + edx], eax

        sub edi, ebx          ; j -= gap
        jmp shell_shift_loop

    shell_insert:
        ; store temp into arr[j]
        mov edx, edi
        shl edx, 2
        mov [arr + edx], esi

        inc ecx               ; i++
        jmp shell_i_loop

    shell_gap_reduce:
        shr ebx, 1            ; gap = gap / 2
        mov eax, ebx
        jmp shell_gap_loop

    shell_done:
        ret
    shellSort ENDP


    end main