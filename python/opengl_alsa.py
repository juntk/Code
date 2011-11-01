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

full = 0
if full == 1:
    window = (1280,800)
else:
    window = (720, 480)

title = 'title'
x = threading.local()
vol = threading.local()


class PGA:
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

        self.circle = []
        self.circle_width = 30
        self.circle_num = 10

        self.c_point = 80

        glutMainLoop()
        # data
        
    def timer(self,value):
        self.repaint()
        glutTimerFunc(1, self.timer, 0)

    def avg(l):
        result = 0
        for i in l:
            result = result + i
        result = result / (len(l))
        return result;

    def loop(self):
        global x, vol

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

        # check alsa and add circle
        try:
            if len(self.circle) < self.circle_num:
                tmp_color = []
                for i in x[176:250]:
                    if i > 100:
                        tmp_color = [255, 255, 25, 80]
                for i in x[151:175]:
                    if i > 100:
                        tmp_color = [255, 25, 25, 80]
                for i in x[126:150]:
                    if i > 100:
                        tmp_color = [255, 123, 25, 80]
                for i in x[91:125]:
                    if i > 100:
                        tmp_color = [123, 255, 25, 80]
                for i in x[71:90]:
                    if i > 150:
                        tmp_color = [255, 25, 255, 80]
                for i in x[51:70]:
                    if i > 200:
                        tmp_color = [25, 255, 25, 80]
                for i in x[26:50]:
                    if i > 300:
                        tmp_color = [25, 255, 255, 80]
                for i in x[10:25]:
                    if i > 400:
                        tmp_color = [25, 25, 255, 80]
                if len(tmp_color) == 4:
                    #mac
                    #rad_max = vol
                    rad_max = vol / 5
                    #rad_max = vol / 10
                    if 10 <= rad_max:
                        rad_max = rad_max * 0.5
                    #elif rad_max >= 400:
                    #    rad_max = rad_max * 0.3
                    tmp_pos = [randint(0,window[0]),randint(0,window[1])]
                    tmp_radius = 0
                    if rad_max/self.c_point <= 0:
                        speed = rad_max%self.c_point
                    else:
                        speed = rad_max / self.c_point 
                    if speed == 0:
                        speed = 1
                    speed = speed * 2.5
                    #tmp_dict = {'pos':tmp_pos,'color':tmp_color, 'radius':tmp_radius, 'rad_max':rad_max, 'speed':speed, 'bold':22}
                    self.circle.append({'pos':tmp_pos,'color':tmp_color, 'radius':tmp_radius, 'rad_max':rad_max, 'speed':speed, 'bold':22})
        except:
            pass
       
       # draw 
        count = 0
        for c in self.circle:
            c['radius'] = c['radius'] + c['speed']
            c['bold'] = c['bold'] - 1.5 
            # color
            color_speed = 10
            if c['color'][0] > 1:
                c['color'][0] = c['color'][0] - color_speed
            if c['color'][1] > 1:
                c['color'][1] = c['color'][1] - color_speed
            if c['color'][0] > 1:
                c['color'][2] = c['color'][2] - color_speed

            if c['radius'] >= c['rad_max'] or c['bold'] <= 0:
                self.circle.pop(count)
            else:
                glColor3f((c['color'][0])/255.0, (c['color'][1])/255.0, (c['color'][2])/255.0)
                self.Circle(c['radius'], c['pos'][0], c['pos'][1], c['bold'])
            count = count + 1
        glFlush()
        glutSwapBuffers()
        time.sleep(0.01)


    def Circle(self, radius, x, y, bold):
        pai = 3.1415926
        glLineWidth(bold+0.1)
        for th1 in range(180):
            th2 = th1 + 10.0;
            th1_rad = th1 / 90.0 * pai
            th2_rad = th2 / 90.0 * pai

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
    pga = PGA()
