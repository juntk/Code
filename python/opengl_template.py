from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
from random import *
import math
import time
import struct
from pylab import *
import numpy as np
import threading, thread

threading.local = thread._local

full = 0
if full == 1:
    window = (1280,800)
else:
    window = (720, 480)

title = 'title'

class OPG:
    def __init__(self):
        glutInit()
        glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH)
        glutInitWindowSize(window[0],window[1])
        if full == 1:
            glutGameModeString("1280x800:32@60")
            glutEnterGameMode()
        else:
            glutCreateWindow('OpenGL')
        glutDisplayFunc(self.loop)
        gluOrtho2D(0,window[0],0,window[1])
        glutKeyboardFunc(self.keyboard)
        glutIdleFunc(self.repaint)
        glutTimerFunc(1,self.timer,0)


        glutMainLoop()
        # data
        
    def timer(self,value):
        self.repaint()
        glutTimerFunc(1, self.timer, 0)

    def loop(self):
        #print vol
        glClearColor(0,0,0,0)
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

        glFlush()
        glutSwapBuffers()
        time.sleep(0.01)


    def Circle(self, radius, x, y, bold):
        pai = 3.1415926
        glLineWidth(bold+0.1)
        for th1 in range(360):
            th2 = th1 + 10.0;
            th1_rad = th1 / 180.0 * pai
            th2_rad = th2 / 180.0 * pai

            x1 = radius * math.cos(th1_rad)
            y1 = radius * math.sin(th1_rad)
            x2 = radius * math.cos(th2_rad)
            y2 = radius * math.sin(th2_rad)

            glBegin(GL_LINES)
            glVertex2f(x1+x, y1+y)
            glVertex2f(x2+x, y2+y)
            glEnd()
            
    def keyboard(self, key, x_, y_):
        if key == "\033":
            glutLeaveGameMode()
            #exit()
        elif key == 'q':
            print key
        else:
            print key

    def repaint(self):
        glutPostRedisplay()
    
if __name__ == "__main__":
    opg = OPG()
