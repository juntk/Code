
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

full = False
if full:
    window = (1280,800)
else:
    window = (720,480)
title = 'title'
x = threading.local()
vol = threading.local()

class PGA:
    def __init__(self):
        glutInit()
        glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH)
        glutInitWindowSize(window[0],window[1])
        if full:
            glutGameModeString("1280x800:32@60")
            glutEnterGameMode()
        else:
            glutCreateWindow('OpenGL')
        glutDisplayFunc(self.loop)
        gluOrtho2D(0,window[0],0,window[1])
        glutKeyboardFunc(self.keyboard)
        glutIdleFunc(self.repaint)

        self.circle = []
        self.bold = 48


        glutMainLoop()
        # data
        

    def avg(self,l):
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
                max_a = 0
                sum_a = 0
                max_b = 0
                sum_b = 0
                if self.avg(x[10:30])-5 > self.avg(x[31:100]):
                    for i in x[10:20]:
                        if max_a < i:
                            max_a = i
                            tmp_color = [25, 25, 255, 80]
                    for i in x[21:30]:
                        if max_a < i:
                            max_a = i
                            tmp_color = [25, 255, 255, 80]
                else:
                    for i in x[31:40]:
                        if max_b < i:
                            max_b = i
                            tmp_color = [25, 255, 25, 80]
                    for i in x[41:50]:
                        if max_b < i:
                            max_b = i
                            tmp_color = [255, 255, 25, 80]
                    for i in x[51:75]:
                        if max_b < i:
                            max_b = i
                            tmp_color = [255, 25, 25, 80]
                    for i in x[76:100]:
                        if max_b < i:
                            max_b = i
                            tmp_color = [255, 25, 255, 80]
                if len(tmp_color) == 4:
                    rad_max = (vol-1300)
                    tmp_pos = [randint(0,window[0]),randint(0,window[1])]
                    tmp_radius = 1.0
                    speed = 5
                    if rad_max < 9:
                       raise Error,"error" 
                    if rad_max >= 9 and rad_max <=15:
                        speed=1.0
                    if rad_max > 128:
                        rad_max = 128.0
                    if rad_max > 64:
                        speed = 6.0
                    bold_speed = 1.0 * self.bold / (rad_max/speed)
                    tmp_dict = {'pos':tmp_pos,'color':tmp_color, 'radius':tmp_radius, 'rad_max':rad_max, 'speed':speed*1, 'bold':self.bold, 'bold_speed':bold_speed}
                    self.circle.append(tmp_dict)
        except:
            pass
       
       # draw 
        count = 0
        for c in self.circle:
            c['radius'] = c['radius'] + c['speed']
            c['bold'] = c['bold']-c['bold_speed']
            if c['radius'] >= c['rad_max'] or c['bold'] <= 0:
                self.circle.pop(count)
            else:
                glColor3f((c['color'][0]-25)/255.0, (c['color'][1]-25)/255.0, (c['color'][2]-25)/255.0)
                self.Circle(c['radius'], c['pos'][0], c['pos'][1], c['bold'])
            count = count + 1
            self.repaint()
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
        elif key == 'q':
            print key

        else:
            print key

    def repaint(self):
        glutPostRedisplay()

class WALSA(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.setDaemon = True
        # ALSA
        self.dev = alsa.PCM(type=alsa.PCM_CAPTURE, mode=alsa.PCM_NORMAL)
        self.dev.setformat(alsa.PCM_FORMAT_FLOAT_LE)
        self.dev.setrate(8000)
        self.dev.setchannels(1)
        self.dev.setperiodsize(512)
        plt.ion()
        freqList = np.fft.fftfreq(512, d=1.0/8000)

    def run(self):
        global x, vol
        while True:
            l = []
            data = self.dev.read()
            d = struct.unpack("512L",data[1])
            vol = 0
            for i in d:
                vol = vol + i
                l.append(i/1000000000)
            d_ft = np.fft.fft(l)
            vol = (vol / 1000000000)
            x = [np.sqrt(c.real ** 2 + c.imag ** 2) for c in d_ft]
            #plt.plot(d_amp)
            #plt.axis([0, len(d_amp)/2, 0, 500])
            #plt.draw()
            #plt.clf()
    
if __name__ == "__main__":
    walsa = WALSA()
    walsa.start()
    pga = PGA()
