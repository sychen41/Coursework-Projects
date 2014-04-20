from problem import Problem
import random

#This is a library of math functions we will use
#It contains methods(functions) to generate problems
	
#This method generates problems such: "Find multiples of 5"
#returns a Problem object
def generatesMultiplesProblems(board_size, difficulty):
	quantity_right = 0
	quantity_wrong = 0
	if (difficulty==1):
		#Defines the number of right answers as 40%
		quantity_right = round(board_size * 0.4,0)
		quantity_wrong = board_size - quantity_right

	elif (difficulty==2):
		#Defines the number of right answers as 30%
		quantity_right = round(board_size * 0.3,0)
		quantity_wrong = board_size - quantity_right

	elif (difficulty==3):
		#Defines the number of right answers as 20%
		quantity_right = round(board_size * 0.2,0)
		quantity_wrong = board_size - quantity_right

	#Generates a number X for the question: "Find multiples of X"
	if (difficulty==1):
		question = random.randint(4,9)

	elif (difficulty==2):
		question = random.randint(5,12)

	elif (difficulty==3):
		question = 10
		while (question==10):
			question = random.randint(6,13)

	#Instantiates an object "Problem"
	problem = Problem(board_size, question, quantity_right, quantity_wrong)

	#Generates N correct answers to the question
	for i in range (int(quantity_right)):
		if (difficulty==1):
			random_number = random.randint(1,3)
		elif (difficulty==2):
			random_number = random.randint(2,5)
		elif (difficulty==3):
			random_number = random.randint(3,7)

		answer = question * random_number
		problem.right_answers.append(answer)

	#Generates M incorrect answers to the question
	#Generates wrong answer: w(x)= random_A*random_B
	#TODO: implement capability to change according to difficulty!
	for n in range (int(quantity_wrong)):
		its_ok = False
		x = 0
		while(its_ok == False):
			if (difficulty==1):
				x = (question*random.randint(1,3))+random.randint(6,20)
			elif (difficulty==2):
				x = (question*random.randint(1,5))+random.randint(3,10)
			elif (difficulty==3):
				x = (question*random.randint(3,5))+random.randint(1,4)
			if (x % question != 0):
				its_ok = True
				problem.wrong_answers.append(x)

	return problem


#This method generates problems such: "Find fractions equivalent to 5/3"
def generatesFractionsProblems(board_size, difficulty):
	quantity_right = 0
	quantity_wrong = 0

	termA = 0
	termB = 0
	decimal_value = 0
	

	if (difficulty==1):
		#Defines the number of right answers as 40%
		quantity_right = round(board_size * 0.4,0)
		quantity_wrong = board_size - quantity_right

	elif (difficulty==2):
		#Defines the number of right answers as 30%
		quantity_right = round(board_size * 0.3,0)
		quantity_wrong = board_size - quantity_right

	elif (difficulty==3):
		#Defines the number of right answers as 20%
		quantity_right = round(board_size * 0.2,0)
		quantity_wrong = board_size - quantity_right

	#generates question like "equivalent to a/b"
	if (difficulty==1):
		termA= random.randint(2,6)
		termB= random.randint(2,7)
		decimal_value = termA/termB
		question = str(termA) + '/' + str(termB)

	elif (difficulty==2):
		termA= random.randint(4,10)
		termB= random.randint(4,10)
		decimal_value = termA/termB
		question = str(termA) + '/' + str(termB)

	elif (difficulty==3):
		termA= random.randint(6,10)
		termB= random.randint(4,10)
		decimal_value = termA/termB
		question = str(termA) + '/' + str(termB)

	#Instantiates an object "Problem"
	problem = Problem(board_size, question, quantity_right, quantity_wrong)

	#Generates N correct answers to the question
	for i in range (int(quantity_right)):
		equivalent_a = 0
		equivalent_b = 0

		if (difficulty==1):
			factor = random.randint(1,5)
			equivalent_a = termA*factor
			equivalent_b = termB*factor

		elif (difficulty==2):
			factor = random.randint(2,6)
			equivalent_a = termA*factor
			equivalent_b = termB*factor

		elif (difficulty==3):
			factor = random.randint(4,7)
			equivalent_a = termA*factor
			equivalent_b = termB*factor

		answer = str(equivalent_a) + '/' + str(equivalent_b)
		problem.right_answers.append(answer)

	#Generates M incorrect answers to the question
	for n in range (int(quantity_wrong)):
		its_ok = False
		x = 0
		answer = ''
		while(its_ok == False):
			if (difficulty==1):
				factor = random.randint(1,3)
				wrong_a = termA*factor+random.randint(1,10)
				factor = random.randint(1,3)
				wrong_b = termB*factor
				x = wrong_a/wrong_b
				answer = str(wrong_a) + '/' + str(wrong_b)

			elif (difficulty==2):
				factor = random.randint(1,3)
				wrong_a = termA*factor+random.randint(1,5)
				factor = random.randint(1,3)
				wrong_b = termB*factor
				x = wrong_a/wrong_b
				answer = str(wrong_a) + '/' + str(wrong_b)

			elif (difficulty==3):
				factor = random.randint(2,5)
				wrong_a = termA*factor+random.randint(1,4)
				factor = random.randint(2,5)
				wrong_b = termB*factor
				x = wrong_a/wrong_b
				answer = str(wrong_a) + '/' + str(wrong_b)

			if (x != decimal_value):
				its_ok = True
				problem.wrong_answers.append(answer)

	return problem

#This method generates problems such: "Find operations equal to 64"
def generatesEqualitiesProblems(board_size, difficulty):
	quantity_right = 0
	quantity_wrong = 0
	if (difficulty==1):
		#Defines the number of right answers as 40%
		quantity_right = round(board_size * 0.4,0)
		quantity_wrong = board_size - quantity_right

	elif (difficulty==2):
		#Defines the number of right answers as 30%
		quantity_right = round(board_size * 0.3,0)
		quantity_wrong = board_size - quantity_right

	elif (difficulty==3):
		#Defines the number of right answers as 20%
		quantity_right = round(board_size * 0.2,0)
		quantity_wrong = board_size - quantity_right

	#Generates a number X for the question: "Find equalities equal to X"
	if (difficulty==1):
		question = random.randint(10,20)

	elif (difficulty==2):
		question = random.randint(20,60)

	elif (difficulty==3):
		question = random.randint(40,80)

	#Instantiates an object "Problem"
	problem = Problem(board_size, question, quantity_right, quantity_wrong)
		
	#a+b=c
	#Generates N correct answers to the question
	for i in range (int(quantity_right)):
		if (difficulty==1):
			random_number = random.randint(5,15)
		elif (difficulty==2):
			random_number = random.randint(10,50)
		elif (difficulty==3):
			random_number = random.randint(20,70)

		#decide if + or - opperation:
		if(question-random_number>=0):
			b = question-random_number
			answer = str(random_number) + '+' + str(b)
		else:
			b = question-random_number
			answer = str(random_number) + str(b)

		problem.right_answers.append(answer)

	#Generates M incorrect answers to the question
	#Generates wrong answer: w(x)= random_A*random_B
	#TODO: implement capability to change according to difficulty!
	for n in range (int(quantity_wrong)):
		its_ok = False
		x = 0
			
		if (difficulty==1):
			random_number = random.randint(5,15)
			if(question-random_number>=0):
				#delta = random_number+random.randint(1,10)
				b = (question-random_number) + random.randint(5,15)
				answer = str(random_number) + '+' + str(b)
			else:
				#delta = random_number-random.randint(1,10)
				b = (question-random_number) - random.randint(5,10)
				answer = str(random_number) + str(b)

		elif (difficulty==2):
			random_number = random.randint(10,50)
			if(question-random_number>=0):
				#delta = random_number+random.randint(1,10)
				b = (question-random_number) + random.randint(1,10)
				answer = str(random_number) + '+' + str(b)
			else:
				#delta = random_number-random.randint(1,10)
				b = (question-random_number) - random.randint(1,5)
				answer = str(random_number) + str(b)

		elif (difficulty==3):
			random_number = random.randint(20,70)
			if(question-random_number>=0):
				#delta = random_number+random.randint(1,10)
				b = (question-random_number) + random.randint(1,5)
				answer = str(random_number) + '+' + str(b)
			else:
				#delta = random_number-random.randint(1,10)
				b = (question-random_number) - random.randint(1,5)
				answer = str(random_number) + str(b)
			
		problem.wrong_answers.append(answer)

	return problem


