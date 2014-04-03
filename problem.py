#This class creates the object "Problem", which contains the math attributes we will need to access from the Board
class Problem():

	#board size variable
	board_size = 0
	#question to be printed
	question = ""
	#quantity of right answers
	quant_right = 0
	#quantity of wrong answers
	quant_wrong = 0
	#array of right answers
	right_answers = []
	#array of wrong answers
	wrong_answers = []

	#class "constructor"
	def __init__(self, board_size, question, quant_right, quant_wrong):
		self.board_size = board_size
		self.question = question
		self.quant_right = quant_right
		self.quant_wrong = quant_wrong
