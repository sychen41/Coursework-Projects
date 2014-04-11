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
forceFieldOn = False
forceFieldTime = 0
laserCount = 3
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
    def collide_meteor(self, Sprite):
        if self.collide_sprite(Sprite):
            print "hey you got me"
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
            #self.x -= WIDTH/70
            #self.y -= HEIGHT/35
            self.image = spyral.Image(size=(1, 1))
        else:
            self.image = font.render(str(answers[index]), WHITE)
class Battery(spyral.Sprite):
    def __init__(self, scene):
        spyral.Sprite.__init__(self, scene)
        self.image = spyral.image.Image(filename = "images/misc/BatteryLogo.png", size = None)

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
 

class CaptainMath(spyral.Scene):
    def __init__(self, *args, **kwargs):
        global manager
        spyral.Scene.__init__(self, SIZE)
        self.background = spyral.Image("images/fullLevels/planet2_Board.png")
        self.player = Player(self)
        self.Battery1 = Battery(self)
        self.Battery1.x = 0
        self.Battery1.y = 10
        self.Battery2 = Battery(self)
        self.Battery2.x = self.Battery1.width + 10
        self.Battery2.y = 10
        self.Battery3 = Battery(self)
        self.Battery3.x = self.Battery2.x + self.Battery2.width + 10
        self.Battery3.y = 10
        global isface
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
        spyral.event.register("input.mouse.down.left", self.mouse_down)
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
    
        # display 31 things, 0 to 29 are indexes of answers, 30 is for the math problem title
        for x in range(0, 31):
            self.mathText = MathText(self, x, answers, problem.question)
        
        # render asteroids
        self.asteroid1 = Asteroid(self, indexOfAsteroid[0])
        self.asteroid2 = Asteroid(self, indexOfAsteroid[1])
        self.asteroid3 = Asteroid(self, indexOfAsteroid[2])


    def mouse_down(self, pos, button):
        self.mX = pos[0]
        self.mY = pos[1]
        print pos, button

    def space_clicked(self):
        global isface
        global laserCount
        if(laserCount == 0):
          print "No Laser Left!!!!"
          pygame.mixer.init()
          noAmmo = pygame.mixer.Sound("sounds/emptyGun.wav")
          noAmmo.play()
          return
        self.Laser = Laser(self)
        pygame.mixer.init()
        sounda = pygame.mixer.Sound("sounds/lasershot.wav")
        sounda.play()
       
    

        if(isface == "right" and forceFieldOn == False):
          self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigRight.png", size = None)
          self.Laser.x = self.player.x+90
          self.Laser.y = self.player.y-25
          isface = "right"
        elif(isface == "left" and forceFieldOn == False):
          isface = "left"
          self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigLeft.png", size = None)
          self.Laser.x = self.player.x-250
          self.Laser.y = self.player.y-25
        elif(isface == "left" and forceFieldOn == True):
          isface = "left"
          self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigLeftForceField.png", size = None)
          self.Laser.x = self.player.x-250
          self.Laser.y = self.player.y-25
        elif(isface == "right" and forceFieldOn == True):
          isface = "right"
          self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingBigRightForceField.png", size = None)
          self.Laser.x = self.player.x+90
          self.Laser.y = self.player.y-25
        if(laserCount == 3):
          self.Battery3.kill()
        if(laserCount == 2):
          self.Battery2.kill()
        if(laserCount == 1):
          self.Battery1.kill()
        laserCount = laserCount - 1

    def asorbAnswer(self):
        print "hello yo boy"
        self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/playerEnergyRight.png", size = None)
        pygame.mixer.init()
        FF = pygame.mixer.Sound("sounds/ohYeah.wav")
        FF.play()
        time.sleep(0.2)
        if(isface == "right"):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        else:
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
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
          self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRightForceField.png", size = None)
        else:
          self.player.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeftForceField.png", size = None)
    def space_unclicked(self):
        global isface
        time.sleep(0.2)
        if(isface == "right"):
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserLeft.png", size = None)
        else:
          self.image = spyral.image.Image(filename = "images/mainPlayerRedImages/RedPlayerShootingLaserRight.png", size = None)
        self.Laser.kill()
    def update(self, delta):
        global forceFieldOn
        global forceFieldTime
        #print forceFieldTime
        #print time.time()
        print (forceFieldTime - time.time())
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
       
