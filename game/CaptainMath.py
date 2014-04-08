import spyral
import random
import math
import time
import pygame
from problem import Problem
from ourmath2 import generatesMultiplesProblems


WIDTH = 1200
HEIGHT = 800
BG_COLOR = (0,0,0)
WHITE = (255, 255, 255)
SIZE = (WIDTH, HEIGHT)
isface = "right"
class font(spyral.Sprite):
    def __init__(self, scene, font, text):
        spyral.Sprite.__init__(self, scene)
        font = spyral.Font(font, 80)
        self.image = font.render(text,color=(100, 200, 100))
        self.x = 450
        self.y = 0
        self.moving = False
class Laser(spyral.Sprite):
    def __init__(self, scene):
        spyral.Sprite.__init__(self, scene)
        self.image = spyral.image.Image(filename = "images/misc/laser.png", size = None)
        self.moving = False

class Player(spyral.Sprite):
    def __init__(self, scene):
        spyral.Sprite.__init__(self, scene)
        global playerColor
        global isface
        playerColor = "red"
        if(playerColor == "red"):
            self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        elif(playerColor == "blue"):
            self.image = spyral.image.Image(filename = "images/entireScenes/hand_blue.png", size = None)
        self.x = WIDTH/2
        self.y = HEIGHT - 200
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

    '''
    def asorbAnswer(self):
        print "hello yo boy"
        #self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/playerEnergyRight.png", size = None)
        self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigRight.png", size = None)
        time.sleep(1)
        if(isface == "right"):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        else:
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
    '''
    def move_left(self):
        global isface
        isface = "left"
        self.moving = 'left'
        self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
    def move_right(self):
        global isface
        isface = "right"
        self.moving = 'right'
        self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
    def move_up(self):
        if(isface == "right"):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        else:
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
        self.moving = 'up'
    def move_down(self):
        if(isface == "right"):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        else:
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
        self.moving = 'down'
    def place_piece(self):
        self.moving = 'place_piece'
    def stop_move(self):
        self.moving = False
    def _reset(self):
        self.y = HEIGHT/2
    def askquest(self):
        print "askquest"
    def update(self, delta):
        paddle_velocity = 500
        #print delta
        if self.moving == 'left':
            self.x -= paddle_velocity * delta
        elif self.moving == 'right':
            self.x += paddle_velocity * delta
        elif self.moving == 'up':
            self.y -= paddle_velocity * delta
        elif self.moving == 'down':
            self.y += paddle_velocity * delta

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
            self.x -= WIDTH/70
            self.y -= HEIGHT/35
            self.image = spyral.image.Image(filename = "images/misc/asteroid_small.png", size = None)
        else:
            self.image = font.render(str(answers[index]), WHITE)
        


class CaptainMath(spyral.Scene):
    def __init__(self, *args, **kwargs):
        global manager
        spyral.Scene.__init__(self, SIZE)
        self.background = spyral.Image("images/fullLevels/planet2_Board.png")
        self.player = Player(self)
        global isface
      #  self.Laser = Laser(self)

        left = "left"
        right="right"
        up = "up"
        down = "down"
        enter = "]"
        space = "space"
        self.font = font(self,"fonts/Bite_Bullet.ttf","glhf :)")
        spyral.event.register("system.quit", spyral.director.pop)
        spyral.event.register("director.update", self.update)
        spyral.event.register("input.keyboard.down.q", spyral.director.pop)
        spyral.event.register("input.keyboard.down."+space, self.space_clicked)
        spyral.event.register("input.keyboard.up."+space, self.space_unclicked)
        spyral.event.register("input.keyboard.down.t", self.asorbAnswer)
        spyral.event.register("input.mouse.down.left", self.mouse_down)

        # generate math problem (27 answers needed, because there are 3 asteroids)
        problem = generatesMultiplesProblems(27, 2)
#######################################################################
# The following block makes right and wrong answers and asteroids 
# randomly displayed on the board. 
# Documentation will be added later
        indexOfRightAnswers = [None]*int(problem.quant_right)
        len1 = int(problem.quant_right)+3 # length of randomIndexes
        randomIndexes = [None]*len1
        randomNum = random.randint(0, 7)
        print randomNum
        modulo = 29 # prime
        incrementor = 17180131327 # relative prime
        primeNums = [5, 7, 11, 13, 17, 19, 23, 29]
        current = primeNums[randomNum] # some start value
        for i in range(0, len1):
            current = (current + incrementor) % modulo
            randomIndexes[i] = current
        for i in range(0, len(indexOfRightAnswers)):
            indexOfRightAnswers[i] = randomIndexes[i]
        indexOfAsteroid = [randomIndexes[len1-1],randomIndexes[len1-2],randomIndexes[len1-3]]
        indexOfRightAnswers.sort()
        indexOfAsteroid.sort()
        j=0
        k=0
        r=0
        w=0
        answers = [None]*30
        for i in range(0, 30):
            if i == indexOfRightAnswers[j]:
                answers[i] = problem.right_answers[r]
                print " " + str(i) + " right" 
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
########################################################################      
        for x in range(0, 31):
            self.mathText = MathText(self, x, answers, problem.question)


    def mouse_down(self, pos, button):
        self.mX = pos[0]
        self.mY = pos[1]
        print pos, button

    def space_clicked(self):
        global isface
        self.Laser = Laser(self)
        pygame.mixer.init()
        sounda = pygame.mixer.Sound("sounds/lasershot.wav")
        sounda.play()


        if(isface == "right"):
          self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigRight.png", size = None)
          self.Laser.x = self.player.x+90
          self.Laser.y = self.player.y-25
          isface = "right"
        elif(isface == "left"):
          isface = "left"
          self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigLeft.png", size = None)
          self.Laser.x = self.player.x-250
          self.Laser.y = self.player.y-25


    def asorbAnswer(self):
        print "hello yo boy"
        self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/playerEnergyRight.png", size = None)
        time.sleep(0.2)
        if(isface == "right"):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        else:
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
    def space_unclicked(self):
        global isface
        time.sleep(0.2)
        if(isface == "right"):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
        else:
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        self.Laser.kill()
    def update(self, delta):
        global isface
        #print "hello world"
        #print "hey"
        #print isface
