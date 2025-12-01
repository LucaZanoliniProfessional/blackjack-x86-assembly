; Data Section
; ############
section 	.data

; ###############################################
; external function references from CS12-Lib
; ###############################################
extern printByteArray
extern printEndl
extern exitNormal
extern printRBX
extern printRCX
extern printRDX
extern printRAX
extern getQuad

; ###############################################
; Variable Definitions
; ###############################################
helloMsg  db  "CS12"
spacer    db  "                                                                 "
helloLen  dq  60
welcomeMsg db "WELCOME TO BLACKJACK! (A = 1 or 11, T,J,Q,K = 10)"
wMsgLength dq $-welcomeMsg 
youMsg db "You're dealt a "
youLength dq $-youMsg
dealerMsg db "The dealer drew a "
dealerLength dq $-dealerMsg
playerTotalMsg db "Your Total: "
playerTotalMsgLength dq $-playerTotalMsg
dealerTotalMsg db "Dealer Total: "
dealerTotalMsgLength dq $-dealerTotalMsg
cardPrompt db "Would you like another card? (Enter 1 for yes): "
cardPromptLength dq $-cardPrompt
bustMsg db "Sorry, that's a bust! You lose!"
bustMsgLength dq $-bustMsg
bjMsg db "That's Blackjack! You Win!"
bjMsgLength dq $-bjMsg
aceValueChange db "Ace value changed from 11 to 1"
aceVCMsg dq $-aceValueChange
dealerBustMsg db "The dealer has busted! You win!"
dealerBustMsgLength dq $-dealerBustMsg
playerBeatDealer db "You beat the dealer! Congratulations! You win!"
playerBDLength dq $-playerBeatDealer
dealerBeatPlayer db "Uh-oh! Looks like the dealer wins!"
dealerBPLength dq $-dealerBeatPlayer
tieMsg db "This game ends in a tie. No money lost or gained."
tieMsgLength dq $-tieMsg
winningsMsg db "Your Winnings: "
winningsMsgLength dq $-winningsMsg
betAmount db "Enter bet (no more than current money amount): $"
betAmountLength dq $-betAmount
displayMoney db "Total Cash: $"
displayMoneyLength dq $-displayMoney
playAgain db "Would you like to play another hand? (Enter 1 for yes): "
playAgainLength dq $-playAgain
noMoney db "You're out of money! Would you like to play again? (Enter 1 for yes): "
noMoneyLength dq $-noMoney
moneyEarned db "You walked away with: $"
moneyEarnedLength dq $-moneyEarned




cards db "A23456789TJQK"
numbers db "0123456789"



; BSS Section
; ############ 
section		.bss

; ###############################################
; Variable Declarations
; ###############################################


; Code Section
; ############	
section		.text
	

;DRAW
%macro draw 4
    obtainRandom
    mov rdx, qword [%4]   ; load the length of the output
    mov rsi, %3           ; load the message
    call printByteArray         ; print the message
    mov rdx, 1
    lea rsi, byte[cards + rax-1]
    call printByteArray
    call printEndl
    isTen
    isAce %2
    add rax, %1
    mov %1, rax
    ifAce %1, %2
%endmacro

;GET RANDOM NUMBER GREATER THAN 0 AND LESS THAN 14	
%macro obtainRandom 0
    %%notZero:
    xor rdx, rdx
    rdrand rax
    mov rbx, 14
    div rbx
    cmp rdx, 0
    je %%notZero
    mov rax, rdx
%endmacro

;CHANGE THE VALUE OF JACKS KING AND QUEENS TO 10
%macro isTen 0
    cmp rax, 10
    jg %%change
    jmp %%next
    %%change:
    mov rax, 10
    %%next:
%endmacro

;ADD VALUE OF ACE
%macro isAce 1
    cmp rax, 1
    je %%aceCounter
    jmp %%out
    %%aceCounter:
    inc %1
    mov rax, 11
    %%out:
%endmacro

;IF ACE IN HAND NEEDS TO CHANGE
%macro ifAce 2
    cmp %2, 0
    jg %%checkTen
    jmp %%exitIfAce
    
    %%checkTen:
    mov rbx, 21
    cmp %1, rbx
    jg %%changeAce
    jmp %%exitIfAce
    %%changeAce:
    mov rbx, 10
    sub %1, rbx
    mov rdx, qword[aceVCMsg]
    mov rsi, aceValueChange
    call printByteArray
    call printEndl
    dec %2
    %%exitIfAce:
%endmacro

;DISPLAY TOTALS
%macro displayTotal 3
    mov rdx, qword[%3]
    mov rsi, %2
    call printByteArray
    mov rax, %1
    
    mov rcx, 0
    
    %%greaterTen:
    
    cmp rax, 10
    jl %%lessTen
    
    xor rdx, rdx
    mov rbx, 10
    div rbx
    push rdx
    inc rcx
    jmp %%greaterTen
  
    %%lessTen:   
    
    mov rdx, 1
    lea rsi, byte[numbers + rax]
    call printByteArray
    
    %%displayRemainder:
    cmp rcx, 0
    je %%leaveDisplayRemainder
    pop rbx
    lea rsi, byte[numbers + rbx]
    call printByteArray
    dec rcx
    jmp %%displayRemainder
    
    %%leaveDisplayRemainder:
    
    call printEndl
    call printEndl
%endmacro

; ###############################################
; ### Begin Program 
; ###############################################	
global _start

_start:

    newGame:
    
    mov rdx, qword [wMsgLength]   ; load the length of the output
    mov rsi, welcomeMsg           ; load the message
    call printByteArray         ; print the message
    call printEndl              ; print an endline
    call printEndl
    
    mov r15, 20; ;MONEY COUNTER
    
    newHand:
    
    mov r8, 0 ;PLAYER COUNTER
    mov r9, 0 ;DEALER COUNTER
    mov r12, 0 ;PLAYER ACE COUNTER
    mov r13, 0 ;DEALER ACE COUNTER
    
    
    ;(0)BET PROMPT
    bet:
    displayTotal (r15), displayMoney, displayMoneyLength
    mov rdx, qword[betAmountLength]
    mov rsi, betAmount
    call printByteArray
    call getQuad
    call printEndl 

    ;(0.5)CONVERSION FROM GETQUAD HEX TO DECIMAL
    
    mov rbx, 1
    mov rcx, 0
    mov rsi, 16
    
    
    convertBet:
    mov rdx, 10
    push rdx
    xor rdx, rdx
    div rax, rsi
    mov rdi, rax
    mov rax, rdx
    mul rbx
    add rcx, rax
    mov rax, rbx
    pop rdx
    mul rdx
    mov rbx, rax
    mov rax, rdi
    cmp rax, 0
    jg convertBet
    
    mov rax, rcx
    
    cmp rax, r15
    jg bet
    cmp rax, 0
    jle bet
    mov r14, rax
    
    
    ;(1)PLAYER FIRST CARD DEALT 
    draw (r8), (r12), youMsg, youLength
    
    ;(2)DEALER DRAW
    draw(r9), (r13), dealerMsg, dealerLength
    
    ;(3)PLAYER SECOND CARD DEALT
    draw (r8), (r12), youMsg, youLength
    
    ;(4) DIsplay Total
    displayTotal (r8), playerTotalMsg, playerTotalMsgLength
    
    ;(4.5) ChECKING RESULTS AFTER FIRST TWO CARDS
    mov rbx, 21
    cmp r8, rbx
    je winGameBJ
    
    ;(5) PLAYER TURN LOOP
    newCard:
    call printEndl
    mov rdx, qword [cardPromptLength]   ; load the length of the output
    mov rsi, cardPrompt           ; load the message
    call printByteArray         ; print the message
    call printEndl              ; print an endline
    
    mov rbx, 1
    call getQuad
    call printEndl
    cmp rax, rbx
    jne noCard
    
    draw (r8), (r12), youMsg, youLength
    displayTotal (r8), playerTotalMsg, playerTotalMsgLength
    
    ;(5.5) CHECKING RESULTS AFTER DEALT CARD
    mov rbx, 21
    cmp r8, rbx
    jl newCard
    
    cmp r8, rbx
    je winGameBJ
    
    cmp r8, rbx
    jg bust
    
    noCard:
    
    
    ;(6) DEALER TURN
    displayTotal (r9), dealerTotalMsg, dealerTotalMsgLength
    dealerDraw:
    draw(r9), (r13), dealerMsg, dealerLength
    displayTotal (r9), dealerTotalMsg, dealerTotalMsgLength
    mov rbx, 17 ;THE LOOP WILL END WHEN DEALER IS AT 17 or HIGHER
    cmp r9, rbx
    jl dealerDraw
    
    mov rbx, 21 ;HAS DEALER BUSTED?
    cmp r9, rbx
    jg dealerBust
    
    cmp r8, r9 ;DID THE PLAYER BEAT THE DEALER'S HAND?
    jg playerWin
    
    cmp r8, r9 ;DID THE PLAYER AND DEALER TIE
    je gameTie
    
    ;(7)ENDGAME RESULTS
    
    ;dealerWin:
    displayTotal (r8), playerTotalMsg, playerTotalMsgLength
    call printEndl
    mov rdx, qword[dealerBPLength]
    mov rsi, dealerBeatPlayer
    call printByteArray
    call printEndl
    sub r15, r14
    jmp finish
    
    gameTie:
    displayTotal (r8), playerTotalMsg, playerTotalMsgLength
    call printEndl
    mov rdx, qword[tieMsgLength]
    mov rsi, tieMsg
    call printByteArray
    call printEndl
    jmp finish
    
    playerWin:
    displayTotal (r8), playerTotalMsg, playerTotalMsgLength
    call printEndl
    mov rdx, qword[playerBDLength]
    mov rsi, playerBeatDealer
    call printByteArray
    call printEndl
    add r15, r14
    jmp finish
    
    dealerBust:
    call printEndl
    mov rdx, qword[dealerBustMsgLength]
    mov rsi, dealerBustMsg
    call printByteArray
    call printEndl
    add r15, r14
    jmp finish
    
    bust:
    call printEndl
    mov rdx, qword [bustMsgLength]   ; load the length of the output
    mov rsi, bustMsg           ; load the message
    call printByteArray         ; print the message
    call printEndl              ; print an endline
    sub r15, r14
    jmp finish
    
    winGameBJ:
    call printEndl
    mov rdx, qword[bjMsgLength]
    mov rsi, bjMsg
    call printByteArray
    call printEndl
    add r15, r14
    jmp finish
    
    
    ;(8) GAME FINISHED
    finish:
    cmp r15, 0
    je gameOver
    call printEndl
    mov rdx, qword[playAgainLength]
    mov rsi, playAgain
    call printByteArray
    call getQuad
    call printEndl
    cmp rax, 1
    je newHand
    
    ;(9)
    jmp finalMsg
    gameOver:
    call printEndl
    mov rdx, qword[noMoneyLength]
    mov rsi, noMoney
    call printByteArray
    call getQuad
    call printEndl
    call printEndl
    cmp rax, 1
    je newGame
    
    finalMsg:
    displayTotal (r15), moneyEarned, moneyEarnedLength
    call printEndl
    
    
    

; ###############################################
; exit with an exit code of 0
; ###############################################
	call	exitNormal
