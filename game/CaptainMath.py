import spyral
import random
import math

WIDTH = 1200
HEIGHT = 800
BG_COLOR = (0,0,0)
WHITE = (255, 255, 255)
SIZE = (WIDTH, HEIGHT)

class font(spyral.Sprite): 
    def __init__(self, scene, font, text):
        spyral.Sprite.__init__(self, scene)
        font = spyral.Font(font, 80)
        self.image = font.render(text,color=(100, 200, 100))
        self.x = 450
        self.y = 0
        self.moving = False

class Player(spyral.Sprite):
    def __init__(self, scene):
        spyral.Sprite.__init__(self, scene)
        global playerColor
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
        self.moving = 'left'
    def move_right(self):
        self.moving = 'right'
    def move_up(self):
        self.moving = 'up'
    def move_down(self):
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
        paddle_velocity = 250
        
        if self.moving == 'left':
            self.x -= paddle_velocity * delta
        elif self.moving == 'right':
            self.x += paddle_velocity * delta
        elif self.moving == 'up':
            self.y -= paddle_velocity * delta
        elif self.moving == 'down':
            self.y += paddle_velocity * delta

class CaptainMath(spyral.Scene):
    def __init__(self, *args, **kwargs):
        global manager
        spyral.Scene.__init__(self, SIZE)
        self.background = spyral.Image("images/entireScenes/Begin.png")
        self.player = Player(self)
        left = "left"
        right="right"
        up = "up"
        down = "down"
        enter = "]"
        self.font = font(self,"fonts/Bite_Bullet.ttf","glhf :)")
        spyral.event.register("system.quit", spyral.director.pop)
        spyral.event.register("director.update", self.update)
        spyral.event.register("input.keyboard.down.q", spyral.director.pop)

    def update(self, delta):
        print "hello world"
        print "hey"
