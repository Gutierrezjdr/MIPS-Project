## by Jessica Gutierrez


.data
frameBuffer: .space 0x80000 # 512 wide X 256 high pixels
m: .word 100
n: .word 50

.text
lw $s6 ,m
lw $s7 ,n

#la $s6,m	# s6 <- m
#la $s7,n	# s7 <- n




la $s0, frameBuffer	#s0<-0x80000


li $s3,0x00020000	#s3 <- 512 x 256
li $s4,0x00000200	#s4 <-512 in Hex
li $s5,0x00000100	#s5 <-256 in Hex <- also half of width




li $s2,0x003338FF 	#$s2 <-blue
li $s1,0x00ffff00	#$s1 <-yellow

 
sll $t0,$s3,2 #t0 <- 20000*4
add $t0,$t0,$s0#t0 <- t0+s0 <-0x80000 + (20000*4) Max of Bitmap


sll $s6,$s6,2 # s6<- m*4 for bytes
sll $s7,$s7,2 # s7<- n*4 for bytes
sll $s4,$s4,2 # s4<- width*4 for bytes
sll $s5,$s5,2 # s5<- length*4 for bytes

##YELLOW BACKGROUND
add $t9, $s1,$zero # t9<- yellow
add $t8,$s0,$zero # t8 <- 0x80000
loop: 	sw $t9, 0($t8) #t8<-yellow
	addi $t8,$t8,4 #t8 <- t8+4
	bne $t8,$t0,loop #if t8 is not equal to t0 then go to loop
	

		##HORIZONTAL Arm of Cross	
			
##ROWS
srl $t2,$s7,1 # t2<- n/2
srl $t4,$s5,1  # t4<- height/2
sub $t2,$t4,$t2 # t2<- 128 - (n/2) 

##COLUMNS
srl $t3,$s7,1 # t3<- n/2
add $t3, $s6,$t3 # t3<- m+(n/2)
srl $t4,$s4,1  # t4<- width/2
sub $t3,$t4,$t3 # t3<- 256 - (m+(n/2))

##Starting Address
add $t4,$s0,$t3 # 0x8000 + (256 - (m+(n/2)))


##Draw
add $t9, $s2,$zero # t9<- blue
add $t5,$s0,$t3 # t5<-0x8000 + (256 - (m+(n/2)))	
add $t8,$t2,$zero # t8<- 128 - (n/2)  counter
#sll $s4,$s4,2  #width/2  *2 = width

##Calculates starting point
rowSet: ##sw $t9, 0($t5) #t5<-yellow for testing
	add $t5,$t5,$s4 # t5<- t5+width Goes to next row
	add $t8,$t8,-4 # t8<- t8 - 1
	slt $t7,$t8,$zero # if t8 < 0 then $t7 = 1. Stop loop
	beq $t7,$zero,rowSet
	
##t5 now contains starting point for color

add $t9, $s2,$zero #t9<- blue
add $t8,$s7,$zero #t8<- n
add $t7,$s6,$s6 # t7<- 2m
add $t7,$t7,$s7 #t7<- 2m+n


#srl $t7,$t3,2 #set bach width for counter
colorCol: sw $t9, 0($t5) #t5<-blue
	  add $t5,$t5,4 #t5<= t5+4
	  add $t7,$t7,-4 #t7<-t7 - 1
	  slt $t6,$t7,$zero # if t7 < 0 then $t6 = 1. Stop loop
	  beq $t6,$zero,colorCol # if t6=0 go to colorCol
	  add $t7,$s6,$s6 # t7<-m+m
	  add $t7,$t7,$s7 #t7<- 2m+n
	  sub $t5,$t5,$t7 # t5<- t5-width width
	  sub $t5,$t5,4 #t5<-t5 +4 offset
	  
colorRow: ##Calculates starting point
	sw $t9, 0($t5) #t5<-yellow
	add $t5,$t5,$s4 #t5<- t5+width Goes to next row
	add $t8,$t8,-4 #t8<-t8 - 1
	slt $t6,$t8,$zero # if t8 < 0 then $t6 = 1. Stop loop
	beq $t6,$zero,colorCol # if t6=0 go to colorCol


		# VERTICAL ARM OF CROSS

##For reference
##sll $s6,$s6,2 # m*4 for bytes
##sll $s7,$s7,2 # n*4 for bytes
##sll $s4,$s4,2 # width*4 for bytes
##sll $s5,$s5,2 # length*4 for bytes


##ROWS
srl $t2,$s7,1 # t2<-n/2
srl $t4,$s4,1  #t4<- width/2
sub $t3,$t4,$t2 #t3<-256 - (n/2)

###COLLUMN
srl $t4,$s5,1  #t4<- height/2
add $t2, $s6,$t2 # t2<- m+(n/2)
sub $t2,$t4,$t2 #t2<-  128 - m+(n/2)



##Starting Address
add $t4,$s0,$t2 #t4<- 0x8000 + 128 - m+(n/2)


##Draw
add $t9, $s2,$zero #t9<- blue
add $t5,$s0,$t3 # t5<-0x8000 + (256 - (n/2))	
add $t8,$t2,$zero # t8<- 128 - m+(n/2)  counter
#sll $s4,$s4,2  #width/2  *2 = width
rowSetTwo: ##Calculates starting point
	#sw $t9, 0($t5) #t1<-yellow
	add $t5,$t5,$s4 #t5<- t5- width Goes to next row
	add $t8,$t8,-4 #t8<-  t8 - 1
	slt $t7,$t8,$zero # if t8 < 0 then $t7 = 1. Stop loop
	beq $t7,$zero,rowSetTwo
	
##t5 now contains starting point for color

add $t9, $s2,$zero # t9<-blue
add $t8,$s6,$s6 #t8<-2m
add $t8,$t8,$s7 #t8<-2m+n
#srl $t8,$s5,2  #t8<- 2m+n
add $t7,$zero,$s7 #t7<- n



#srl $t7,$t3,2 #set bach width for counter
colorColTwo: sw $t9, 0($t5) #t5<-blue
	  add $t5,$t5,4 # t5<- t5+4
	  add $t7,$t7,-4 #t7<-t7 - 1
	  slt $t6,$t7,$zero # if t7 < 0 then $t6 = 1. Stop loop
	  beq $t6,$zero,colorColTwo #if t6==0 Go to colorColTwo
	  add $t7,$zero,$s7 #t7<- n
	  sub $t5,$t5,$t7 #t5<- t5-width
	  sub $t5,$t5,4 #t5<- offset
	  
colorRowTwo: ##Calculates starting point
	sw $t9, 0($t5) #t5<-yellow
	add $t5,$t5,$s4 #t5<-t5+ width 
	add $t8,$t8,-4 #t8<-t8 - 1
	slt $t6,$t8,$zero # if t8 < 0 then $t6 = 1. Stop loop
	
	beq $t6,$zero,colorColTwo #if t6==0 Go to colorColTwo



	li $v0,10 # exit code	 
	
syscall
