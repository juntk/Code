# encoding: utf-8

from OpenGL.GL import *
from OpenGL.GLU import *
from OpenGL.GLUT import *

import sys,AppKit
import airport

class Sample:

    def display(self):
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        glMatrixMode(GL_PROJECTION)
        glMatrixMode(GL_MODELVIEW)
        glLoadIdentity()
        gluPerspective(30.0, 640.0 / 480.0, 1.0, 100.0)
        gluLookAt(0.0, 0.0, self.zoom,
                  self.moveX, self.moveY, 0.0,
                  0.0, 1.0, 0.0)

        # Y軸を中心として回転(横回転)
        glRotate(self.rotateX, 0.0, 1.0, 0.0)
        # X軸を中心として回転(縦回転)
        glRotate(self.rotateY, 1.0, 0.0, 0.0)

        #隠面処理の有効範囲
        glEnable(GL_DEPTH_TEST)

        # X-Z
        glBegin(GL_QUADS)


        glColor3d(1.0,0.0,0.0)
        glVertex3f(-0.5,0.0,-(int(self.strength[1][2]) / 100))
        glVertex3f(0.5,0.0,-(int(self.strength[1][2])/ 100))
        glVertex3f(0.5,0.0,-(int(self.strength[1][2])/ 100)+0.2)
        glVertex3f(-0.5,0.0,-(int(self.strength[1][2])/ 100)+0.2)
        
        # Y-Z
        glColor3d(0.0,1.0,0.0)
        glVertex3f(0.0,-0.5,-(int(self.strength[1][2])/ 100))
        glVertex3f(0.0,0.5,-(int(self.strength[1][2])/ 100))
        glVertex3f(0.0,0.5,-(int(self.strength[1][2])/ 100)+0.2)
        glVertex3f(0.0,-0.5,-(int(self.strength[1][2])/ 100)+0.2)
        glEnd()

        glCallList(self.object)

        #隠面処理おわり
        glDisable(GL_DEPTH_TEST)

        # glFlush()は使わない
        glutSwapBuffers()

    def make_sphere(self):
        self.object = glGenLists(1)
        glNewList(self.object, GL_COMPILE)
        avg = airport.strength_avg(self.strength)
        less = int(airport.strength_more(self.strength))

        print "avg: " + str(avg)
        print 'less:' + str(less)
        margin = 0.2
        for line in self.strength:
            print line
            if not line == 0:
                xyz = -1 * (int(self.strength[line][2]) / 1.0)
                print "xyz" + str(xyz)
                print "res: " + str(xyz-less+1.0)
                glPushMatrix()
                glColor3d(1.0, 0.0, 0.0)
                glTranslated(0.0, margin, 1 * (xyz-less))
                glutSolidSphere(0.2,10,5)
                glPopMatrix()
                print xyz + margin
                margin += 0.3
        glEndList()

    def keyboard(self,key,x,y):
        print 'zoom' + str(self.zoom)
        self.spd = 2.0
        # keyboard: Esc
        if key == "q" : exit()
        # keyboard: l
        if key == "l" : self.rotateX -= self.spd
        # keyboard: h
        if key == "h" : self.rotateX += self.spd
        # keyboard: j
        if key == "j" : self.rotateY -= self.spd
        # keyboard: k
        if key == "k" : self.rotateY += self.spd
        if key == "u" : self.zoom += 0.5
        if key == "n" : self.zoom -= 0.5
        if key == "m" : self.moveX += 0.2
        if key == "/" : self.moveX -= 0.2
        if key == "," : self.moveY += 0.2
        if key == "." : self.moveY -= 0.2

    def repaint(self):
        # 再描画
        glutPostRedisplay()

    def __init__(self):
        self.rotateX = 10.0
        self.rotateY = -10.0

        self.zoom =  -20.0
        self.moveX = 0.0
        self.moveY = 0.0

        self.strength = {}

        self.black = [1.0, 1.0, 1.0, 1.0]

    def start(self):
        glutMainLoop()

    def setStrength(self):
        self.strength = airport.scan()

if __name__ == "__main__":
    s = Sample()
    s.setStrength()

    glutInitWindowPosition(100,100)
    glutInitWindowSize(640,480)
    glutInit()
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
    glutCreateWindow("python-opengl 01")

    glutDisplayFunc(s.display)
    glutKeyboardFunc(s.keyboard)

    # repaint
    glutIdleFunc(s.repaint)

    glClearColor(1.0, 1.0, 1.0, 1.0)
    s.make_sphere()
    glutMainLoop()
