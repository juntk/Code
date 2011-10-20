from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
from random import *
import math
import time
import alsaaudio as alsa
import struct
from pylab import *
import numpy as np
import threading, thread

threading.local = thread._local
print alsa.cards()

window = (720,480)
title = 'title'
x = threading.local()
vol = threading.local()

class PGA:
    def __init__(self):
        glutInit()
        glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH)
        glutInitWindowSize(window[0],window[1])
        glutCreateWindow('OpenGL')
        glutDisplayFunc(self.loop)
        gluOrtho2D(0,window[0],0,window[1])
        glutKeyboardFunc(self.keyboard)
        glutIdleFunc(self.repaint)

        self.circle = []
        self.circle_width = 30


        glutMainLoop()
        # data
        

    def avg(l):
        result = 0
        for i in l:
            result = result + i
        result = result / (len(l))
        return result;

    def loop(self):
        global x, vol
        glClearColor(0,0,0,0)
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

        # check alsa and add circle
        try:
            if len(self.circle) < 8:
                tmp_color = []
                for i in x[10:25]:
                    if i > 50:
                        tmp_color = [25, 25, 255, 80]
                for i in x[26:50]:
                    if i > 50:
                        tmp_color = [25, 123, 125, 80]
                for i in x[50:75]:
                    if i > 50:
                        tmp_color = [25, 255, 255, 80]
                for i in x[76:100]:
                    if i > 50:
                        tmp_color = [25, 255, 25, 80]
                for i in x[101:125]:
                    if i > 50:
                        tmp_color = [123, 123, 25, 80]
                for i in x[126:150]:
                    if i > 60:
                        tmp_color = [255, 255, 25, 80]
                for i in x[151:175]:
                    if i > 70:
                        tmp_color = [255, 25, 25, 80]
                for i in x[176:200]:
                    if i > 75:
                        tmp_color = [255, 25, 255, 80]
                if len(tmp_color) == 4:
                    rad_max = vol
                    print vol
                    tmp_pos = [randint(0,window[0]),randint(0,window[1])]
                    tmp_radius = 0
                    tmp_dict = {'pos':tmp_pos,'color':tmp_color, 'radius':tmp_radius, 'rad_max':rad_max, 'speed':rad_max/80, 'bold':16}
                    self.circle.append(tmp_dict)
        except:
            pass
       
       # draw 
        count = 0
        for c in self.circle:
            c['radius'] = c['radius'] + c['speed']
            c['bold'] = c['bold'] - 1
            if c['radius'] >= c['rad_max'] or c['bold'] <= 0:
                self.circle.pop(count)
            else:
                glColor3f((c['color'][0]-25)/255.0, (c['color'][1]-25)/255.0, (c['color'][2]-25)/255.0)
                self.Circle(c['radius'], c['pos'][0], c['pos'][1], c['bold'])
            count = count + 1
        glFlush()
        glutSwapBuffers()


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
            exit()
        elif key == 'q':
            print key
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
            vol = (vol / 1000000000)-1000
            x = [np.sqrt(c.real ** 2 + c.imag ** 2) for c in d_ft]
            #plt.plot(d_amp)
            #plt.axis([0, len(d_amp)/2, 0, 500])
            #plt.draw()
            #plt.clf()
    
if __name__ == "__main__":
    walsa = WALSA()
    walsa.start()
    pga = PGA()
