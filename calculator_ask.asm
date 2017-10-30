// CALCULATOR.ASM
//==========================================================
	.orig	x3000

//OTHER DATA
J0	.blkw	x0001
J1	.blkw	x0001
J2	.blkw	x0001
J3	.blkw	x0001
J4	.blkw	x0001
J5	.blkw	x0001
J6	.blkw	x0001

// MAIN SUBROUTINE
//---------------------------------------------------------- 
MAIN	JSR TEST

	//Insert additional tests here...
	
	JSR STOP	// Halt the processor

STREG	ST	R0	J0
	ST	R1	J1
	ST	R2	J2
	ST	R3	J3
	ST	R4	J4
	ST	R5	J5
	ST	R6	J6
	;ST	R7	J7
	RET
LDREG	;LD	R0	J0
	LD	R1	J1
	LD	R2	J2
	LD	R3	J3
	LD	R4	J4
	LD	R5	J5
	LD	R6	J6
	LD	R7	J7
	RET


// SAMPLE ARITHMETIC SUBROUTINES (IMPRACTICAL TO USE)
//==========================================================

// NEGATION...
//  Precondition: R1 = x
// Postcondition: R0 = -x
//                Registers R1 through R7 remain unchanged
NEG	NOT R0 R1
	ADD R0 R0 #1
	RET


// ADDITION...
//  Precondition: R1 = x
//                R2 = y
// Postcondition: R0 = x + y
//                Registers R1 through R7 remain unchanged
PLUS	ADD R0 R1 R2
	RET


// BASIC ARITHMETIC SUBROUTINES
//==========================================================

// SUBTRACTION...
//  Precondition: R1 = x
//                R2 = y
// Postcondition: R0 = x - y
//                Registers R1 through R7 remain unchanged
SUB	ST	R7	J7
	JSR	STREG
	NOT	R2	R2
	ADD	R2	R2	x0001
	ADD	R0	R1	R2
	LD	R7	J7
	RET

// MULTIPLICATION...
//  Precondition: R1 = x
//                R2 = y
// Postcondition: R0 = x * y
//                Registers R1 through R7 remain unchanged
MULT	ST	R7	J7
	AND	R0	R0	x0000
	JSR	STREG
MULLOOP	ADD	R0	R1	R0
	ADD	R2	R2	#-1
	BRnp	MULLOOP
	JSR	LDREG
	LD	R7	J7
	RET
// DATA FOR THE MULTIPLY SUBROUTINE...




// DIVISION...
//  Precondition: R1 = x
//                R2 = y
// Postcondition: R0 = x / y
//                Registers R1 through R7 remain unchanged
//                Prints error message if y == 0
DIV	ST	R7	DIVREG
	ST	R7	J7
	JSR	STREG
	ADD	R2	R2	x0000
	BRnp	DIVSKIP
	LEA	R0	DIVERR
	PUTS
	AND	R3	R3	x0000
	JSR	DIVEND
DIVSKIP	AND	R0	R0	x0000
	ADD	R5	R1	x0000
	BRp	DIVCON0
	NOT	R5	R5
	ADD	R5	R5	x0001
DIVCON0	ADD	R6	R2	x0000
	BRp	DIVCON1
	NOT	R6	R6
	ADD	R6	R6	x0001
DIVCON1	NOT	R6	R6
	ADD	R6	R6	x0001
	AND	R3	R3	x0000
DIVLOOP	ADD	R3	R3	x0001
	ADD	R5	R5	R6
	BRzp	DIVLOOP
	ADD	R0	R3	x0000
	ADD	R0	R0	#-1
	ADD	R3	R0	x0000
	LD	R6	J7
	JSR	MULT
	ST	R6	J7
	ADD	R0	R0	x0000
	BRp	DIVEND
	NOT	R3	R3
	ADD	R3	R3	x0001
DIVEND	ADD	R0	R3	x0000
	JSR 	LDREG
	LD	R7	DIVREG
	RET
		
DIVERR	.stringz	"Error division by 0\n"
// DATA FOR THE DIVISION SUBROUTINE...
DIVREG	.blkw	x0002


// MODULUS...
//  Precondition: R1 = x
//                R2 = y
// Postcondition: R0 = x % y
//                If y == 0, prints and error message and sets R0 = 0
//                Registers R1 through R7 remain unchanged
MOD	ST	R7	MREGVAL
	ADD	R2	R2	x0000
	BRnp	MODSKIP
	LEA	R0	MODERR
	PUTS
	AND R0	R0	x0000
	JSR	MODEND
MODSKIP	JSR	DIV
	ADD	R3	R1	x0000
	ADD	R4	R2	x0000
	ADD	R1	R0	x0000
	JSR	MULT
	NOT	R0	R0
	ADD	R0	R0	x0001
	ADD	R0	R0	R3
MODEND	LD	R7	MREGVAL
	RET
	
// DATA FOR THE MODULUS SUBROUTINE...
MREGVAL	.blkw	x0002
MODERR	.stringz	"Error mod by 0\n"


// SUBROUTINES FOR PRINTING INTEGERS
//==========================================================

// PRINT A NUMBER...
//  Precondition: R0 = a 16-bit integer value 
// Postcondition: R0 is printed to the console in decimal
//                Registers R0 through R7 remain unchanged
PRINT	
	ST R1	C1
	ST R2	C2
	ST R0 R0PRINT	// R0PRINT = R0 (saves R0)
	ST R7 R7PRINT	// R7PRINT = R7 (saves return address)
	ST R0 MODPRINT
	ST R0 DIVPRINT
	LEA R4	PRSTR
	ST 	R4	STCOUNT
	JSR	STREG
	LEA	R4	PRSTR
	ST	R4	STRT
	//ADD	R4	R4	x0001
	LD 	R6	DIGCH
	NOT	R6	R6
	ADD R6	R6	x0001
	ADD R6	R0	R6
	BRnp PRSKIP
	LD 	R0	DIGCH1
	OUT
	LD 	R0	DIGCH2
	OUT
	LD 	R0	DIGCH3
	OUT
	LD 	R0	DIGCH2
	OUT
	LD 	R0	NEWLINE
	OUT
	LD	R7	R7PRINT
	ST	R7	J7
	JSR	LDREG
PRSKIP	ADD	R0	R0	x0000
	BRzp	PRLOOP
	NOT	R0	R0
	ADD	R0	R0	x0001
	ADD	R5	R0	x0000
	LD	R0	HYPHEN
	OUT
	ADD	R0	R5	x0000
	ST	R0	DIVPRINT
PRLOOP	LD	R1	DIVPRINT
	AND	R2	R2	x0000
	ADD	R2	R2	x000A
	JSR	MOD
	ST	R0	MODPRINT
	LD	R1	DIVPRINT
	JSR	DIV
	ST	R0	DIVPRINT
	LD	R0	MODPRINT
	JSR	TODIGIT
	LD 	R4	STCOUNT
	STR	R0	R4	x0000
	ADD	R4	R4	x0001
	ST	R4	STCOUNT
	LD	R0	DIVPRINT
	BRnp	PRLOOP
FINPR	LD	R0	STCOUNT
	ADD R0	R0	#-1
	ST 	R0	STCOUNT
	LDR R0	R0	x0000
	OUT
	ADD R0	R0	x0000
	BRnp	FINPR
	LD	R0	NEWLINE
	OUT
	LD R1	C1
	LD R2	C2
	ST R1	J1
	ST R2	J2
	LD	R7	R7PRINT
	ST	R7	J7
	JSR	LDREG
	
////////// ---------------------------- REPLACE THIS SECTION
	JSR TODIGIT	// !!!only good for printing single digits!!!
	OUT		// print(R0)
	
	LD R0 NEWLINE	// 
	OUT		// print('\n')
////////// ---------------------------- REPLACE THIS SECTION
	
	LD R0 R0PRINT	// R0 = R7PRINT (restores R0)
	LD R7 R7PRINT	// R7 = R7PRINT (restores return address)
	RET		//

// DATA FOR THE PRINT SUBROUTINE...
R0PRINT	.blkw #1	// Allocates space for saving R0 in PRINT
R7PRINT	.blkw #1	// Allocates space for saving R7 in PRINT
HYPHEN	.fill #45	// ASCII Digit '-'
NEWLINE	.fill #10	// ASCII '\n'
MODPRINT .blkw x0002
DIVPRINT .blkw x0002
PRSTR	.blkw	x000A
STRT	.blkw	x0002
STCOUNT	.blkw	x0002
C1	.blkw	x0001
C2	.blkw	x0001
DIGCH	.fill x13B0
DIGCH1	.fill	x0035
DIGCH2	.fill	x0030
DIGCH3	.fill	x0034

// CONVERT A NUMERICAL VALUE TO A DIGIT CHARACTER...
//  Precondition: R0 = a positive, single-digit integer value
// Postcondition: R0 = the ASCII character for the digit originally in R0
//                All other registers remain unchanged
TODIGIT	ST R1 R1DIGIT	// R1DIGIT = R1 (saves R1 into memory)
	LD R1 DIGIT0	// R1 = '0'
	ADD R0 R0 R1	// R0 = R0 + '0'
	LD R1 R1DIGIT	// R1 = R1DIGIT (restores R1 from memory)
	RET		//
	
// DATA FOR THE TODIGIT SUBROUTINE...
R1DIGIT	.blkw #1	// Allocates space for saving R1 in TODIGIT
DIGIT0	.fill #48	// ASCII Digit '0'
J7	.blkw	x0001

// ADVANCED ARITHMETIC SUBROUTINES
//==========================================================

// EXPONENTIATION...
//  Precondition: R1 = x
//                R2 = y, where y >= 0
// Postcondition: R0 = Math.pow(x,y)
//                Registers R1 through R7 remain unchanged
POW	ST	R7	POWREG
	JSR	STREG
	AND	R0	R0	x0000
	ADD	R0	R2	x0000
	BRz	POWONE
	AND	R3	R3	x0000
	AND	R6	R6	x0000
	ADD	R6	R6	x0001
	ST	R6	POWANS
	ADD	R3	R2	x0000
POWLOOP	LD	R2	POWANS
	JSR	STREG
	ST	R1	P1
	ST	R2	P2
	ST	R3	P3
	ST	R4	P4
	ST	R5	P5
	ST	R6	P6
	ST	R7	P7
	JSR	MULT
	LD	R1	P1
	LD	R2	P2
	LD	R3	P3
	LD	R4	P4
	LD	R5	P5
	LD	R6	P6
	LD	R7	P7
	ST	R0	POWANS
	ADD	R3	R3	#-1
	BRp	POWLOOP
POWDONE	LD	R7	POWREG
	ST	R7	J7
	LD	R0	POWANS
	JSR	LDREG
POWONE	AND	R0	R0	x0000
	ADD	R0	R0	x0001

// DATA FOR THE EXPONENTIATION SUBROUTINE...
POWANS	.blkw	x0002
POWREG	.blkw	x0002
P0	.blkw	x0001
P1	.blkw	x0001
P2	.blkw	x0001
P3	.blkw	x0001
P4	.blkw	x0001
P5	.blkw	x0001
P6	.blkw	x0001
P7	.blkw	x0001

// FACTORIAL...
//  Precondition: R1 = x, where x >= 0
// Postcondition: R0 = x!
//                Registers R1 through R7 remain unchanged
FACT	ST	R7	FACREG
	JSR	STREG
	AND	R0	R0	x0000
	ADD	R0	R0	x0001
	ST	R0	FACANS
	ADD	R2	R1	x0000
	ST	R2	FACPOS
FACLOOP	LD	R1	FACANS
	LD	R2	FACPOS
	JSR	MULT
	ST	R0	FACANS
	LD	R2	FACPOS
	ADD	R2	R2	#-1
	ST	R2	FACPOS
	BRp	FACLOOP
	LD	R7	FACREG
	ST	R7	J7
	JSR	LDREG
	RET
	
// DATA FOR THE FACTORIAL SUBROUTINE...
FACANS	.blkw	x0002
FACREG	.blkw	x0002
FACPOS	.blkw	x0002


// CUSTOM ROUTINE...DERIV: take the derivative of a monomial
//  Precondition: ... insert your precondition here ...
// Postcondition: ... insert your postcondition here ...
//
//      todo
//

DERIV 	ST 	R7	DEREG
	JSR	STREG

	LD 	R4	CONV
	NOT	R4	R4
	ADD R4	R4	x0001

	LEA	R0	PROMPTCOEFF
	PUTS
	GETC
	OUT
	ADD R0	R0	R4
	ADD R1	R0	x0000
	LD 	R2	PL1000
	JSR	MULT
	ST R0	CH1
	GETC
	OUT
	ADD R0	R0	R4
	ADD R1	R0	x0000
	LD 	R2	PL100
	JSR	MULT
	ST R0	CH2
	GETC
	OUT
	ADD R0	R0	R4
	ADD R1	R0	x0000
	LD 	R2	PL10
	JSR	MULT
	ST R0	CH3
	GETC
	OUT
	ADD R0	R0	R4
	ST R0	CH4

	LD R0	NEWLINE
	OUT

	LEA R0	PROMPTPOW
	PUTS
	GETC
	OUT
	ADD R0	R0	R4
	ADD R1	R0	x0000
	LD 	R2	PL1000
	JSR	MULT
	ST R0	PO1
	GETC
	OUT
	ADD R0	R0	R4
	ADD R1	R0	x0000
	LD 	R2	PL100
	JSR	MULT
	ST R0	PO2
	GETC
	OUT
	ADD R0	R0	R4
	ADD R1	R0	x0000
	LD 	R2	PL10
	JSR	MULT
	ST R0	PO3
	GETC
	OUT
	ADD R0	R0	R4
	ST 	R0	PO4

	LD 	R0	NEWLINE
	OUT

	AND R1	R1	x0000

	LD 	R1	CH1
	LD 	R2	CH2
	ADD R1	R1	R2
	LD 	R2	CH3
	ADD R1	R1	R2
	LD 	R2	CH4
	ADD R1	R1	R2

	AND R2	R2	x0000

	LD 	R2	PO1
	LD 	R3	PO2
	ADD R2	R2	R3
	LD 	R3	PO3
	ADD R2	R2	R3
	LD 	R3	PO4
	ADD R2	R2	R3

	ADD R5	R1	x0000
	ADD R6	R2	x0000
	JSR	MULT
	ADD R4	R0	x0000
	JSR PRINT
	LD 	R0	XVAL
	OUT
	LD 	R0	CARROT
	OUT
	ADD R0	R2	#-1
	JSR PRINT
	LD 	R7	DEREG
	ST 	R7	J7
	JSR	LDREG


// DATA FOR YOUR CUSTOM SUBROUTINE...
PROMPTCOEFF	.stringz	"ENTER COEFFICIENT (####): "
PROMPTPOW	.stringz	"ENTER POWER OF X (####):  "
DEREG	.blkw	x0002
XVAL	.fill	x0078
CARROT	.fill	x005E
CH1	.fill	x0000
CH2	.fill	x0000
CH3	.fill	x0000
CH4	.fill	x0000
PO1	.fill	x0000
PO2	.fill	x0000
PO3	.fill	x0000
PO4	.fill	x0000
PL1000	.fill	#1000
PL100	.fill	#100
PL10	.fill	#10
CONV 	.fill 	#48
//==========================================================
// ******** DO NOT ALTER ANYTHING BELOW THIS POINT ********
//==========================================================


// SUBROUTINE FOR TESTING EACH ARITHMETIC OPERATION
//----------------------------------------------------------
TEST	ST R7 R7TEST	// R7TEST = R7 (saves return address)
	
	LEA R0 START	//
	PUTS		// Output "START OF TESTS" message
	//--------------------------------------------------
	
	LD R2 ZERO	// 
	ADD R1 R2 #4	// R1 = 4 (example data)
	ADD R2 R2 #5	// R2 = 5 (example data)
	JSR PLUS	// R0 = R1 + R2
	JSR PRINT	// Should print "9"
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	LD R2 ZERO	// 
	ADD R1 R2 #12	// R1 = 12 (example data)
	ADD R2 R2 #4	// R2 = 4 (example data)
	JSR SUB		// R0 = R1 - R2
	JSR PRINT	// Should print "8"
	
	LD R2 ZERO	// 
	ADD R1 R2 #-8	// R1 = -8 (example data)
	ADD R2 R2 #5	// R2 = 5 (example data)
	JSR SUB		// R0 = R1 - R2
	JSR PRINT	// Should print "-13" (or "#" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #10	// R1 = 10 (example data)
	ADD R2 R2 #-6	// R2 = -6 (example data)
	JSR SUB		// R0 = R1 - R2
	JSR PRINT	// Should print "16" (or "@" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #-9	// R1 = -9 (example data)
	ADD R2 R2 #-3	// R2 = -3 (example data)
	JSR SUB		// R0 = R1 - R2
	JSR PRINT	// Should print "-6" (or "*" until PRINT is complete)
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	LD R2 ZERO	// 
	ADD R1 R2 #8	// R1 = 7 (example data)
	ADD R2 R2 #3	// R2 = 3 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "24" (or "H" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #4	// R1 = 4 (example data)
	ADD R2 R2 #-3	// R2 = -3 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "-12" (or "$" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #-2	// R1 = -4 (example data)
	ADD R2 R2 #5	// R2 = 3 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "-10" (or "&" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #-5	// R1 = -7 (example data)
	ADD R2 R2 #-6	// R2 = -3 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "30" (or "N" until PRINT is complete)
	
	LD R2 ZERO	// 
	ADD R1 R2 #0	// R1 = 0 (example data)
	ADD R2 R2 #3	// R2 = 3 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "0"
	
	LD R2 ZERO	// 
	ADD R1 R2 #7	// R1 = 7 (example data)
	ADD R2 R2 #0	// R2 = 0 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "0"
	
	LD R2 ZERO	// 
	ADD R1 R2 #0	// R1 = 0 (example data)
	ADD R2 R2 #0	// R2 = 0 (example data)
	JSR MULT	// R0 = R1 * R2
	JSR PRINT	// Should print "0"
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	LD R2 ZERO	// 
	ADD R1 R2 #11	// R1 = 11 (example data)
	ADD R2 R2 #4	// R2 = 4 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should print "2"
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should print "3"
	
	JSR PAUSE	// Pause until a key is pressed
	
	LD R2 ZERO	// 
	ADD R1 R2 #-12	// R1 = -12 (example data)
	ADD R2 R2 #4	// R2 = 4 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should print "-3" (or "-" until PRINT is written)
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should print "0"
	
	JSR PAUSE	// Pause until a key is pressed
	
	LD R2 ZERO	// 
	ADD R1 R2 #13	// R1 = 13 (example data)
	ADD R2 R2 #-2	// R2 = -2 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should print "-6" (or "*" until PRINT is written)
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should print "1"
	
	JSR PAUSE	// Pause until a key is pressed
	
	LD R2 ZERO	// 
	ADD R1 R2 #-9	// R1 = -9 (example data)
	ADD R2 R2 #-4	// R2 = -4 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should print "2"
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should print "-1" (or "/" until PRINT is written)
	
	JSR PAUSE	// Pause until a key is pressed
	
	LD R2 ZERO	// 
	ADD R1 R2 #0	// R1 = 0 (example data)
	ADD R2 R2 #4	// R2 = 4 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should print "0"
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should print "0"
	
	JSR PAUSE	// Pause until a key is pressed
	
	LD R2 ZERO	// 
	ADD R1 R2 #11	// R1 = 11 (example data)
	ADD R2 R2 #0	// R2 = 0 (example data)
	JSR DIV		// R0 = R1 / R2
	JSR PRINT	// Should display error message
	JSR MOD		// R0 = R1 % R2
	JSR PRINT	// Should display error message
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------
	
	LD R2 ZERO	// 
	ADD R1 R2 #3	// R1 = 3 (example data)
	ADD R2 R2 #5	// R2 = 5 (example data)
	JSR POW		// R0 = R1 ^ R2
	JSR PRINT	// Should print "243" (or "#  " until PRINT is written)
	
	JSR PAUSE	// Pause until a key is pressed
	LD R1 ZERO	// 
	ADD R1 R1 #7	// R1 = 7 (example data)
	JSR FACT	// R0 = R1!
	JSR PRINT	// Should print "5040" (or "à!!" until PRINT is written)
	
	JSR PAUSE	// Pause until a key is pressed
	//--------------------------------------------------

	LD 	R2	ZERO
	ADD R1	R2	#4
	ADD R2	R2	#5
	JSR	DERIV

	JSR PAUSE
	
	LD R7 R7TEST	// R7 = R7TEST (restores R7 from memory)
	RET
	
// DATA FOR THE MAIN SUBROUTINE
R7TEST .blkw #1
START	.stringz "===== START OF TESTS =====\n"
ZERO	.fill #0


// SUBROUTINE FOR PAUSING (DO NOT ALTER)
//----------------------------------------------------------
PAUSE	ST R0 R0PAUSE	// R0PAUSE = R0 (saves R0 into memory)
	ST R7 R7PAUSE	// R7PAUSE = R7 (saves R7 into memory)
	LEA R0 CONTMSG	// 
	PUTS		// Output the prompt to continue
	GETC		// Wait for user response to prompt
	LD R7 R7PAUSE	// R7 = R7PAUSE (restores R7 from memory)
	LD R0 R0PAUSE	// R0 = R0PAUSE (restores R0 from memory)
	RET
	
R0PAUSE .blkw #1	// Allocates space for saving R0 in PAUSE
R7PAUSE .blkw #1	// Allocates space for saving R7 in PAUSE
CONTMSG	.stringz "----- Press [SPACE] for the next test -----\n"

// SUBROUTINE FOR HALTING THE PROCESSOR (DO NOT ALTER)
//----------------------------------------------------------
STOP	LEA R0 END	// 
	PUTS		// Output "END OF TESTS" message
	AND R0 R0 #0	// 
	LD R1 STATUS	// Load address of system status register
	STR R0 R1 #0	// Halt the processor
	
STATUS	.fill xFFFE
END	.stringz "====== END OF TESTS ======\n"

	.end
