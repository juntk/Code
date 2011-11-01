from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
from random import *
import math
import time
import struct
import alsaaudio as alsa
from pylab import *
import numpy as np
import threading, thread

threading.local = thread._local
x = threading.local()
vol = threading.local()

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

        glutKeyboardFunc(self.keyboard)
        glutIdleFunc(self.repaint)

        self.rotateX = 10
        self.rotateY = 10

        self.zoom = -5.0
        self.circle_margin = 10
        self.grow =[]
        glutMainLoop()

    def loop(self):
        global x,vol
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        glMatrixMode(GL_PROJECTION)
        glMatrixMode(GL_MODELVIEW)
        glLoadIdentity()
        gluPerspective(30.0, 320.0 / 240.0, 1.0, 10.0)
        gluLookAt(0.0, 0.0, self.zoom,
                  0.0, 0.0, 0.0,
                  0.0, 1.0, 0.0)

        glRotate(self.rotateX, 0.0, 1.0, 0.0)
        glRotate(self.rotateY, 1.0, 0.0, 0.0)

        glEnable(GL_DEPTH_TEST)


        try:
            if len(self.grow) < 180/self.circle_margin:
                vol_ = ((vol-2000)*-1)/ 10000.0
                if vol_ <= 0:
                    raise Error, 'error'
                print vol_
                #th1 = randint(0,180/self.circle_margin)
                th1 = randint(0,3)
                for i in x[10:25]:
                    if i > 30:
                        self.grow.append([0,0,vol_])
                for i in x[26:50]:
                    if i > 60:
                        self.grow.append([0,1,vol_])
                for i in x[51:75]:
                    if i > 80:
                        self.grow.append([0,2,vol_])
        except:
            pass
        radius = 0.5
        pai = 3.1415926
        for th1 in range(180 / self.circle_margin):
            th1_rad = th1  * self.circle_margin / 180.0 * pai
            y1 = radius * math.cos(th1_rad) 
            x1 = radius * math.sin(th1_rad)
            if th1 < len(self.grow):
                self.Circle(x1,0,y1,0,10,self.grow[th1])
                self.grow[th1][2] -= 0.005
                if self.grow[th1][2] <= 0:
                    self.grow.pop(th1)
            else:
                self.Circle(x1,0,y1,0,10,None)

        glDisable(GL_DEPTH_TEST)

        glutSwapBuffers()

    def Circle(self, radius, x, y, z, bold, grows):
        pai = 3.1415926
        glLineWidth(bold+0.1)
        grow = 0.0
        count = 0
        radius_tmp = radius
        ran =90.0
        grow_size = ran / 3
        for th1 in range(int(ran)):
            if th1 <30:
                glColor3d(1,0,0)
            elif th1 < 60:
                glColor3d(0,1,0)
            else:
                glColor3d(0,0,1)
            th2 = th1 + 1.0;
            th1_rad = th1 / (ran/2) * pai
            th2_rad = th2 / (ran/2) * pai

            x1 = radius_tmp * math.cos(th1_rad)
            z1 = radius_tmp * math.sin(th1_rad)
            x2 = radius_tmp * math.cos(th2_rad)
            z2 = radius_tmp * math.sin(th2_rad)
           
            if grows != None:
                if grows[1] == 0 and 0< th1 and th1 < grow_size:
                    if 0<th1 and th1<grow_size/2:
                        radius_tmp += grows[2]
                    else:
                        radius_tmp -= grows[2]
                elif grows[1] == 1 and grow_size < th1 and th1 < grow_size*2:
                    if grow_size<th1 and th1<grow_size+(grow_size/2):
                        radius_tmp += grows[2]
                    else:
                        radius_tmp -= grows[2]
                elif grows[1] == 2 and grow_size*2< th1 and th1 < grow_size*3:
                    if grow_size*2<th1 and th1<(grow_size*2)+(grow_size/2):
                        radius_tmp += grows[2]
                    else:
                        radius_tmp -= grows[2]
            glBegin(GL_LINES)
            glVertex3f(x1+x, y, z1+z)
            glVertex3f(x2+x, y, z2+z)
            glEnd()

    def keyboard(self, key, x_, y_):
        if key == "\033":
            glutLeaveGameMode()
            #exit()
        elif key == 'q':
            print key
        elif key == 'a':
            self.rotateX = self.rotateX - 2
        elif key == 'd':
            self.rotateX = self.rotateX + 2
        elif key == 'w':
            self.rotateY = self.rotateY + 2
        elif key == 's':
            self.rotateY = self.rotateY - 2
        elif key == 'u':
            self.zoom -= 0.2
        elif key == 'j':
            self.zoom += 0.2
        elif key == '1':
            self.grow[5] = [3,1,0.01]
            
        else:
            print key

    def repaint(self):
        glutPostRedisplay()

class WALSA(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        # ALSA
        self.dev = alsa.PCM(type=alsa.PCM_CAPTURE, mode=alsa.PCM_NORMAL)
        self.dev.setformat(alsa.PCM_FORMAT_FLOAT_LE)
        self.dev.setrate(8000)
        self.dev.setchannels(1)
        self.dev.setperiodsize(1024)
        plt.ion()
        freqList = np.fft.fftfreq(1024, d=1.0/8000)

    def run(self):
        global x, vol
        while True:
            l = []
            data = self.dev.read()
            d = struct.unpack("1024L",data[1])
            vol = 0
            for i in d:
                vol = vol + i
                l.append(i/1000000000)
            d_ft = np.fft.fft(l)
            #vol = (vol / 1000000000)-1000
            vol = ((vol / 1000000000)-3159)*-1
            x = [np.sqrt(c.real ** 2 + c.imag ** 2) for c in d_ft]
            #plt.plot(d_amp)
            #plt.axis([0, len(d_amp)/2, 0, 500])
            #plt.draw()
            #plt.clf()
    
if __name__ == "__main__":
    walsa = WALSA()
    walsa.start()
    opg = OPG()
