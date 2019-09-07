; 101985894 - Pham Phuc Hung LE

;////// Description:
; _ In this Assignment, i will draw PAC MAN animation

;////// FINISH:
; _ Make the clear screen function
; _ Draw the screen frame to the screen
; _ Draw the script frame to the screen
; _ Draw "ANIMATION" text to the screen
; _ Draw PACMAN animation to the screen
; _ Handle the input button

;--------------------------------------------------------------------------------------

;THIS IS THE FILE FOR DRAWING ANIMATION
;format the file to img when its compiled
format binary as 'img'

;memory address of BASE
BASE = $3F000000

; Origin, ORG is used to set the assembler location counter.
org $0000
mov sp,$1000 ; This is the stack pointer, we set the size of the stack

; Set the address of the screen to r0
mov r0,BASE
bl FB_Init
; r0 now contains address of screen
; SCREEN_X and BITS_PER_PIXEL are global constants populatead by FB_Init

and r0,$3FFFFFFF ; Convert Mail Box Frame Buffer Pointer From BUS Address To Physical Address ($CXXXXXXX -> $3XXXXXXX)
str r0,[FB_POINTER] ; Store Frame Buffer Pointer Physical Address

mov r7,r0 ; r0 is containing the screen address and we add it to r7 for making a backup

; Draw Pixel at (X,Y)
;r0 = address of screen we write to (r7 = backup of screen start address)

;--------------------------------------------------------------------------------------

; Return CPU ID (0..3) Of The CPU Executed On
mrc p15,0,r0,c0,c0,5 ; R0 = Multiprocessor Affinity Register (MPIDR)
ands r0,3 ; R0 = CPU ID (Bits 0..1)
bne CoreLoop ; IF (CPU ID != 0) Branch To Infinite Loop (Core ID 1..3)

;Set GPIO
GPIO_OFFSET = $200000


;////////////////////////////// START OF THE PROGRAM //////////////////////////////////


;--------------------------------------------------------------------------------------
;------------------------------ DRAW SCREEN FRAME--------------------------------------
; Step 0: Set colour to Red
mov r6,$F800
; Step 1: Draw top edge and bottom edge
; Step 2: Draw left edge and right edge

; Draw top edge from (1,1) to (639,1)
mov r4, #1 ;X coordinate
mov r5, #1 ;Y coordinate
DrawTopEdge:
        ; setup parameters for draw pixel
        mov r0,r7       ;screen address
        mov r1,r4       ;X coordinate
        mov r2,r5       ;Y coordinate
        mov r3,r6       ;colour

        ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
        ; draw pixel at (X,Y)
        bl drawpixel

        ; increment x
        add r4,#1

        ; if not reach right screen border (X=640), go back to draw next pixel
        cmp r4,SCREEN_X
        blt DrawTopEdge

; Draw bottom edge from (1,479) to (639,479)
mov r4, #1              ;X coordinate
mov r5, #479 AND $FF00  ;Y coordinate
orr r5, #479 AND $00FF
DrawBottomEdge:
        ; setup parameters for draw pixel
        mov r0,r7       ;screen address
        mov r1,r4       ;X coordinate
        mov r2,r5       ;Y coordinate
        mov r3,r6       ;colour

        ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
        ; draw pixel at (X,Y)
        bl drawpixel

        ; increment x
        add r4,#1

        ; if not reach right screen border (X=640), go back to draw next pixel
        cmp r4,SCREEN_X
        blt DrawBottomEdge

; Draw left edge from (1,1) to (1,479)
mov r4, #1 ;X coordinate
mov r5, #1 ;Y coordinate
DrawLeftEdge:
        ; setup parameters for draw pixel
        mov r0,r7       ;screen address
        mov r1,r4       ;X coordinate
        mov r2,r5       ;Y coordinate
        mov r3,r6       ;colour

        ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
        ; draw pixel at (X,Y)
        bl drawpixel

        ; increment y
        add r5,#1

        ; if not reach bottom screen border (Y=480), go back to draw next pixel
        cmp r5,SCREEN_Y
        blt DrawLeftEdge

; Draw right edge from (639,1) to (639,479)
mov r4, #639 AND $FF00  ;X coordinate
orr r4, #639 AND $00FF
mov r5, #1              ;Y coordinate
DrawRightEdge:
        ; setup parameters for draw pixel
        mov r0,r7       ;screen address
        mov r1,r4       ;X coordinate
        mov r2,r5       ;Y coordinate
        mov r3,r6       ;colour

        ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
        ; draw pixel at (X,Y)
        bl drawpixel

        ; increment y
        add r5,#1

        ; if not reach bottom screen border (Y=480), go back to draw next pixel
        cmp r5,SCREEN_Y
        blt DrawRightEdge

;-------------------------------------END OF DRAWING FRAME-----------------------------



;--------------------------------------------------------------------------------------
;---------------------------------CHECK THE INPUT BUTTON ------------------------------
b CHECKBUTTON      ; Go to check button function

ButtonClicked:     ; If button is clicked, continue the program


mov r6, $7E0       ; Color Green
bl ChangeScreenColor

;-------------------------------- END OF CHECKING INPUT BUTTON ------------------------



;--------------------------------------------------------------------------------------
;------------------------------ DRAW FRAME FOR SCRIPT----------------------------------

;Set colour to Blue
mov r6,$1F

; Draw top edge
mov r4, #80             ;X coordinate
mov r5, #130            ;Y coordinate
DrawTopEdge$:
        ; setup parameters for draw pixel
        mov r0,r7       ;screen address
        mov r1,r4       ;X coordinate
        mov r2,r5       ;Y coordinate
        mov r3,r6       ;colour

        ; draw pixel at (X,Y)
        bl drawpixel

        ; increment x
        add r4,#1

        ; if not reach the limit, go back to draw next pixel
        mov r8, #560 AND $FF00
        orr r8, #560 AND $00FF
        cmp r4, r8
        bls DrawTopEdge$

; Draw bottom edge
mov r4, #80             ;X coordinate
mov r5, #200  ;Y coordinate
DrawBottomEdge$:
        ; setup parameters for draw pixel
        mov r0,r7       ;screen address
        mov r1,r4       ;X coordinate
        mov r2,r5       ;Y coordinate
        mov r3,r6       ;colour

        ; draw pixel at (X,Y)
        bl drawpixel

        ; increment x
        add r4,#1

        ; ; if not reach the limit, go back to draw next pixel
        mov r8, #560 AND $FF00
        orr r8, #560 AND $00FF
        cmp r4, r8
        blt DrawBottomEdge$

; Draw left edge
mov r4, #80 ;X coordinate
mov r5, #130 ;Y coordinate
DrawLeftEdge$:
        ; setup parameters for draw pixel
        mov r0,r7       ;screen address
        mov r1,r4       ;X coordinate
        mov r2,r5       ;Y coordinate
        mov r3,r6       ;colour

        ; draw pixel at (X,Y)
        bl drawpixel

        ; increment y
        add r5,#1

        ; if not reach the limit, go back to draw next pixel
        cmp r5, #200
        blt DrawLeftEdge$

; Draw right edge
mov r4, #560 AND $FF00  ;X coordinate
orr r4, #560 AND $00FF
mov r5, #130            ;Y coordinate
DrawRightEdge$:
        ; setup parameters for draw pixel
        mov r0,r7       ;screen address
        mov r1,r4       ;X coordinate
        mov r2,r5       ;Y coordinate
        mov r3,r6       ;colour

        ; draw pixel at (X,Y)
        bl drawpixel

        ; increment y
        add r5,#1

        ; if not reach the limit, go back to draw next pixel
        cmp r5,#200
        blt DrawRightEdge$

;---------------------------END OF DRAWING FRAME FOR SCRIPT----------------------------





;---------------------------------------------------------------------------------------
;------------------------- DRAWING TEXT TO THE SCREEN ----------------------------------
; Delay 1 second and then print the text to screen
bl Delay1Sec

; The text will be "ANIMATION"
; The Space between each letter will be 8px
DrawingText:
;Set colour to Blue
mov r6,$1F

; Draw letter A to screen
mov r4, #120            ;X coordinate
mov r5, #150            ;Y coordinate
DrawLetterA:
        ;Draw left edge of letter A
        push {r4,r5}    ; Store the X, Y coor to stack
        dRawLeftEdgeA:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x, decrement y
                add r5,#1
                sub r4,#1
                ; if not read the limit, keep drawing
                cmp r5,#180     ; The length of the edge is 30px
                bls dRawLeftEdgeA
                pop {r4,r5}     ; Restore X, Y coor from stack

        ;Draw right edge of letter A
        dRawRightEdgeA:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x, increment y
                add r5,#1
                add r4,#1
                ; if not read the limit, keep drawing
                cmp r5,#180    ; The length of the edge is 30px
                bls dRawRightEdgeA

        ; Draw Line of letter A
        mov r4, #106   ;X coordinate
        mov r5, #165   ;Y coordinate
        drawLineA:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x
                add r4,#1
                ; if not read the limit, keep drawing
                cmp r4,#134    ; The length of the linr is 28px
                bls drawLineA


; Delay 0.5 sec and then draw next character
bl Delay05Sec


; Draw letter N to screen
mov r4, #158   ;X coordinate
mov r5, #150   ;Y coordinate
DrawLetterN:
        ;Draw left edge of letter N
        push {r4,r5}    ; Store the X, Y coor to stack
        dRawLeftEdgeN:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                bl drawpixel

                ; decrement y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180     ; The length of the edge is 30px
                bls dRawLeftEdgeN
                pop {r4,r5}     ; Restore X, Y coor from stack

        ; Draw line of letter N
        dRawLineN:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x, increment y
                add r5,#1
                add r4,#2
                ; if not read the limit, keep drawing
                cmp r5,#180    ; The length of the edge is 30px
                bls dRawLineN
                ; Fill up the blank between pixels in line of letter N
                mov r4, #157
                mov r5, #149
                ; increment x, increment y
                add r5,#1
                add r4,#2
                fillLineBlank:
                        ; setup parameters for draw pixel
                        mov r0,r7       ;screen address
                        mov r1,r4       ;X coordinate
                        mov r2,r5       ;Y coordinate
                        mov r3,r6       ;colour

                        ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                        ; draw pixel at (X,Y)
                        bl drawpixel

                        ; increment x, increment y
                        add r5,#1
                        add r4,#2
                        ; if not read the limit, keep drawing
                        cmp r5,#180    ; The length of the edge is 30px
                        blt fillLineBlank


        ; Draw Right edge of letter N
        mov r4, #218   ;X coordinate
        mov r5, #150   ;Y coordinate
        drawRightEdgeN:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180   ; The length of the edge is 30px
                bls drawRightEdgeN


; Delay 0.5 sec and then draw next character
bl Delay05Sec


; Draw letter I to screen
mov r4, #226   ;X coordinate
mov r5, #150   ;Y coordinate
DrawLetterI:
        ;Draw letter I
        dRawLineI:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180     ; The length of the line is 30px
                bls dRawLineI


; Delay 0.5 sec and then draw next character
bl Delay05Sec


; Draw letter M to screen
mov r4, #234   ;X coordinate
mov r5, #150   ;Y coordinate
DrawLetterM:
        ;Draw left edge of letter N
        push {r4,r5}    ; Store the X, Y coor to stack
        dRawLeftEdgeM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180     ; The length of the edge is 30px
                bls dRawLeftEdgeM
                pop {r4,r5}     ; Restore X, Y coor from stack

        ; Draw line of letter N
        dRawLeftLineM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x, increment y
                add r5,#1
                add r4,#1
                ; if not read the limit, keep drawing
                cmp r5,#180    ; The length of the edge is 30px
                bls dRawLeftLineM

        dRawRightLineM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x, decrement y
                sub r5,#1
                add r4,#1
                ; if not read the limit, keep drawing
                cmp r5,#150    ; The length of the edge is 30px
                bge dRawRightLineM

        ; Draw Right edge of letter M
        mov r4, #297 AND $FF00   ;X coordinate
        orr r4, #297 AND $00FF
        mov r5, #150   ;Y coordinate
        drawRightEdgeM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180   ; The length of the edge is 30px
                bls drawRightEdgeM


; Delay 0.5 sec and then draw next character
bl Delay05Sec


; Draw the second letter A to screen
mov r4, #335 AND $FF00   ;X coordinate
orr r4, #335 AND $00FF
mov r5, #150   ;Y coordinate
DrawLetterA2:
        ;Draw left edge of letter A
        push {r4,r5}    ; Store the X, Y coor to stack
        dRawLeftEdgeA2:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment y, decrement x
                add r5,#1
                sub r4,#1
                ; if not read the limit, keep drawing
                cmp r5,#180     ; The length of the edge is 30px
                bls dRawLeftEdgeA2
                pop {r4,r5}     ; Restore X, Y coor from stack

        ;Draw right edge of letter A
        dRawRightEdgeA2:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x, increment y
                add r5,#1
                add r4,#1
                ; if not read the limit, keep drawing
                cmp r5,#180    ; The length of the edge is 30px
                bls dRawRightEdgeA2

        ; Draw Line of letter A
        mov r4, #321 AND $FF00   ;X coordinate
        orr r4, #321 AND $00FF
        mov r5, #165   ;Y coordinate
        drawLineA2:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x
                add r4,#1
                ; if not read the limit, keep drawing
                mov r8,#349 AND $FF00
                orr r8,#349 AND $00FF
                cmp r4,r8    ; The length of the linr is 28px
                bls drawLineA2


; Delay 0.5 sec and then draw next character
bl Delay05Sec


; Draw the letter T to screen
mov r4, #350 AND $FF00   ;X coordinate
orr r4, #350 AND $00FF
mov r5, #150   ;Y coordinate
DrawLetterT:
        ;Draw top edge of letter T
        dRawTopEdgeT:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x
                add r4,#1
                ; if not read the limit, keep drawing
                mov r8,#398 AND $FF00
                orr r8,#398 AND $00FF
                cmp r4,r8     ; The length of the edge is 48px
                bls dRawTopEdgeT

        ;Draw line of letter T
        mov r4, #373 AND $FF00   ;X coordinate
        orr r4, #373 AND $00FF
        mov r5, #150             ;Y coordinate
        dRawLineT:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180    ; The length of the line is 30px
                bls dRawLineT


; Delay 0.5 sec and then draw next character
bl Delay05Sec


; Draw the second letter I to screen
mov r4, #406 AND $FF00   ;X coordinate
orr r4, #406 AND $00FF
mov r5, #150             ;Y coordinate
DrawLetterI2:
        ;Draw left edge of letter N
        dRawLineI2:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180     ; The length of the line is 30px
                bls dRawLineI2


; Delay 0.5 sec and then draw next character
bl Delay05Sec



; Draw the letter O to screen
mov r4, #414 AND $FF00  ; X coordinate
orr r4, #414 AND $00FF
mov r5, #150            ; Y coordinate
DrawLetterO:
        ; Draw top edge of letter O
        push {r4,r5}
        drawTopEdgeO:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x
                add r4,#1
                ; if not read the limit, keep drawing
                mov r8,#462 AND $FF00
                orr r8,#462 AND $00FF
                cmp r4,r8     ; The length of the line is 52px
                bls drawTopEdgeO

        ; Draw right edge of the letter O
        drawRightEdgeO:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; decrement y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180     ; The length of the line is 30px
                bls drawRightEdgeO
                pop {r4,r5}

        ; Draw the left edge of the letter O
        drawLeftEdgeO:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180     ; The length of the line is 30px
                bls drawLeftEdgeO

        ; Draw the bottom edge of the letter O
        drawBottomEdgeO:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x
                add r4,#1
                ; if not read the limit, keep drawing
                mov r8,#462 AND $FF00
                orr r8,#462 AND $00FF
                cmp r4,r8     ; The length of the line is 52px
                bls drawBottomEdgeO



; Delay 0.5 sec and then draw next character
bl Delay05Sec


; Draw second letter N to screen
mov r4, #470 AND $FF00   ;X coordinate
orr r4, #470 AND $00FF
mov r5, #150   ;Y coordinate
DrawLetterN2:
        ;Draw left edge of letter N
        push {r4,r5}    ; Store the X, Y coor to stack
        dRawLeftEdgeN2:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180     ; The length of the edge is 30px
                bls dRawLeftEdgeN2
                pop {r4,r5}     ; Restore X, Y coor from stack

        ; Draw line of letter N
        dRawLineN2:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment x, increment y
                add r5,#1
                add r4,#2
                ; if not read the limit, keep drawing
                cmp r5,#180    ; The length of the edge is 30px
                bls dRawLineN2

                ; Fill up the blank between pixels in line of letter N
                mov r4, #469 AND $FF00
                orr r4, #469 AND $00FF
                mov r5, #149
                ; increment x, increment y
                add r5,#1
                add r4,#2
                fillLineBlank2:
                        ; setup parameters for draw pixel
                        mov r0,r7       ;screen address
                        mov r1,r4       ;X coordinate
                        mov r2,r5       ;Y coordinate
                        mov r3,r6       ;colour

                        ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                        ; draw pixel at (X,Y)
                        bl drawpixel

                        ; increment x, increment y
                        add r5,#1
                        add r4,#2
                        ; if not read the limit, keep drawing
                        cmp r5,#180    ; The length of the edge is 30px
                        blt fillLineBlank2

        ; Draw Right edge of letter N
        mov r4, #530 AND $FF00   ;X coordinate
        orr r4, #530 AND $00FF
        mov r5, #150   ;Y coordinate
        drawRightEdgeN2:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                bl drawpixel

                ; increment y
                add r5,#1
                ; if not read the limit, keep drawing
                cmp r5,#180   ; The length of the edge is 30px
                bls drawRightEdgeN2


;------------------------- END OF DRAWING TEXT ----------------------------------------


bl Delay2Secs    ; Wait 2s then refresh screen
bl REFRESH       ; CLEAR THE SCREEN


;--------------------------------------------------------------------------------------
;--------------------------DRAWING PACMAN----------------------------------------------
DrawLoop:
mov r4,#4               ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawOpenMouthPacMan


bl Delay001Sec
bl REFRESH


mov r4,#54              ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawNoOpenMouthPacMan

bl Delay001Sec
bl REFRESH

mov r4,#104             ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawOpenMouthPacMan

bl Delay001Sec
bl REFRESH

mov r4,#154             ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawNoOpenMouthPacMan

bl Delay001Sec
bl REFRESH

mov r4,#204             ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawOpenMouthPacMan

bl Delay001Sec
bl REFRESH


mov r4,#254             ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawNoOpenMouthPacMan

bl Delay001Sec
bl REFRESH


mov r4,#304             ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawOpenMouthPacMan

bl Delay001Sec
bl REFRESH

mov r4,#354             ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawNoOpenMouthPacMan

bl Delay001Sec
bl REFRESH

mov r4,#404             ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawOpenMouthPacMan

bl Delay001Sec
bl REFRESH

mov r4,#454             ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawNoOpenMouthPacMan

bl Delay001Sec
bl REFRESH

mov r4,#504             ; X coordinate
mov r5,#209             ; Y coordinate

bl DrawOpenMouthPacMan

bl Delay001Sec
bl REFRESH

b DrawLoop

;------------------------------- END OF DRAWING PACMAN ANIMATION-----------------------
;--------------------------------------------------------------------------------------
; // LOOP
Loop:
        b Loop  ;wait forever

CoreLoop:       ; Infinite Loop For Core 1..3
        b CoreLoop

;--------------------------------------------------------------------------------------
;--------------------------------------DRAW OBJECT TO SCREEN---------------------------
; In this part, it will draw 2 objects, that are No-open-mouth PACMAN and Open-mouth PACMAN

; // Draw No open mouth PAC MAN
DrawNoOpenMouthPacMan:
        push {lr} ; WHILE RUNNING THIS PART, lr (link register) will be overwritten by Draw pixel
; This Part will take the given coordinate and draw PACMAN
; OBJECT OF THE ANIMATION IS PACMAN

; Y = 239 is in the middle of the screen
; The shape of PACMAN is Octagon

; 2. Set colour to Pink
        mov r6,$FBE0 AND $FF00  ; Color orange
        orr r6,$FBE0 AND $00FF

; 3. Draw PACMAN
        ; Draw right edge of PAC MAN
        push {r4,r5}
        add r5, #60
        mov r8, r5
        sub r5, #60
        DrawLeftEdgePM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment y
                add r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bls DrawLeftEdgePM


        ; Draw the left bottom diagonal of PAC MAN
        add r5, #27
        mov r8, r5
        sub r5, #27
        DrawLeftBottomDiagonalPM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x, increment y
                add r4,#1
                add r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bls DrawLeftBottomDiagonalPM

        ; Draw the Bottom edge of PAC MAN
        add r4, #60
        mov r8, r4
        sub r4, #60
        DrawBottomEdgePM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x
                add r4,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r4, r8
                bls DrawBottomEdgePM


        ;Draw the rigth bottom diagnal of PAC MAN
        sub r5, #29
        mov r8, r5
        add r5, #29
        DrawRightBottomDiagonalPM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x, decrement y
                add r4,#1
                sub r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bge DrawRightBottomDiagonalPM
                pop {r4,r5}



        ; Draw the left top diagonal of PAC MAN
        sub r5, #27
        mov r8, r5
        add r5, #27
        DrawLeftTopDiagonalPM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x, decrement y
                add r4,#1
                sub r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bge DrawLeftTopDiagonalPM


        ; Draw the Top Edge of PAC MAN
        add r4, #60
        mov r8, r4
        sub r4, #60
        DrawTopEdgePM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x
                add r4,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r4,r8
                bls DrawTopEdgePM


        ; Draw right top diagnal of PAC MAN
        add r5, #27
        mov r8, r5
        sub r5, #27
        DrawRightTopDiagnal:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x, increment y
                add r4,#1
                add r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bls DrawRightTopDiagnal

        ; Draw right edge of PAC MAN
        add r5, #60
        mov r8, r5
        sub r5, #60
        push {r4,r5}
        DrawRightEdgePM:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment y
                add r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bls DrawRightEdgePM

        ; THIS PART IS PACMAN EYE DRAWING
        pop {r4,r5}
        sub r4, #45
        mov r8, r4
        add r4, #15
        DrawEyeTopEdge:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; decrement y
                sub r4,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r4,r8
                bge DrawEyeTopEdge

        ; Draw eye left edge
        add r5, #15
        mov r8, r5
        sub r5, #15
        push {r4,r5}            ; Store r4,r5 value into stack and keep them for filling eye color
        DrawEyeLeftEdge:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment y
                add r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bls DrawEyeLeftEdge

        ; Draw bottom edge for eye
        add r4, #15
        mov r8, r4
        sub r4, #15
        DrawEyeBottomEdge:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x
                add r4,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r4,r8
                bls DrawEyeBottomEdge

        ; Draw eye right edge
        sub r5, #15
        mov r8, r5
        add r5, #15
        DrawEyeRightEdge:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; decrement y
                sub r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bge DrawEyeRightEdge


        ; FIll color to the eye
        pop {r4,r5}
        add r4, #15
        mov r10, r4

        add r5, #15
        mov r11, r5

        sub r4, #15
        sub r5, #15

        FillEyeColor:
                mov r0,r7       ; screen address
                mov r1,r4       ; X coordinate
                mov r2,r5       ; Y coordinate
                mov r3,r6       ; colour
                ;assume BITS_PER_PIXEL, SCREEN_X are shared constants
                bl drawpixel

                ;increment X
                add r4,#1

                ; if X < limit, fill next pixel
                cmp r4,r10
                bls FillEyeColor      ;branch less than or same

                ; else, move to next line
                ; set X back to 1st column and Y to next row
                sub r4,#15
                add r5,#1

                ; if Y < limit, keep filling the color
                cmp r5,r11
                bls FillEyeColor


        ; This part is for drawing PAC MAN mouth
        add r5, #30
        add r4, #45
        mov r8, r4
        sub r4, #45
        DrawClosedMouth:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x
                add r4,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r4,r8
                bls DrawClosedMouth


                pop {lr}
                bx lr ; RETURN


; // Draw Open mouth PAC MAN
DrawOpenMouthPacMan:
        push {lr} ; WHILE RUNNING THIS PART, lr (link register) will be overwritten by Draw pixel
; This Part will take the given coordinate and draw PACMAN
; OBJECT OF THE ANIMATION IS PACMAN

; Y = 239 is in the middle of the screen
; The shape of PACMAN is Octagon

; 2. Set colour to Pink
        mov r6,$FBE0 AND $FF00  ; Color orange
        orr r6,$FBE0 AND $00FF

; 3. Draw PACMAN
        ; Draw right edge of PAC MAN
        push {r4,r5}
        add r5, #60
        mov r8, r5
        sub r5, #60
        DrawLeftEdgePM$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment y
                add r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bls DrawLeftEdgePM$


        ; Draw the left bottom diagonal of PAC MAN
        add r5, #27
        mov r8, r5
        sub r5, #27
        DrawLeftBottomDiagonalPM$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x, increment y
                add r4,#1
                add r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bls DrawLeftBottomDiagonalPM$

        ; Draw the Bottom edge of PAC MAN
        add r4, #60
        mov r8, r4
        sub r4, #60
        DrawBottomEdgePM$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x
                add r4,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r4, r8
                bls DrawBottomEdgePM$


        ;Draw the rigth bottom diagnal of PAC MAN
        sub r5, #13
        mov r8, r5
        add r5, #13
        DrawRightBottomDiagonalPM$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x, decrement y
                add r4,#1
                sub r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bge DrawRightBottomDiagonalPM$




        ; Draw the left top diagonal of PAC MAN
        pop {r4,r5}
        sub r5, #27
        mov r8, r5
        add r5, #27
        DrawLeftTopDiagonalPM$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; assume BITS_PER_PIXEL, SCREEN_X are shared constants
                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x, decrement y
                add r4,#1
                sub r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bge DrawLeftTopDiagonalPM$


        ; Draw the Top Edge of PAC MAN
        add r4, #60
        mov r8, r4
        sub r4, #60
        DrawTopEdgePM$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x
                add r4,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r4,r8
                bls DrawTopEdgePM$


        ; Draw right top diagnal of PAC MAN
        add r5, #27
        mov r8, r5
        sub r5, #27
        DrawRightTopDiagnal$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x, increment y
                add r4,#1
                add r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bls DrawRightTopDiagnal$

        ; Draw right edge of PAC MAN
        add r5, #60
        mov r8, r5
        sub r5, #60
        push {r4,r5}
        DrawRightEdgePM$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,$0000      ;colour

                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment y
                add r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bls DrawRightEdgePM$

        ; THIS PART IS PACMAN EYE DRAWING
        pop {r4,r5}
        sub r4, #45
        mov r8, r4
        add r4, #15
        DrawEyeTopEdge$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; decrement x
                sub r4,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r4,r8
                bge DrawEyeTopEdge$

        ; Draw eye left edge
        add r5, #15
        mov r8, r5
        sub r5, #15
        push {r4,r5}            ; Store r4,r5 value into stack and keep them for filling eye color
        DrawEyeLeftEdge$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment y
                add r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bls DrawEyeLeftEdge$

        ; Draw bottom edge for eye
        add r4, #15
        mov r8, r4
        sub r4, #15
        DrawEyeBottomEdge$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; increment x
                add r4,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r4,r8
                bls DrawEyeBottomEdge$

        ; Draw eye right edge
        sub r5, #15
        mov r8, r5
        add r5, #15
        DrawEyeRightEdge$:
                ; setup parameters for draw pixel
                mov r0,r7       ;screen address
                mov r1,r4       ;X coordinate
                mov r2,r5       ;Y coordinate
                mov r3,r6       ;colour

                ; draw pixel at (X,Y)
                push {r8}
                bl drawpixel

                ; decrement y
                sub r5,#1

                ; if not reach the limit, keep drawing
                pop {r8}
                cmp r5,r8
                bge DrawEyeRightEdge$


        ; FIll color to the eye
        pop {r4,r5}
        add r4, #15
        mov r10, r4

        add r5, #15
        mov r11, r5

        sub r4, #15
        sub r5, #15

        FillEyeColor$:
                mov r0,r7       ; screen address
                mov r1,r4       ; X coordinate
                mov r2,r5       ; Y coordinate
                mov r3,r6       ; colour
                bl drawpixel

                ;increment X
                add r4,#1

                ; if X < limit, fill next pixel
                cmp r4,r10
                bls FillEyeColor$      ;branch less than or same

                ; else, move to next line
                ; set X back to 1st column and Y to next row
                sub r4,#15
                add r5,#1

                ; if Y < limit, keep filling the color
                cmp r5,r11
                bls FillEyeColor$




        ; This part is for draw mouth
        add r5, #30
        push {r4,r5}
        add r4, #45
        mov r8, r4
        sub r4, #45
        DrawMouthOpen:
                DrawMouthTopDiagonal:
                        ; setup parameters for draw pixel
                        mov r0,r7       ;screen address
                        mov r1,r4       ;X coordinate
                        mov r2,r5       ;Y coordinate
                        mov r3,r6       ;colour

                        ; draw pixel at (X,Y)
                        push {r8}
                        bl drawpixel

                        ; increment x, decrement y
                        sub r5,#1
                        add r4,#1

                        ; if not reach the limit, keep drawing
                        pop {r8}
                        cmp r4,r8
                        bls DrawMouthTopDiagonal



                ; Draw bottom diagonal of pac man mouth
                pop {r4,r5}
                add r4, #30
                mov r8, r4
                sub r4, #30
                DrawMouthBottomDiagonal:
                        ; setup parameters for draw pixel
                        mov r0,r7       ;screen address
                        mov r1,r4       ;X coordinate
                        mov r2,r5       ;Y coordinate
                        mov r3,r6       ;colour

                        ; draw pixel at (X,Y)
                        push {r8}
                        bl drawpixel

                        ; increment x, increment y
                        add r5,#1
                        add r4,#1

                        ; if not reach the limit, keep drawing
                        pop {r8}
                        cmp r4,r8
                        bls DrawMouthBottomDiagonal


                pop {lr}
                bx lr ; RETURN


;--------------------------------------END OF DRAWING OBJECT---------------------------
;--------------------------------------------------------------------------------------




;--------------------------------------------------------------------------------------
;------------------LIBRARY DECLARATION-------------------------------------------------

include "FBinit16.asm"
include "timer2_2Param.asm"
include "drawpixel.asm"
;----------------- End of library declaration -----------------------------------------


;--------------------------------------------------------------------------------------
;------------DELAY 0.01 SECOND---------------------------------------------------------
Delay001Sec:
; store r6 (register containing color) r7 (screen address), and the link register to stack
push {r4,r5,r6,r7,lr}

; Setup parameters for DELAY function
; 1. Set base address of timer
mov r0,BASE

; 2. set desired delay
; delay = 0.01s = 10000 us => $27 10
mov r1,$2700
orr r1,$0010
; call DELAY function to delay 0.05s
bl DELAY          ; THIS DELAY FUNCTION WILL OVERWRITE R6, R7, LINK REGISTER THATS WHY I NEED TO PUSH THE LR TO STACK

; restore r7 (screen address), and link register from stack
pop {r4,r5,r6,r7,lr}
bx lr
;-------------------------------------------------------------------------------------


;------------DELAY 0.5 SECOND---------------------------------------------------------
Delay05Sec:
; store r6 (register containing color) r7 (screen address), and the link register to stack
push {r4,r5,r6,r7,lr}

; Setup parameters for DELAY function
; 1. Set base address of timer
mov r0,BASE

; 2. set desired delay
; delay = 0.5s = 500000 us => $7 A1 20
mov r1,$70000
orr r1,$0A100
orr r1,$00020

; call DELAY function to delay 0.5s
bl DELAY          ; THIS DELAY FUNCTION WILL OVERWRITE R6, R7, LINK REGISTER THATS WHY I NEED TO PUSH THE LR TO STACK

; restore r7 (screen address), and link register from stack
pop {r4,r5,r6,r7,lr}
bx lr
;--------------------------------------------------------------------------------------



;------------DELAY 1 SECOND------------------------------------------------------------
Delay1Sec:
; store r6 (register containing color) r7 (screen address), and the link register to stack
push {r4,r5,r6,r7,lr}

; Setup parameters for DELAY function
; 1. Set base address of timer
mov r0,BASE

; 2. set desired delay
; delay = 9s = 9000000 us => $89 54 40
mov r1,$F0000
orr r1,$04200
orr r1,$00040

; call DELAY function to delay 1s
bl DELAY          ; THIS DELAY FUNCTION WILL OVERWRITE R6, R7, LINK REGISTER THATS WHY I NEED TO PUSH THE LR TO STACK

; restore r7 (screen address), and link register from stack
pop {r4,r5,r6,r7,lr}
bx lr
;--------------------------------------------------------------------------------------



;----------- DELAY 2 SECONDS ----------------------------------------------------------
Delay2Secs:
; store r7 (screen address), and the link register to stack
push {r4,r5,r6,r7,lr}

; Setup parameters for DELAY function
; 1. Set base address of timer
mov r0,BASE

; 2. set desired delay
; delay = 2s = 2000000 us => $1E 84 80
mov r1,$1E0000
orr r1,$008400
orr r1,$000080

; call DELAY function to delay 5s
bl DELAY         ; THIS DELAY FUNCTION WILL OVERWRITE R6, R7, LINK REGISTER THATS WHY I NEED TO PUSH THE LR TO STACK

; restore r7 (screen address), and link register from stack
pop {r4,r5,r6,r7,lr}
bx lr

;--------------------------------------------------------------------------------------



;--------------------------------------------------------------------------------------
;--------------------CLEAR SCREEN FUNCTION TO REFRESH THE SCREEN ----------------------
REFRESH:
mov r6,$0000
ChangeScreenColor:
push {r4,r5,lr}
; 1. Set colour to Black

; 2. Set the starting point to top left conner (2,2) inside frame
mov r4, #2
mov r5, #2

; 3. set r10 and r11 to be MAX_X and MAX_Y respectively
mov r10,#639 AND $FF00
orr r10,#639 AND $00FF

mov r11,#479 AND $FF00
orr r11,#479 AND $00FF

ClearScreen:
        mov r0,r7       ; screen address
        mov r1,r4       ; X coordinate
        mov r2,r5       ; Y coordinate
        mov r3,r6       ; colour
        bl drawpixel

        ;increment X
        add r4,#1

        ; if X < MAX_X, clear next pixel
        cmp r4,r10
        blt ClearScreen      ;branch less than or same

        ; else, move to next line
        ; set X back to 1st column and Y to next row
        mov r4,#2
        add r5,#1

        ; if Y < MAX_Y, keep clearing screen
        cmp r5,r11
        blt ClearScreen
        pop {r4,r5,lr}
        bx lr

;------------------ END OF CLEARSCREEN FUNCTION ---------------------------------------









;--------------------------------------------------------------------------------------
;------------------ CHECK BUTTON FUNCTION ---------------------------------------------
CHECKBUTTON:
mov r0,BASE
orr r0,GPIO_OFFSET

; Set GPIO 17 as an input
ldr r1,[r0,#4] ;read function register for GPIO 10 - 19
bic r1,r1,#27  ;bit clear  27 = 9 * 3    = read access
str r1,[r0,#4] ;10 input

; If button is not being cliked, the RED LED will be on
; Turn on the RED LED, GPIO 18
mov     r10,#1
lsl     r10,#24
str     r10,[r0,#4]
mov     r10,#1
lsl     r10,#18
str     r10,[r0,#28]


check:
ldr r12,[r0,#52]       ; read gpios 0-31
tst r12,#1024          ; use tst to check bit 10
bne cont      ; if == 0


b check

; If button is being clicked, the RED LED will be disabled
; The Green one will be on
cont:

; Turn off the RED LED, GPIO 18
mov     r10,#1
lsl     r10,#24
str     r10,[r0,#4]
mov     r10,#1
lsl     r10,#18
str     r10,[r0,#40]
; Turn on the GREEN LED, GPIO 23
mov     r9,#1
lsl     r9,#9
str     r9,[r0,#8]
mov     r9,#1
lsl     r9,#23
str     r9,[r0,#28]

b ButtonClicked
;-------------------------- END OF CHECKING BUTTON FUNCTION --------------------------




;////////////////////////////// END OF THE PROGRAM ///////////////////////////////////


