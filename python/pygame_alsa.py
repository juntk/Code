import pygame
from pygame.locals import *
import random

window = (640,480)
title = 'title'

class PGA:
    def __init__(self):
        pygame.init()
        pygame.key.set_repeat(1,1)
        self.screen = pygame.display.set_mode(window, FULLSCREEN)
        pygame.display.set_caption(title)
        # data
        self.circle = []
        self.circle_width = 2

    def loop(self):
        while 1:
            self.screen.fill((0,0,0))
            count = 0
            for c in self.circle:
                c['radius'] = c['radius'] - 2
                if c['radius'] <= self.circle_width:
                    self.circle.pop(count)
                count = count + 1
            self.draw_circle()
            self.event()
            pygame.display.update()
            
    def event(self):
        for event in pygame.event.get():
            if event.type == QUIT:
                exit()
            if (event.type == KEYDOWN and event.key == K_ESCAPE):
                exit()
            if (event.type == KEYDOWN and event.key == K_SPACE):
                if len(self.circle) > 10:
                    retur
                tmp_pos = [random.randint(0,window[0]),random.randint(0,window[1])]
                tmp_color = [0, 0, 255, 80]
                tmp_radius = 200
                tmp_dict = {'pos':tmp_pos,'color':tmp_color, 'radius':tmp_radius}
                self.circle.append(tmp_dict)

    def draw_circle(self):
        for c in self.circle:
            pygame.draw.circle(self.screen, pygame.Color(c['color'][0],c['color'][1],c['color'][2],c['color'][3],), c['pos'], c['radius'], self.circle_width)

    
if __name__ == "__main__":
    pga = PGA()
    pga.loop()
