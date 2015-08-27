.data
	welcome: .asciiz "\nWelcome to two player hangman!!!\n"
	
	clearScreen:.asciiz"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

	promptContinue:.asciiz "Enter any letter to continue."

	equaltext: .asciiz "equal\n"
	notequal: .asciiz "not equal\n"
	prompt: .asciiz "\nPlease enter a letter: "
	invalidInput: .asciiz "\nInvalid input, try again. \n"
	congratsMessage: .asciiz "\n********************************\n********************************\n*******CONGRATS, YOU WON********\n********************************\n********************************\n"
	loseMessage: .asciiz "\n\nYou lose\n\n"
	scoreMessage: .asciiz "\t\t\t\t SCORE: "
	playAgainMessage: .asciiz "\n\t\tPlay again? (y/n)\n"					
	playerAmountPrompt: .asciiz "\nOne or Two Players? (1/2)\n"
	EnterAnswerString:.asciiz "Enter a WACKY string for your pal to guess!!!!!\n"
	rightWordMessage:.asciiz "Is this the correct word?(y/n)"
	nullchar: .ascii "\0"
	newline: .asciiz "\n"
	dashChar: .asciiz "-"

	inputChar: .word 0
	charNum: .word 0
	checkNum: .word 0
	stringCheck:.word 1
	score: .word 0
	highscore: .word 0
	
	newLine: .asciiz "\n"
	twoPlayerBool:.word 0
	
	inputCharNum:.word 0
	statusCharNum:.word 0
	#newline:.ascii"\n"
	#dashChar:.ascii"-"
	currentWord:.space 100
	statusString:.space 100
	#inputChar:.space 1
		
	answer: .space 100
	status: .space 100
	
	wordLength: .word 0
	WORD0:		.asciiz	"computer\n"
	WORD1:		.asciiz	"processor\n"
	WORD2:		.asciiz	"motherboard\n"
	WORD3:		.asciiz	"graphics\n"
	WORD4:		.asciiz "network\n"
	WORD5:		.asciiz "ethernet\n"
	WORD6:		.asciiz "memory\n"
	WORD7:		.asciiz "microsoft\n"
	WORD8:		.asciiz	"linux\n"
	WORD9:		.asciiz	"transistor\n"
	WORD10:		.asciiz	"antidisestablishmentarianism\n"
	WORD11:		.asciiz "protocol\n"
	WORD12:		.asciiz "instruction\n"
	
	newLinechar: .ascii "\n"
	

	wordList:		.word	WORD0, WORD1, WORD2, WORD3, WORD4, WORD5, WORD6, WORD7, WORD8, WORD9, WORD10, WORD11, WORD12
	
.text

############################ INITIALIZES GAME #############################################

	welcomeCode:
		
		li $v0,4
		la $a0,welcome
		
		syscall
		
	main:	
		jal playerTwoSetup
		
 		li $v0,4
 		la $a0,promptContinue
 		
 		syscall
		
		li $v0,12
		syscall
		
		
		
		#beq $s0,$v0,twoPlayerSetup
		
		#eventually all the code related to saving variables and such will be deleted and I'll just jump to the nextInput function
		#only reason I havent taken this out yet is because this is the basic structure of the nextInput function, so I figured these comments and stuff would help
		
		
		
		la $t1, answer				#loads address of whatever word into $t1
		la $t2, inputChar			#loads the address of input char to $t2
		la $t3, status	
 		#lw $t1, 0($t1)
 		#lw $t2,a 0($t2)
 		
 		sw $t1,charNum				#saves the address of $t1 in charNum, that way I never have to worry about accidently editing the data in answer
 							#plus, this code is basically reusec down in the nextInput label. It will allow me to reset the pointer to the answer string
 		addi $t3,$t3,1
 		sw $t3,stringCheck
 		
 		
 		la $t0,nullchar				#just loaded to see if the null character works, I use $s0 pretty much through out the entire program almost like a constant
 		
 		lb $s0,0($t0)				#loads only the byte, since thats all that really matters at this point
 		
 		
 		li $v0,4				#$v0 = 4: print string
 		la $a0,prompt				#$a0 = (prompt): pointer to string
 		
 		syscall
 
 		li $s2, 7				#number of lives. Initially 7.
 		li $t9, 0				#helps check to see if a life is lost. Like a boolean where 0 is true and anything else is false.
 		 
 		#li $v0,12				#$v0 = 12: syscall for read character
 		
 		#syscall
 		
 		#sw $v0,inputChar			#inputchar = $v0
 		
 		j nextInputFirst
 		 
 #####################################Two Player Mode Setup
 
playerSelect:

	move $s7,$ra

	li $v0,4
	la $a0,playerAmountPrompt
	syscall
	
	li $v0,12
	syscall
	
	li $s1,'2'
	
	beq $v0,$s1,playerTwoSetup
	
	li $s1, '1'
	beq $v0,$s1,playerOneSetup
	
	j playerSelect


		
playerTwoSetup:

	li $v0,4
	la $a0, newline
	syscall
	
	li $v0,4
	la $a0,EnterAnswerString
	
	syscall
	
	la $t0,currentWord
	sw $t0,inputCharNum
	
	
	la $t0,statusString
	sw $t0,statusCharNum
	
	li $t1,'\n'
	sb $t1,0($t0)
	addi $t0,$t0,1
	sw $t0,statusCharNum
	
 	j loopTwoPlayer
 
loopTwoPlayer:		 
	
	lb $s0,newline
	lw $t0,inputCharNum
	
	li $v0,12
	
	syscall
	
	move $t5,$v0
	
	sb $t5,inputChar
	beq $t5,$s0,endTwoPlayer
	
	sb $t5,0($t0)
	
	addi $t0,$t0,1
	sw $t0,inputCharNum	
	
	j charTestTwoPlayer
	
charTestTwoPlayer:

	lw $t3, statusCharNum

	lb $t5,inputChar
	
	li $t4,96
	
	bgt $t5,$t4, upperTestTwoPlayer

	li $t4,91
	
	blt $t5,$t4, lowerTestTwoPlayer

	sb $t5,0($t3)
	addi $t3,$t3,1
	sw $t3,statusCharNum

	j loopTwoPlayer
	
upperTestTwoPlayer:

	lw $t3,statusCharNum

	li $t4,122
	ble $t5,$t4,UpdateStatusTwoPlayer
	
	sb $t5,0($t3)
	addi $t3,$t3,1
	sw $t3,statusCharNum
	
	j loopTwoPlayer
	
lowerTestTwoPlayer:
	
	lw $t3,statusCharNum

	li $t4,65
	bge $t5,$t4,UpdateStatusTwoPlayer
	
	sb $t5,0($t3)
	addi $t3,$t3,1
	sw $t3,statusCharNum
	
	j loopTwoPlayer	
	
UpdateStatusTwoPlayer:

	lw $t3,statusCharNum
	la $t4,dashChar
	
	lb $t4,0($t4)
	
	sb $t4,0($t3)
	addi $t3,$t3,1
	sw $t3,statusCharNum
	
	j loopTwoPlayer	
	
endTwoPlayer:

	lw $t0,inputCharNum
	addi $t0,$t0,1
	li $t1,'\n'
	sb $t1,0($t0)
	
	lw $t0,statusCharNum
	addi $t0,$t0,1
	li $t1,'\n'
	sb $t1,0($t0)
	
	la $a0, currentWord
	lw $t9, newLine
	
	move $s7,$ra
	
	#jal lengthLoop
	
	lw $t2,statusCharNum

	#li $v0, 4
	#la $a0, currentWord
	
	#syscall
	
	la $t0,statusString
	la $t1,status
	
	sw $t0,statusCharNum
	sw $t1,stringCheck
	
	la $t2,currentWord
	la $t3,answer
	
	sw $t2,inputCharNum
	sw $t3,charNum
	
	j convertToOldCode

convertToOldCode:

	lw $s0,statusCharNum
	lw $s1,stringCheck
	
	li $s4,'\0'
	
	lb $t0,0($s0)
	sb $t0,0($s1)
	
	addi $s0,$s0,1
	addi $s1,$s1,1
	
	sw $s0,statusCharNum
	sw $s1,stringCheck
	
	lw $s2,inputCharNum
	lw $s3,charNum
	
	lb $t1,0($s2)
	sb $t1,0($s3)

	addi $s2,$s2,1
	addi $s3,$s3,1
	
	sw $s2,inputCharNum
	sw $s3,charNum

	beq $s4,$t0,return

	j convertToOldCode

return:
	
	lw $s2,inputCharNum
	li $t0,'\0'
	
	sb $t0,0($s2)
	
	lw $s3,stringCheck
	sb $t1,0($s3)
	
	li $v0,4
	la $a0,clearScreen
	
	syscall

	jr $s7	
 	 
 		 
 		 
 ################# CHECKS TO SEE IF INPUT MATCHES THE ANSWER ##############################
 #LIST OF FUNCTIONS IN THIS SECTION |	BRIEF DESCRIPTION 
 #----------------------------------------------------------------------------------------
 # 1). checkLetterLoop -		takes the letter stored in inputchar and compares it letter to letter with the contents stored at charNum	
 # 2). charEqual			right now it does nothing, its a placeholder for future features
 # 3). charNotEq			^^^^^^^^^^
 #
 #---------------------------------------------------------------------------------------
 #	PLANNED FUNCTIONS	|	PLANNED FEATURES				
 #---------------------------------------------------------------------------------------
 # 1). scoreKeeper			keeps track of score
 # 2). guessAnswer			guessing the entire answer in the form of a string.
 #
 
 playerOneSetup:	
		jal randWord
		#jal getWordLength
		
		lw $a0, currentWord
		li $v0, 4
		syscall
		
		la $t0,statusString
		sw $t0,statusCharNum
		
		and $v0, $v0, $zero
 		la $t1, newLine
 		lb $t9,0($t1)
		
		#jal lengthLoop
		
		lw $a0, wordLength
		li $v0, 1
		syscall

		la $a0,statusString
		li $v0,4
		syscall
		
		jr $s7
randWord:
 		
 	li $v0, 42	#syscall number for random interger with bounds
 	and $a0,$a0, $zero #reset a0 to 0
	li $a1, 13	#this number means random int can't exceed, but not including, 13
	syscall	
 	mul $a0,$a0, 4
 	lw $t1, wordList($a0)
 	sw $t1, currentWord 
 		
 	jr $ra 	  	 
 		
 #lengthLoop:

#	lb	$t8, 0($a0)			# get the byte from the string	
#	beq	$t8, $t9, lengthLoopEnd
#			# If nul, quit loop
#		lw $t3,statusCharNum
#	
#		li $t1,'-'
#	
#		sb $t1,0($t3)
#		addi $t3,$t3,1
#		sw $t3,statusCharNum
#	
#	addi	$a0, $a0, 1			# increment dest address
#	addi	$v1, $v1, 1			# increment count
#	
#	j	lengthLoop			# jump to top of loop

#lengthLoopEnd:	
## Epilogue ##

#		lw $t3,currentWord
#		li $t1,'\0'
#		sb $t1,1($t3)
#		
#		lw $t3,statusCharNum
#		li $t1,'-'
#		addi $t3,$t3,1
#		sb $t1,0($t3)
#		li $t1,'\n'
#		sb $t1,1($t3)
#	sw 	$v1, wordLength
#	jr	$ra				#return
 		   
 		   
 	checkLetterLoop:
 		 
 		#registers
 		#$t1, address of the answer string
 		#$t2, address of the input from user
 		#$t3, individual character of the answer string
 		#$t4, the value of the input character
 		#$s0, address of null char/value of null char
 		
 		lw $t5, checkNum
		addi $t5,$t5,1
 		sw $t5,checkNum
 	
 		la $t2,inputChar
 		lw $t1,charNum				#since charNum holds the address of the string against which we will answer,
 							#we can now load it into $t1
 		
 		lb $t3, 0($t1)				#grabbing the contents of charNum and sticking it into a byte in $t3
 		lb $t4, 0($t2)				#grabbing the input character that I set up there to $t2. I know its bad
 							#practice to use t-registers in multiple functions,so I might change this to $s1 
 							#or an argument register.
		
		addi $t1,$t1,1				#adding 1 to $t1 and then saving it back to charNum will get us the next character in the string
		
		sw $t1,charNum				#^^^^^^^^^^^^^^^
		
		la $s0, nullchar			#loading the address of $s0 so that I can grab the null character and find the end of the string
		
		lb $s0,0($s0)				#^^^^^^^^^^^^^^^
		
		beq $s0,$t3,checkStatusString		#^^^^^ using the above to see whether or not the next character is null
		
		beq $t3,$t4,charEqual			#now getting back to the 
			
		j charNotEq
 		 
 	charEqual:
 		
 	#All the syscall stuff is debugging stuff. un comment to check whether or not the branching is working properly
 	#same goes for the commented out code in the charNotEq label.Right now nothing is happeneing in these really,
 	#but eventually I will add events and stuff like decreasing score/chances or increasing score depending on whether
 	#or not you got it right. This is just a placeholder for now, but a necessary one. I am also thinking about adding
 	# a new section for handling the score/guessing the answer right via whole word. Like if you had M-croSo-t, you could
 	#guess MicroSoft and get it right and more points, but we'd have to discuss a point system later. I really dont think this should be very hard
 	#since to get the above working I just loaded the second string address into a register and compared them byte to byte. Honestly, you might be able
 	#to use AND to do it faster, but I'm not sure and havent answered it yet.
		 	
 		#move $a0,$t3
 		#li $v0,11
 		
 		#syscall
		
		addi $t9, $t9, -1		#prevents life from being lost since input character is correct.
		lw $t0, score
		
		addi $t0,$t0,100
		
		sw $t0, score
	
		jal updateStatusString	
		jal correctSound
 		 		 			 			 					 			 					 			 		
 		j checkLetterLoop
 	
 	charNotEq:
 	
 		#la $a0, notequal
 		#li $v0, 4
 		
 		#syscall
 		
 		#move $a0,$t3
 		#li $v0,11
 		
 		#syscall
 
 		lw $t5,charNum
 		lb $t3,1($t5)
 		
 		la $t2, nullchar
 		lb $s0,0($t2)
 		
 		beq $t3,$s0,subtractScore
 		
 		j checkLetterLoop
 		
 	subtractScore:
 	
 		lw $t0, score
 		subi $t0,$t0,100	
 		sw $t0,score
 		
 		j checkLetterLoop
 		
 	updateStatusString:
 	
 		lw $t5,checkNum
 		
 		lw $t1,charNum
 		la $t2,status
 		
 		subi $t1,$t1,1
 		
 		add $t2,$t2,$t5		
 		
 		lb $t3,0($t1) 
		sb $t3,0($t2)
 		
 		jr $ra	
 		
 	checkStatusString:
 	
 		la $t1,dashChar
 		lw $t2,stringCheck
 		
 		lb $t3,0($t1)
 		lb $t4,0($t2)
 		
 		addi $t2,$t2,1
 		
 		sw $t2, stringCheck
 		
 		la $s0,newline
 		lb $s0,0($s0)
 		
 		lb $t5,0($t2)
 		
   		beq $s0,$t5,win
		
 		beq $t3,$t4,nextInput
 		
 		bne $t3,$t4,checkStatusString
 		
 		
########################### HANDELING INPUT ###############################################
#LIST OF FUNCTIONS IN THIS SECTION	|	BRIEF DESCRIPTION
#------------------------------------------------------------------------------------------
# 1). nextInput					takes in the next char for input checking
# 2). upperBoundCheck				Checks to see if the value of the character inputted is below the letter values of 90 and 122
# 3). lowerBoundCheck				Checks to see if the value of the character inputted is above the minimum letter values of 65 and 97
# 4). toLower					self explanatory, I figured we could just make all our answers lower case and then be ok.
#
#------------------------------------------------------------------------------------------
#	PLANNED FUNCTIONS		|	PLANNED FEATURES
#==========================================================================================
#
#

 	nextInput:

 		#registers
 		#$t1, address of answer string
 		beqz $t9, loselife		#checks to see if a wrong character was inputted last round. If so, lose a life!
 		li $t9, 0			#resets boolean
 		
 		la $t3,status
 		addi $t3,$t3,1
 		sw $t3, stringCheck
 	
 		li $t5, 0
 		sw $t5, checkNum
 	
 		li $v0,4
 		la $a0, status
 		
 		syscall
 		
		li $v0,4
 		la $a0,scoreMessage
 		
 		syscall
 		
 		li $v0,1
 		lw $a0,score
 		
 		syscall
 	
 		la $t1, answer			
 		
 		sw $t1, charNum			#resets charNum to the original answer text
 	
 		li $v0,4			
 		la $a0,prompt			
 		
 		syscall	
 					
nextInputFirst:	
	
 		li $v0,12			
 		
 		syscall
 		
 		sw $v0,inputChar		
 		
 		move $a0,$v0
 		
 		#li $v0,4
 		#la $a0,scoreMessage
 		
 		#syscall
 		
 		#li $v0,1
 		#lw $a0,score
 		
 		#syscall
 		
 		li $v0,4
 		la $a0,newline
 		
 		syscall
 		
 		lw $a0, inputChar
 		
		j upperBoundCheck
 		
	upperBoundCheck:
	
		#$t1, input from nextInput function
		#$t2, 22
	
		move $t1, $a0
		
		#li $t2, 90					#
								#
		#ble $t1,$t2,lowerBoundCheck 			#I realized that these two lines were redundant, so I commented them out.
		
		li $t2, 122
		
		ble $t1,$t2, lowerBoundCheck
		
		la $a0, invalidInput
		li $v0,4
		
		syscall
		
		j nextInput
	
	lowerBoundCheck:
	
		lb $t3,inputChar
		
		li $t2,65
		
		sub $t3,$t3,$t2				
		
		ble $t3,26,toLower
		
		li $t2, 97
		
		bge $t1,97, checkLetterLoop
		
		la $a0, invalidInput
		li $v0,4
		
		syscall
		
		j nextInput
		
	toLower:
		
		li $t2, 32
		move $t1,$a0
		
		add $t1,$t1,$t2
		
		sw $t1,inputChar
		
		j checkLetterLoop
		
	playAgain:
	
		li $v0,4
		la $a0, playAgainMessage
		
		syscall
		
		li $v0,12
		
		syscall
		
		move $t0,$v0
		
		li $t1,121
		
		beq $t1,$t0,main
		
		li $t1, 89
		
		beq $t1,$t0,main
		
		j exit
		
	setup:
		
		li $t0,0
		
		sw $t0,score	
		
		j nextInput
		
	win:
	
		la $a0, congratsMessage
		li $v0,4
		
		syscall
		
		j playAgain
		
	loselife:
		
		addi $s2, $s2, -1		#lose one life
 		beqz $s2, lose			#if all lives lost, go to gameover
 		jal wrongSound
 		li $t9, 1			#prevents infinite loop of losing lives/getting a gameover from one incorrect character
 		
 		
 		j nextInput			#go back to recieve input
	lose:
	
		la $a0, loseMessage
		li $v0,4

		syscall	
		
		j playAgain
		
	exit:	
	
		li $v0,10
		syscall
		
.text
##########################################################################################################
wrongSound:

addi $t0, $0, 12
addi $t1, $0, 45
addi $t2, $0, 46
play: 

li $v0, 31	#code for MIDI out
add $a0, $t0, $t1		#pitch (1-127)
li $a1, 1750		#duration in ms
li $a2, 0		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 75
syscall

li $v0, 31	#code for MIDI out
add $a0, $t0, $t2		#pitch (1-127)
li $a1, 1750		#duration in ms
li $a2, 0		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 75
syscall

li $v0, 31	#code for MIDI out
add $a0, $t0, $t1		#pitch (1-127)
li $a1, 1750		#duration in ms
li $a2, 0		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 75
syscall

li $v0, 31	#code for MIDI out
add $a0, $t0, $t2		#pitch (1-127)
li $a1, 1750		#duration in ms
li $a2, 0		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 75
syscall

addi, $t0, $t0, -1

bne $0, $t0, play

jr $ra
##########################################################################################################


##########################################################################################################
correctSound:
li $v0, 31	#code for MIDI out
li $a0, 60		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall

li $v0, 31	#code for MIDI out
li $a0, 64		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall

li $v0, 31	#code for MIDI out
li $a0, 67		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall

li $v0, 31	#code for MIDI out
li $a0, 72		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall


li $v0, 31	#code for MIDI out
li $a0, 67		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall

li $v0, 31	#code for MIDI out
li $a0, 71		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall

li $v0, 31	#code for MIDI out
li $a0, 74		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall

li $v0, 31	#code for MIDI out
li $a0, 79		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall



li $v0, 31	#code for MIDI out
li $a0, 60		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall

li $v0, 31	#code for MIDI out
li $a0, 64		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall

li $v0, 31	#code for MIDI out
li $a0, 67		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall

li $v0, 31	#code for MIDI out
li $a0, 72		#pitch (1-127)
li $a1, 1500		#duration in ms
li $a2, 11		#instrument (0-127)
li $a3, 120		#volume (0-127)
syscall

li $v0, 32
li $a0, 100
syscall

jr $ra
#########################################################################################################


