import spyral
import random
import math
import time
import pygame
from spyral import Animation, easing
from problem import Problem
from ourmath2 import generatesMultiplesProblems


WIDTH = 1200
HEIGHT = 800
BG_COLOR = (0,0,0)
WHITE = (255, 255, 255)
SIZE = (WIDTH, HEIGHT)
isface = "right"
forceFieldOn = False
forceFieldTime = 0
laserCount = 3
gamestate = "StartScreen"
gameStarted = False
enemyCollided = False
eNow = 0
timeStart = 0
BoardXcoord = [[0 for x in xrange(6)] for x in xrange(5)] # row = 5 ;col = 6
BoardYcoord = [[0 for x in xrange(6)] for x in xrange(5)]
BoardStatus = [[0 for x in xrange(6)] for x in xrange(5)]
rowNum = 4
colNum = 5
ProwNum = 0
PcolNum = 0
isplayerDead = False
isEnemyDead = False
CorrectAnswers = 0
Irow = 0 # iterator for recording BoardXcoord and BoardYcoord
Icol = 0
playerLives = 2
class font(spyral.Sprite):
    def __init__(self, scene, font, text):
        spyral.Sprite.__init__(self, scene)
        font = spyral.Font(font, 80)
        self.image = font.render(text,color=(100, 200, 100))
        self.x = 450
        self.y = 0
        self.moving = False
class Laser(spyral.Sprite):
    global isEnemyDead
    def __init__(self, scene):
        spyral.Sprite.__init__(self, scene)
        self.image = spyral.image.Image(filename = "images/misc/laser.png", size = None)
        self.moving = False
    def collide_meteor(self, Sprite):
        if self.collide_sprite(Sprite):
            Sprite.kill()
	    pygame.mixer.init()
	    asteroidExplode = pygame.mixer.Sound("sounds/explode.wav")
	    asteroidExplode.play()
    def collide_enemy(self, Sprite):
        global isEnemyDead
        if self.collide_sprite(Sprite):
            Sprite.kill()
        pygame.mixer.init()
        asteroidExplode = pygame.mixer.Sound("sounds/explode.wav")
        asteroidExplode.play()
        isEnemyDead = True
class Player(spyral.Sprite):
    def __init__(self, scene):
        spyral.Sprite.__init__(self, scene)
        global playerColor
        global isface
        global rowNum
        global colNum
        global BoardXcoord
        global BoardYcoord
        global ProwNum
        global PcolNum
        global isplayerDead
        playerColor = "red"
        isplayerDead = False
        print "new Player created!!!"
        if(playerColor == "red"):
            self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        elif(playerColor == "blue"):
            self.image = spyral.image.Image(filename = "images/entireScenes/hand_blue.png", size = None)
        self.anchor = 'center'
        self.moving = False
        left = "left"
        right="right"
        up = "up"
        down = "down"
        enter = "]"
        space = "space"
        spyral.event.register("input.keyboard.down."+left, self.move_left)
        spyral.event.register("input.keyboard.down."+right, self.move_right)
        spyral.event.register("input.keyboard.up."+left, self.stop_move)
        spyral.event.register("input.keyboard.up."+right, self.stop_move)
        spyral.event.register("input.keyboard.down."+up, self.move_up)
        spyral.event.register("input.keyboard.down."+down, self.move_down)
        spyral.event.register("input.keyboard.up."+up, self.stop_move)
        spyral.event.register("input.keyboard.up."+down, self.stop_move)
        spyral.event.register("input.keyboard.up."+enter, self.stop_move)
        spyral.event.register("input.mouse.left.click", self.askquest)
        spyral.event.register("director.update", self.update)
    def move_left(self):
        global isface
        isface = "left"
        self.moving = 'left'
        if(forceFieldOn == False):
            self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
        else:
            self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeftForceField.png", size = None)

    def move_right(self):
        global isface
        isface = "right"
        self.moving = 'right'
        if(forceFieldOn == False):
            self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        else:
            self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRightForceField.png", size = None)
    def move_up(self):
        if(isface == "right" and forceFieldOn == False):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        elif(isface == "left" and forceFieldOn == False):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
        elif(isface == "right" and forceFieldOn == True):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRightForceField.png", size = None)
        elif(isface == "left" and forceFieldOn == True):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeftForceField.png", size = None)
        self.moving = 'up'
    def move_down(self):
        if(isface == "right" and forceFieldOn == False):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        elif(isface == "left" and forceFieldOn == False):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
        elif(isface == "right" and forceFieldOn == True):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRightForceField.png", size = None)
        elif(isface == "left" and forceFieldOn == True):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeftForceField.png", size = None)
        self.moving = 'down'
    def place_piece(self):
        self.moving = 'place_piece'
    def stop_move(self):
        self.moving = False
    def _reset(self):
        self.y = HEIGHT/2
    def askquest(self):
        print "askquest"
    def collide_BlackHolde(self, Sprite):
        if self.collide_sprite(Sprite):
            gamestate = "minigame"
        #pygame.mixer.init()
        #asteroidExplode = pygame.mixer.Sound("sounds/explode.wav")
        #asteroidExplode.play()
    def update(self, delta):
        global ProwNum
        global PcolNum
        if (BoardStatus[ProwNum][PcolNum] == -1 and isface == "right"):
            if (PcolNum != 5):
                    PcolNum-=1
            else:
                    ProwNum+=1
                    PcolNum=0  
        if (BoardStatus[ProwNum][PcolNum] == -1 and isface == "left"):
            if (PcolNum != 5):
                    PcolNum+=1
            else:
                    ProwNum+=1
                    PcolNum=0 
        self.x = BoardXcoord[ProwNum][PcolNum]
        self.y = BoardYcoord[ProwNum][PcolNum]
        paddle_velocity = 500
        #print delta
        if self.moving == 'left':
            global ProwNum
	    global PcolNum
            #self.x -= paddle_velocity * delta
	    if (BoardStatus[ProwNum][PcolNum] != -1):
		if (PcolNum != 0):
                    PcolNum-=1
	    self.x = BoardXcoord[ProwNum][PcolNum]
            #self.y = BoardYcoord[ProwNum][PcolNum]
        elif self.moving == 'right':
            global ProwNum
	    global PcolNum
	    if (BoardStatus[ProwNum][PcolNum] != -1):
		if (PcolNum != 5):
                    PcolNum+=1
	    self.x = BoardXcoord[ProwNum][PcolNum]
        elif self.moving == 'up':
            global ProwNum
	    global PcolNum
	    if (BoardStatus[ProwNum][PcolNum] != -1):
	        if (ProwNum != -1):
                    ProwNum-=1
            self.y = BoardYcoord[ProwNum][PcolNum]
        elif self.moving == 'down':
            global ProwNum
	    global PcolNum
	    if (BoardStatus[ProwNum][PcolNum] != -1):
	        if (ProwNum != 4):
                    ProwNum+=1
            self.y = BoardYcoord[ProwNum][PcolNum]
        if (PcolNum == 6):
            PcolNum = 0
        if (ProwNum == 5):
            ProwNum = 0
        if (PcolNum == -1):
            PcolNum = 5
        if (ProwNum == -1):
            ProwNum == 5
        print ProwNum
        print PcolNum
class MathText(spyral.Sprite):
    def __init__(self, scene, index, answers, problem_question):
        spyral.Sprite.__init__(self, scene)
        origin_x = 145.5
        origin_y = 121
        row = index / 6
        col = index % 6
        w = WIDTH/8
        h = HEIGHT/7
        self.x = col*w + WIDTH/40 + origin_x
        self.y = row*h + HEIGHT/40 + origin_y
        font = spyral.Font(None, WIDTH/20)
        GOLDEN = (218,165,32)
        WHITE = (255, 255, 255)
        if index == 30:
            self.x = WIDTH*7/20
            self.y = HEIGHT/12
            self.image = font.render("Find Multiples of " + str(problem_question), GOLDEN)
        elif answers[index] == -1:
            #self.x -= WIDTH/70
            #self.y -= HEIGHT/35
            self.image = spyral.Image(size=(1, 1))
        else:
            self.image = font.render(str(answers[index]), WHITE)
        
        global BoardXcoord
        global BoardYcoord
        global Irow
        global Icol

        if (index < 30):
            BoardXcoord[Irow][Icol] = self.x
            BoardYcoord[Irow][Icol] = self.y
            if (Icol != 5):
                Icol+=1
            else:
                Icol = 0
                Irow +=1


class Battery(spyral.Sprite):
    def __init__(self, scene):
        spyral.Sprite.__init__(self, scene)
        self.image = spyral.image.Image(filename = "images/misc/BatteryLogo.png", size = None)
class spaceShipLife(spyral.Sprite):
    def __init__(self, scene):
        spyral.Sprite.__init__(self, scene)
        self.image = spyral.image.Image(filename = "images/spaceship/spaceShipLife.png", size = None)

class Asteroid(spyral.Sprite):
    def __init__(self, scene, index):
        spyral.Sprite.__init__(self, scene)
       
        origin_x = 145.5
        origin_y = 121
        row = index / 6
        col = index % 6
        w = WIDTH/8
        h = HEIGHT/7
        self.x = col*w + WIDTH/40 + origin_x
        self.y = row*h + HEIGHT/40 + origin_y
        self.x -= WIDTH/70
        self.y -= HEIGHT/35
        self.image = spyral.image.Image(filename = "images/misc/asteroid_small.png", size = None)

class Enemy(spyral.Sprite):
    def __init__(self, scene):
        super(Enemy, self).__init__(scene)
        self.image = spyral.image.Image(filename = "images/mainEnemyPurpleImages/PurpleEnemySprite.png", size = None)
        #spyral.event.register("pong_score", self._reset)
        spyral.event.register("director.update", self.update)
        self.anchor = 'center'

    def update(self):
	global enemyCollided
	global eNow  
	#print enemyCollided
	#print "enow - time",(eNow - time.time())
	if(eNow - time.time() < (1-3) and enemyCollided == True):
	    enemyCollided = False
        
        global timeStart
        global rowNum
        global colNum
        if (time.time() - timeStart > 0.5):
	    ranNum = random.randint(0, 3)
	    #print ranNum
            if (ranNum == 0):
                if (rowNum != 0):
                    if (BoardStatus[rowNum-1][colNum] != -1):
                        rowNum-=1
            elif (ranNum == 1):
                if (rowNum != 4):
                    if(BoardStatus[rowNum+1][colNum] != -1):
                        rowNum+=1
            elif (ranNum == 2):
                if (colNum != 0):
                    if(BoardStatus[rowNum][colNum-1] != -1):
                        colNum-=1
            else:
                if (colNum != 5):
                    if(BoardStatus[rowNum][colNum+1] != -1):
                        colNum+=1
            #if (BoardStatus[rowNum][colNum] != -1):
            self.x = BoardXcoord[rowNum][colNum]
            self.y = BoardYcoord[rowNum][colNum]
            timeStart = time.time()
            
    def collide_something(self, something):
	global enemyCollided
        if(self.collide_sprite(something) and enemyCollided == False):
	    enemyCollided = True
	    eNow = time.time()
	            
 
class Spaceship(spyral.Sprite):

    def __init__(self, scene):

		spyral.Sprite.__init__(self, scene)

		self.image = spyral.image.Image(filename = "images/spaceship/spaceshipRightmoving.png", size = None)

		self.x = 0

		self.y = HEIGHT/2

		self.moving = False

		spyral.event.register("director.update", self.update)



    def update(self, delta):

        if gamestate == "minigame":

            if self.x<=WIDTH -100:

                self.x +=5

        else:

            self.x = WIDTH + 100



class StoryText(spyral.Sprite):
    def __init__(self,scene, txt, y):
        spyral.Sprite.__init__(self, scene)

        font=spyral.font.Font("fonts/Starjedi.ttf",40,(255,255,0))
        text=txt
        self.image=font.render(text)

        self.anchor = "center"

        self.x = WIDTH/2
        self.y = y



class Arrow(spyral.Sprite):

	def __init__(self,scene):

		spyral.Sprite.__init__(self, scene)

		self.image = spyral.image.Image(filename = "images/misc/left_red_arrow.png", size = None)

		self.x = -300

		self.y = -300

		self.level = 1

		spyral.event.register("director.update", self.update)

		spyral.event.register("input.keyboard.down.left", self.pre_level)

		spyral.event.register("input.keyboard.up.left", self.stop)

		spyral.event.register("input.keyboard.down.right", self.next_level)

		spyral.event.register("input.keyboard.up.right", self.stop)

		spyral.event.register("input.keyboard.down.s", self.select_level)

		

	def select_level(self):

		if self.level <=4:

			gamestate = "fullLevels"

			print "fullLevels"

	def pre_level(self):

		if self.level >= 2:			

		    self.level -=1 

        print "next level"

	def next_level(self):

		if self.level <= 3:			

		    self.level +=1 

        print "next level"

	def stop(self):

		self.level = self.level

	def update(self):

		if self.level ==1 and gamestate == "Levelselect":

			self.x= 300

			self.y= 610

		elif self.level == 2 and gamestate == "Levelselect":

			self.x = 300

			self.y = 140

		elif self.level == 3 and gamestate == "Levelselect":

			self.image = spyral.image.Image(filename = "images/misc/left_red_arrow.png", size = None)

			self.x = 700

			self.y = 340

		elif self.level == 4 and gamestate == "Levelselect":

			self.image = spyral.image.Image(filename = "images/misc/right_red_arrow.png", size = None)

			self.x = 730

			self.y = 100

		else:

			self.x = WIDTH *2

			self.y = HEIGHT *2

class AnswerCorrect(spyral.Sprite):
    def __init__(self,scene):
        spyral.Sprite.__init__(self, scene)
        self.image = spyral.image.Image(filename = "images/feedback/correctSmaller.png", size = None)
        self.anchor = 'center'
class Question(spyral.Sprite):

    def __init__(self,scene):

        spyral.Sprite.__init__(self, scene)

        

        self.x=00

        self.y=150

        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))

        self.question1 = "Ronnie has 10 dollar, \n the price of an apple is 2 dollar,how many apples she can buy ?"
        text=(self.question1+"____")

        self.image=font.render(text)

       

        

        self.x=0

        self.y=150

        self.done ='0'

        self.turn = 0

        self.correct = '0'

        self.a = 0

        self.b = 0

        self.answer = self.a + self.b

        self.in_answer=0

        self.dig_answer=0
        self.answer = 5
        self.lock = False

        self.win = 'False'

        spyral.event.register ("input.mouse.down.left",self.down_left)

        spyral.event.register ("input.keyboard.down.number_0",self.K0)

        spyral.event.register ('input.keyboard.down.number_1',self.K1)

        spyral.event.register ('input.keyboard.down.number_2',self.K2)

        spyral.event.register ('input.keyboard.down.number_3',self.K3)

        spyral.event.register ('input.keyboard.down.number_4',self.K4)

        spyral.event.register ('input.keyboard.down.number_5',self.K5)

        spyral.event.register ('input.keyboard.down.number_6',self.K6)

        spyral.event.register ('input.keyboard.down.number_7',self.K7)

        spyral.event.register ('input.keyboard.down.number_8',self.K8)

        spyral.event.register ('input.keyboard.down.number_9',self.K9)

        spyral.event.register ('input.keyboard.down.return',self.check_answer)

    

        time.sleep(0.1)


    

    def down_left(self, pos,button):

        if self.win == 'False':

            if(gamestate == 'minigame' ):

                self.correct='0'

                print "turn 1 question"

                text=(self.question1+"____")

                #text=("Nyasia always takes the same route when she walks her dog. First, she walks 7 blocks to the park. Then she walks 9 blocks to the elementary school. Finally, she walks12 blocks to get back home. Nyasia walks her dog 2 times each day. How many blocks does Nyasia's dog walk each day?")



                font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))

                self.image=font.render(text)

                

                



        else:

            text=("CONGRATULATION!! " + self.win + "  WIN!!")

            font=spyral.font.Font("fonts/white.ttf",50,(0,255,255))

            self.image=font.render(text)



    def check_answer(self):
	time.sleep(0.1)
        if self.in_answer == self.answer and gamestate == "minigame" and self.lock:

            self.correct = '1'

            text=(self.question1 + str(self.in_answer) + " CORRECT!!!")

            font=spyral.font.Font("fonts/white.ttf",30,(0,255,0))

            self.image=spyral.image.Image(filename = "images/feedback/Correct.png", size = None)
            self.x = 400

            self.in_answer=0

        

        elif self.in_answer != self.answer and gamestate == "minigame" and self.lock:

            self.correct = '0'

            text=(self.question1 + str(self.in_answer) +  " INCORRECT!!!")

            font=spyral.font.Font("fonts/white.ttf",30,(255,0,0))

            self.image=spyral.image.Image(filename = "images/feedback/wrong.png", size = None)
            self.x = 400

            self.in_answer=0

            

                

    def K0(self):
        self.x = 0
        self.dig_answer = self.dig_answer+1

        self.in_answer = self.in_answer*10 + 0

        text=(self.question1 + str(self.in_answer))

        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))
        self.lock = True

        self.image=font.render(text)

    def K1(self):
        self.x = 0
        self.dig_answer = self.dig_answer+1

        self.in_answer = self.in_answer*10 + 1

        text=(self.question1 + str(self.in_answer))

        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))
        self.lock = True
        self.image=font.render(text)

    def K2(self):
        self.x = 0
        self.dig_answer = self.dig_answer+1

        self.in_answer = self.in_answer*10 + 2

        text=(self.question1 + str(self.in_answer))

        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))
        self.lock = True
        self.image=font.render(text)

    def K3(self):
        self.x = 0
        self.dig_answer = self.dig_answer+1

        self.in_answer = self.in_answer*10 + 3

        text=(self.question1 + str(self.in_answer))
        self.lock = True
        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))

        self.image=font.render(text)

    def K4(self):
        self.x = 0
        self.dig_answer = self.dig_answer+1

        self.in_answer = self.in_answer*10 + 4

        text=(self.question1 + str(self.in_answer))

        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))
        self.lock = True
        self.image=font.render(text)

    def K5(self):
        self.x = 0
        self.dig_answer = self.dig_answer+1

        self.in_answer = self.in_answer*10 + 5

        text=(self.question1 + str(self.in_answer))

        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))
        self.lock = True
        self.image=font.render(text)

    def K6(self):
        self.x = 0
        self.dig_answer = self.dig_answer+1

        self.in_answer = self.in_answer*10 + 6

        text=(self.question1 + str(self.in_answer))
        self.lock = True
        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))

        self.image=font.render(text)

    def K7(self):
        self.x = 0
        self.dig_answer = self.dig_answer+1

        self.in_answer = self.in_answer*10 + 7

        text=(self.question1 + str(self.in_answer))
        self.lock = True
        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))

        self.image=font.render(text)

    def K8(self):
        self.x = 0
        self.dig_answer = self.dig_answer+1

        self.in_answer = self.in_answer*10 + 8

        text=(self.question1 + str(self.in_answer))
        self.lock = True
        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))

        self.image=font.render(text)

    def K9(self):
        self.x = 0
        self.dig_answer = self.dig_answer+1

        self.in_answer = self.in_answer*10 + 9

        text=(self.question1 + str(self.in_answer))
        self.lock = True
        font=spyral.font.Font("fonts/white.ttf",30,(255,255,255))

        self.image=font.render(text)
		
class BlackHole(spyral.Sprite):
    def __init__(self,scene):
        spyral.Sprite.__init__(self, scene)
        self.image = spyral.image.Image(filename = "images/misc/nextLevelPortal.png", size = None)
        self.anchor = 'center'

class CaptainMath(spyral.Scene):
    def __init__(self, *args, **kwargs):
        global manager
        spyral.Scene.__init__(self, SIZE)
        self.background = spyral.Image("images/fullLevels/planet2_Board.png")
        global isface
        global timeStart
        global ProwNum
        global PcolNum
        timeStart = time.time()
        self.mX = 0 #mouse x coordinate
        self.mY = 0 #mouse y coordinate
        left = "left"
        right="right"
        up = "up"
        down = "down"
        enter = "]"
        space = "space"
        spyral.event.register("system.quit", spyral.director.pop)
        spyral.event.register("director.update", self.update)
        spyral.event.register("input.keyboard.down.q", spyral.director.pop)
        spyral.event.register("input.keyboard.down."+space, self.space_clicked)
        spyral.event.register("input.keyboard.up."+space, self.space_unclicked)
        spyral.event.register("input.keyboard.down.t", self.asorbAnswer)
        spyral.event.register("input.keyboard.down.f", self.forceFieldOn)
        spyral.event.register("input.mouse.down.left", self.down_left)
        spyral.event.register("input.keyboard.down.return", self.return_clicked)

        # build coordinate matrix so that a cell(a,b) of the board
        # has coordinate: (BoardXcoord[a][b], BoardYcoord[a][b])
        global BoardXcoord
        global BoardYcoord
        
    def down_left(self,pos,button):
        self.mX = pos[0]
        self.mY = pos[1]
        print pos, button
        global gamestate
        if(gamestate == "StartScreen" and pos[0] >= 500 and pos[0] <= 700 and pos[1] >=340 and pos[1] <= 450 ):
			#gamestate = "Levelselect"
            #print "gamestate = Levelselect"
            gamestate = "story"
            print "gamestate = story"

            text_array = ["Captain Mathematica,", "comes from a distant", "galaxy where he is", "tasked with protecting", "children everywhere", "from evil Aliens and", "the evil Admiral", "No-HomeWork.", "Help Captain Mathematica", "to save the universe.", "You are the only hope!"]
            y = 950
            self.text_objects = []
            for i in text_array:
                self.storytext_x = StoryText(self, i, y)
                self.text_objects.append(self.storytext_x)
                y += 50

            #self.text_animations = []
            delta_iteration = 50
            for n in self.text_objects:
                self.animation_y = Animation('y', easing.Linear(n.y, -600-delta_iteration), 18.0)
                n.animate(self.animation_y)
                delta_iteration -= 50

        elif(gamestate == "story"):
            for i in self.text_objects:
                i.kill()
            gamestate = "Levelselect"
            print "gamestate = Levelselect"
            self.arrow = Arrow(self)

    def return_clicked(self):
		global gamestate
		if(gamestate == "Levelselect" and self.arrow.level <=4):
			self.question = Question(self)
                        print "gamestate = minigame"
                        self.arrow.level = 5 
			self.spaceship = Spaceship(self)
                        gamestate = "minigame"
			
			pygame.mixer.init()
			SSF = pygame.mixer.Sound("sounds/spaceShipFlying.wav")
			SSF.play()
			SST = pygame.mixer.Sound("sounds/spaceShipTraveling.wav")
			SST.play()
		elif(gamestate == "minigame" and self.question.correct == '1'):
			global SST
			global SSF
			SSF.stop()
			SST.stop()
			gamestate = "fullLevels"
			pygame.mixer.init()
			MainTheme = pygame.mixer.Sound("sounds/mainTheme.wav")
			MainTheme.play()
			self.question.x = WIDTH+1
			self.player = Player(self)
			#self.player.x = 155
			#self.player.y = 100
			self.Battery1 = Battery(self)
			self.Battery1.x = 0
			self.Battery1.y = 10
			self.Battery2 = Battery(self)
			self.Battery2.x = self.Battery1.width + 10
			self.Battery2.y = 10
			self.Battery3 = Battery(self)
			self.Battery3.x = self.Battery2.x + self.Battery2.width + 10
			self.Battery3.y = 10
			self.spaceShipLife1 = spaceShipLife(self)
			self.spaceShipLife1.x = 1200 - self.spaceShipLife1.width
			self.spaceShipLife1.y = 0
			self.spaceShipLife2 = spaceShipLife(self)
			self.spaceShipLife2.x = 1200 - (self.spaceShipLife1.width*2)
			self.spaceShipLife2.y = 0
			 #generate math problem (27 answers needed, because there are 3 asteroids)
			problem = generatesMultiplesProblems(27, 2)

			# The following block makes right and wrong answers and asteroids 
			# randomly displayed on the board. 
        
			# init array to contain indexes of right answers
			indexOfRightAnswers = [None]*int(problem.quant_right)
			# init array to contain random indexes of right answers and three asteroids
			len1 = int(problem.quant_right)+3 # length of randomIndexes
			randomIndexes = [None]*len1
			primeNums = [5, 7, 11, 13, 17, 19, 23, 29]
			# randomly pick one prime number from the primeNum
			randomNum = random.randint(0, 7)
			current = primeNums[randomNum] # some start value
			# fill the randomIndexes array with non-repeat numbers, range is 0-28 
			modulo = 29 # prime
			incrementor = 17180131327 # relative prime
			for i in range(0, len1):
				current = (current + incrementor) % modulo
				randomIndexes[i] = current
			# fill indexOfAsteroid with the last 3 numbers in randomIndexes
			indexOfAsteroid = [randomIndexes[len1-1],randomIndexes[len1-2],randomIndexes[len1-3]]
			# fill indexOfRightAnswers with rest numbers in randomIndexes
			for i in range(0, len(indexOfRightAnswers)):
				indexOfRightAnswers[i] = randomIndexes[i]
			# both array HAVE TO BE ASCENDING order
			indexOfRightAnswers.sort()
			indexOfAsteroid.sort()
			# generate the array: answers 
			# when index is in indexOfRightAnswers, assign the location with a RIGHT answer
			# when index is in indexOfAsteroid, assign the location with -1 
			# otherwise, assgin the location with a WRONG answer
			j=0
			k=0
			r=0
			w=0
			answers = [None]*30
			for i in range(0, 30):
				if i == indexOfRightAnswers[j]:
					answers[i] = problem.right_answers[r]
					#print " " + str(i) + " right" 
					if j < problem.quant_right-1:
						j+=1
					r+=1
				elif i == indexOfAsteroid[k]:
					answers[i] = -1 # -1 represent an asteroid
					if k < len(indexOfAsteroid)-1:
						k+=1
				else:
					answers[i] = problem.wrong_answers[w]
					if w < problem.quant_wrong-1:
						w+=1
    
			# display 31 things, 0 to 29 are indexes of answers, 30 is for the math problem title
			for x in range(0, 31):
				self.mathText = MathText(self, x, answers, problem.question)
        
            		# fill the global BoardStatus with answers: -1 for asteroids and -2 for right answers
            		global BoardStatus
            		a = 0
            		b = 0
			y = 0
            		for x in range(0, 30):
				if (x == indexOfRightAnswers[y]):
                			BoardStatus[a][b] = -2
					if (y < len(indexOfRightAnswers)-1):
						y+=1
                		else:
					BoardStatus[a][b] = answers[x]
                		b+=1
                		if (b==6):
                    			b=0
                    			a+=1
			# render asteroids
			self.asteroid1 = Asteroid(self, indexOfAsteroid[0])
			self.asteroid2 = Asteroid(self, indexOfAsteroid[1])
			self.asteroid3 = Asteroid(self, indexOfAsteroid[2])
			self.enemy1 = Enemy(self)
    def space_clicked(self):
        global isface
        global laserCount
        
        if gamestate == "fullLevels":
			
			if(laserCount == 0):
				pygame.mixer.init()
				noAmmo = pygame.mixer.Sound("sounds/emptyGun.wav")
				noAmmo.play()
				return
			self.Laser = Laser(self)
			pygame.mixer.init()
			sounda = pygame.mixer.Sound("sounds/lasershot.wav")
			sounda.play()
       
    

			if(isface == "right" and forceFieldOn == False and gamestate == "fullLevels"):
				if(playerLives == 2):
					self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigRight.png", size = None)
					self.Laser.x = self.player.x+20
					self.Laser.y = self.player.y-90
				elif(playerLives == 1):
					self.player2.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigRight.png", size = None)
					self.Laser.x = self.player2.x+20
					self.Laser.y = self.player2.y-90
				elif(playerLives == 0):
					self.player3.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigRight.png", size = None)
					self.Laser.x = self.player3.x+20
					self.Laser.y = self.player3.y-90
				isface = "right"
				self.Laser.collide_meteor(self.asteroid1)
				self.Laser.collide_meteor(self.asteroid2)
				self.Laser.collide_meteor(self.asteroid3)
				self.Laser.collide_enemy(self.enemy1)
			elif(isface == "left" and forceFieldOn == False and gamestate == "fullLevels"):
				isface = "left"
				if(playerLives == 2):
					self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigLeft.png", size = None)
					self.Laser.x = self.player.x-300
					self.Laser.y = self.player.y-90
				elif(playerLives == 1):
					self.player2.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigLeft.png", size = None)
					self.Laser.x = self.player2.x-300
					self.Laser.y = self.player2.y-90
				elif(playerLives == 0):
					self.player3.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigLeft.png", size = None)
					self.Laser.x = self.player3.x-300
					self.Laser.y = self.player3.y-90
				self.Laser.collide_meteor(self.asteroid1)
				self.Laser.collide_meteor(self.asteroid2)
				self.Laser.collide_meteor(self.asteroid3)
				self.Laser.collide_meteor(self.enemy1)
			elif(isface == "left" and forceFieldOn == True and gamestate == "fullLevels"):
				isface = "left"
				if(playerLives == 2):
					self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigLeftForceField.png", size = None)
					self.Laser.x = self.player.x-300
					self.Laser.y = self.player.y-90
				elif(playerLives == 1):
					self.player2.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigLeftForceField.png", size = None)
					self.Laser.x = self.player2.x-300
					self.Laser.y = self.player2.y-90
				elif(playerLives == 0):
					self.player3.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigLeftForceField.png", size = None)
					self.Laser.x = self.player3.x-300
					self.Laser.y = self.player3.y-90
				self.Laser.collide_meteor(self.asteroid1)
				self.Laser.collide_meteor(self.asteroid2)
				self.Laser.collide_meteor(self.asteroid3)
				self.Laser.collide_meteor(self.enemy1)
			elif(isface == "right" and forceFieldOn == True and gamestate == "fullLevels"):
				isface = "right"
				if(playerLives == 2):
					self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigRightForceField.png", size = None)
					self.Laser.x = self.player.x+20
					self.Laser.y = self.player.y-90
				elif(playerLives == 1):
					self.player2.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigRightForceField.png", size = None)
					self.Laser.x = self.player2.x+20
					self.Laser.y = self.player2.y-90
				elif(playerLives == 0):
					self.player3.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigRightForceField.png", size = None)
					self.Laser.x = self.player3.x+20
					self.Laser.y = self.player3.y-90
				self.Laser.collide_meteor(self.asteroid1)
				self.Laser.collide_meteor(self.asteroid2)
				self.Laser.collide_meteor(self.asteroid3)
				self.Laser.collide_meteor(self.enemy1)
			if(laserCount == 3 and gamestate == "fullLevels"):
				self.Battery3.kill()
			if(laserCount == 2 and gamestate == "fullLevels"):
				self.Battery2.kill()
			if(laserCount == 1 and gamestate == "fullLevels"):
				self.Battery1.kill()
			laserCount = laserCount - 1

    def asorbAnswer(self):
        print "hello yo boy"
        global ProwNum
        global PcolNum
        global BoardXcoord
        global BoardYcoord
        global playerLives
        global CorrectAnswers
        if(playerLives == 2):
          self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/playerEnergyRight.png", size = None)
        if(playerLives == 1):
          self.player2.image = spyral.image.Image(filename = "images/mainPlayerRedImages/playerEnergyRight.png", size = None)
        if(playerLives == 0):
          self.player3.image = spyral.image.Image(filename = "images/mainPlayerRedImages/playerEnergyRight.png", size = None)
        pygame.mixer.init()
        FF = pygame.mixer.Sound("sounds/ohYeah.wav")
        FF.play()
        time.sleep(0.2)
        if(isface == "right"):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        else:
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
        if (BoardStatus[ProwNum][PcolNum] == -2):
          print "Answer Selected is CORRECT!!!"
          self.AnswerCorrect = AnswerCorrect(self)
          self.AnswerCorrect.x = BoardXcoord[ProwNum][PcolNum]
          self.AnswerCorrect.y = BoardYcoord[ProwNum][PcolNum]
          CorrectAnswers+=1
          if(CorrectAnswers == 8):
            print "All Answers have been found!!!"
            ranRowNum = random.randint(0, 4)
            ranColNum = random.randint(0, 5)
            self.BlackHole = BlackHole(self)
            while(BoardStatus[ranRowNum][ranColNum] == -2 or BoardStatus[ranRowNum][ranColNum] == -1):
                ranRowNum = random.randint(0, 4)
                ranColNum = random.randint(0, 5)
            self.BlackHole.x = BoardXcoord[ranRowNum][ranColNum]
            self.BlackHole.y = BoardYcoord[ranRowNum][ranColNum]
        else:
          self.AnswerCorrect = AnswerCorrect(self)
          self.AnswerCorrect.image = spyral.image.Image(filename = "images/feedback/tombstone.png", size = None)
          self.AnswerCorrect.x = BoardXcoord[ProwNum][PcolNum]
          self.AnswerCorrect.y = BoardYcoord[ProwNum][PcolNum]
          if(playerLives == 2):
            self.player.kill()
            self.spaceShipLife1.kill()
          elif(playerLives == 1):
            self.player2.kill()
            self.spaceShipLife2.kill()
          elif(playerLives == 0):
            self.player3.kill()
          pygame.mixer.init()
          deathScream = pygame.mixer.Sound("sounds/deathScream.wav")
          deathScream.play()
          asteroidExplode = pygame.mixer.Sound("sounds/explode.wav")
          asteroidExplode.play()
          isplayerDead = True
          if(playerLives == 2):
            self.player2 = Player(self)
            ProwNum = 0
            PcolNum = 0
            playerLives-= 1
          elif(playerLives == 1):
            self.player3 = Player(self)
            ProwNum = 0
            PcolNum = 0
            playerLives-= 1
    def forceFieldOn(self):
        print "holla for ya mama"
        global forceFieldOn
        global forceFieldTime
        forceFieldOn = True
        print "hey" ,isface
        pygame.mixer.init()
        forceFieldTime = time.time()
        FF = pygame.mixer.Sound("sounds/forceFieldOn.wav")
        FF.play()
        if(isface == "right"):
          if(playerLives == 2):
          	  self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRightForceField.png", size = None)
          elif(playerLives == 1):
          	  self.player2.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRightForceField.png", size = None)
          elif(playerLives == 0):
          	  self.player3.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRightForceField.png", size = None)
        else:
          if(playerLives == 2):
              self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeftForceField.png", size = None)
          if(playerLives == 1):
              self.player2.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeftForceField.png", size = None)
          if(playerLives == 0):
              self.player3.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeftForceField.png", size = None)
          
    def space_unclicked(self):
        global isface
        time.sleep(0.2)
        if gamestate == "fullLevels" :
			if(isface == "right"):
				self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
			else:
				self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
			self.Laser.kill()
			
			
    def update(self, delta):
        global forceFieldOn
        global forceFieldTime
        global gamestate
        global gameStarted
        global timePassed
        global rowNum 
        global colNum 
        global ProwNum
        global PcolNum
        global playerLives
        global isplayerDead
        global isEnemyDead
        if gamestate == "StartScreen":
			self.background = spyral.Image("images/entireScenes/Begin.png")
			if(gameStarted == False):
				pygame.mixer.init()
				SSTheme = pygame.mixer.Sound("sounds/startScreenTheme.wav")
				SSTheme.play()
				gameStarted = True
        elif gamestate == "Levelselect":
            self.background = spyral.Image("images/preMadeImages/PlanetMap.png")
        elif gamestate == "fullLevels":
			#self.player.collide_BlackHolde(self.BlackHole) #might break some shit
			self.background = spyral.Image("images/fullLevels/planet2_Board.png")
			if(forceFieldTime - time.time() < (5-10) and forceFieldOn == True):
				forceFieldOn = False
				pygame.mixer.init()
				FFFailure = pygame.mixer.Sound("sounds/forceFieldFail.wav")
				FFFailure.play()
				FFOff = pygame.mixer.Sound("sounds/forceFieldOff.wav")
				FFOff.play()
				if(isface == "right"):
					self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
				else:
					self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)

			
        elif gamestate == "minigame":
			global SSTheme
			SSTheme.stop()
			self.background = spyral.Image("images/Backgrounds/galaxybg.jpg")

        #story screen
        elif gamestate == "story":
            self.background = spyral.Image("images/Backgrounds/story_bg.jpg")

            if (self.text_objects[0].y <= -550):
                for i in self.text_objects:
                    i.kill()
                gamestate = "Levelselect"
                self.arrow = Arrow(self)
                print "gamestate = Levelselect"
        global isEnemyDead
        if(rowNum == ProwNum and colNum == PcolNum and isplayerDead == False and forceFieldOn == False and isEnemyDead == False):
            if(playerLives == 2):
                self.player.kill()
            elif(playerLives == 1):
                self.player2.kill()
            elif(playerLives == 0):
                self.player3.kill()
            pygame.mixer.init()
            deathScream = pygame.mixer.Sound("sounds/deathScream.wav")
            deathScream.play()
            asteroidExplode = pygame.mixer.Sound("sounds/explode.wav")
            asteroidExplode.play()
            isplayerDead = True
            if(playerLives == 2):
                self.player2 = Player(self)
                ProwNum = 0
                PcolNum = 0
                playerLives-= 1
                self.spaceShipLife1.kill()
            elif(playerLives == 1):
                self.player3 = Player(self)
                ProwNum = 0
                PcolNum = 0
                playerLives-= 1
                self.spaceShipLife2.kill()
            
           

