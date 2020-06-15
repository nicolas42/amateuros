;;;
;;; Disk_Load: Read DH sectors into ES:BX memory location from drive DL
;;;
disk_load:
        push dx         ; store DX on stack so we can check number sectors actually read later

        mov ah, 02h     ; int 13/ ah=02h, BIOS read disk sectors into memory
        mov al, dh      ; number of sectors we want to read ex. 1
        mov ch, 00h     ; cylinder #
        mov dh, 00h     ; head #
        mov cl, 02h     ; start reading at CL sector #

        int 13h         ; BIOS interrups for disk functions

        jc disk_error   ; jump if disk read error (carry flag set/ = 1)

        pop dx          ; restore DX from the stack
        cmp dh, al      ; if AL (# sectors actually read) != DH (# sectors we wanted to read)
        jne disk_error  ; error, sectors read not equal to number we wanted to read

        ret             ; return to caller

disk_error:
        mov bx, DISK_ERROR_MSG
        call print_string
        hlt

DISK_ERROR_MSG: db 'Disk read error!11!!!', 0
