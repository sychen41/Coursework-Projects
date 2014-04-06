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
		#Defines the number of right answers as 10%
		quantity_right = round(board_size * 0.1,0)
		quantity_wrong = board_size - quantity_right

	if (difficulty==2):
		#Defines the number of right answers as 20%
		quantity_right = round(board_size * 0.2,0)
		quantity_wrong = board_size - quantity_right

	if (difficulty==3):
		#Defines the number of right answers as 30%
		quantity_right = round(board_size * 0.3,0)
		quantity_wrong = board_size - quantity_right

	#Generates a number X for the question: "Find multiples of X"
	#TODO: Difficulty plays a role in the range of possible values. Find a better way!
	question = random.randint(2,10*difficulty)

	#Instantiates an object "Problem"
	problem = Problem(board_size, question, quantity_right, quantity_wrong)

	#Generates N correct answers to the question
	for i in range (int(quantity_right)):
		random_number = random.randint(1,10)
		answer = question * random_number
		problem.right_answers.append(answer)

	#Generates M incorrect answers to the question
	#Generates wrong answer: w(x)= random_A*random_B
	#TODO: implement capability to change according to difficulty!
	for n in range (int(quantity_wrong)):
		its_ok = False
		x = 0
		while(its_ok == False):
			a = random.randint(1,10)
			b = random.randint(2,12)
			x = a*b
			if (x % question != 0):
				its_ok = True
				problem.wrong_answers.append(x)

	return problem


	#This method generates problems such: "Find factors of 30"
	#def generatesFactorsProblems(board_size, difficulty):
		

	#This method generates problems such: "Find operations equal to 64"
	#def generatesEqualitiesProblems(board_size, difficulty):
		#todo: instantiate a new "Problem" object and return it


