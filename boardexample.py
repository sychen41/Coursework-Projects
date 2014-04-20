#We import functions we will use to generate problems
from ourmath2 import generatesMultiplesProblems
from ourmath2 import generatesEqualitiesProblems
from ourmath2 import generatesFractionsProblems

#functions not implemented yet::::::
#from ourmath import generatesFractorsProblems
#from ourmath import generatesEqualitiesProblems

#We import the Problem class
from problem import Problem

class BoardExample():

	#it will call generatesMultiplesproblems, which returns a Problem object
	#we need to say the size of the board and the difficult level (1, 2, or 3)
	problem_x = generatesMultiplesProblems(27, 1)

	#answers = problem_x.right_answers + problem_x.wrong_answers
	#print(answers)

	#the Problem object has the following attributes
	#size of the board, like 42 (6x7)
	print(problem_x.board_size)

	#returns the string question (operation) you need to print on the screen
	#for example, you can print sth like print("Find Multiples of ", problem_x.question)
	print(problem_x.question)

	#return quantity of right/wrong answers, it varies deppending on difficult
	#use it to handle how many and where you are going to put the right and the wrong answers inside your board
	print(problem_x.quant_right)
	print(problem_x.quant_wrong)

	#array with right answers (size=quant_right)
	print(problem_x.right_answers)

	#array with wrong answers (size=quant_right)
	print(problem_x.wrong_answers)




	problem_x = generatesMultiplesProblems(27, 2)

	#answers = problem_x.right_answers + problem_x.wrong_answers
	#print(answers)

	#the Problem object has the following attributes
	#size of the board, like 42 (6x7)
	print(problem_x.board_size)

	#returns the string question (operation) you need to print on the screen
	#for example, you can print sth like print("Find Multiples of ", problem_x.question)
	print(problem_x.question)

	#return quantity of right/wrong answers, it varies deppending on difficult
	#use it to handle how many and where you are going to put the right and the wrong answers inside your board
	print(problem_x.quant_right)
	print(problem_x.quant_wrong)

	#array with right answers (size=quant_right)
	print(problem_x.right_answers)

	#array with wrong answers (size=quant_right)
	print(problem_x.wrong_answers)

	problem_x = generatesMultiplesProblems(27, 3)

	#answers = problem_x.right_answers + problem_x.wrong_answers
	#print(answers)

	#the Problem object has the following attributes
	#size of the board, like 42 (6x7)
	print(problem_x.board_size)

	#returns the string question (operation) you need to print on the screen
	#for example, you can print sth like print("Find Multiples of ", problem_x.question)
	print(problem_x.question)

	#return quantity of right/wrong answers, it varies deppending on difficult
	#use it to handle how many and where you are going to put the right and the wrong answers inside your board
	print(problem_x.quant_right)
	print(problem_x.quant_wrong)

	#array with right answers (size=quant_right)
	print(problem_x.right_answers)

	#array with wrong answers (size=quant_right)
	print(problem_x.wrong_answers)

	problem_x = generatesFractionsProblems(27, 1)

	#answers = problem_x.right_answers + problem_x.wrong_answers
	#print(answers)

	#the Problem object has the following attributes
	#size of the board, like 42 (6x7)
	print(problem_x.board_size)

	#returns the string question (operation) you need to print on the screen
	#for example, you can print sth like print("Find Multiples of ", problem_x.question)
	print(problem_x.question)

	#return quantity of right/wrong answers, it varies deppending on difficult
	#use it to handle how many and where you are going to put the right and the wrong answers inside your board
	print(problem_x.quant_right)
	print(problem_x.quant_wrong)

	#array with right answers (size=quant_right)
	print(problem_x.right_answers)

	#array with wrong answers (size=quant_right)
	print(problem_x.wrong_answers)

	problem_x = generatesFractionsProblems(27, 2)

	#answers = problem_x.right_answers + problem_x.wrong_answers
	#print(answers)

	#the Problem object has the following attributes
	#size of the board, like 42 (6x7)
	print(problem_x.board_size)

	#returns the string question (operation) you need to print on the screen
	#for example, you can print sth like print("Find Multiples of ", problem_x.question)
	print(problem_x.question)

	#return quantity of right/wrong answers, it varies deppending on difficult
	#use it to handle how many and where you are going to put the right and the wrong answers inside your board
	print(problem_x.quant_right)
	print(problem_x.quant_wrong)

	#array with right answers (size=quant_right)
	print(problem_x.right_answers)

	#array with wrong answers (size=quant_right)
	print(problem_x.wrong_answers)

	problem_x = generatesFractionsProblems(27, 3)

	#answers = problem_x.right_answers + problem_x.wrong_answers
	#print(answers)

	#the Problem object has the following attributes
	#size of the board, like 42 (6x7)
	print(problem_x.board_size)

	#returns the string question (operation) you need to print on the screen
	#for example, you can print sth like print("Find Multiples of ", problem_x.question)
	print(problem_x.question)

	#return quantity of right/wrong answers, it varies deppending on difficult
	#use it to handle how many and where you are going to put the right and the wrong answers inside your board
	print(problem_x.quant_right)
	print(problem_x.quant_wrong)

	#array with right answers (size=quant_right)
	print(problem_x.right_answers)

	#array with wrong answers (size=quant_right)
	print(problem_x.wrong_answers)

	problem_x = generatesEqualitiesProblems(27, 1)

	#answers = problem_x.right_answers + problem_x.wrong_answers
	#print(answers)

	#the Problem object has the following attributes
	#size of the board, like 42 (6x7)
	print(problem_x.board_size)

	#returns the string question (operation) you need to print on the screen
	#for example, you can print sth like print("Find Multiples of ", problem_x.question)
	print(problem_x.question)

	#return quantity of right/wrong answers, it varies deppending on difficult
	#use it to handle how many and where you are going to put the right and the wrong answers inside your board
	print(problem_x.quant_right)
	print(problem_x.quant_wrong)

	#array with right answers (size=quant_right)
	print(problem_x.right_answers)

	#array with wrong answers (size=quant_right)
	print(problem_x.wrong_answers)

	problem_x = generatesEqualitiesProblems(27, 2)

	#answers = problem_x.right_answers + problem_x.wrong_answers
	#print(answers)

	#the Problem object has the following attributes
	#size of the board, like 42 (6x7)
	print(problem_x.board_size)

	#returns the string question (operation) you need to print on the screen
	#for example, you can print sth like print("Find Multiples of ", problem_x.question)
	print(problem_x.question)

	#return quantity of right/wrong answers, it varies deppending on difficult
	#use it to handle how many and where you are going to put the right and the wrong answers inside your board
	print(problem_x.quant_right)
	print(problem_x.quant_wrong)

	#array with right answers (size=quant_right)
	print(problem_x.right_answers)

	#array with wrong answers (size=quant_right)
	print(problem_x.wrong_answers)

	problem_x = generatesEqualitiesProblems(27, 3)

	#answers = problem_x.right_answers + problem_x.wrong_answers
	#print(answers)

	#the Problem object has the following attributes
	#size of the board, like 42 (6x7)
	print(problem_x.board_size)

	#returns the string question (operation) you need to print on the screen
	#for example, you can print sth like print("Find Multiples of ", problem_x.question)
	print(problem_x.question)

	#return quantity of right/wrong answers, it varies deppending on difficult
	#use it to handle how many and where you are going to put the right and the wrong answers inside your board
	print(problem_x.quant_right)
	print(problem_x.quant_wrong)

	#array with right answers (size=quant_right)
	print(problem_x.right_answers)

	#array with wrong answers (size=quant_right)
	print(problem_x.wrong_answers)



