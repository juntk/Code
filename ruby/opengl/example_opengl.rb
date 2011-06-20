require 'rubygems'
require 'opengl'
require 'glut'

class Sample

    def display()
        GL.Clear(GL::GL_COLOR_BUFFER_BIT | GL::GL_DEPTH_BUFFER_BIT)
        GL.MatrixMode(GL::GL_PROJECTION)
        GL.MatrixMode(GL::GL_MODELVIEW)
        GL.LoadIdentity()
        GLU.Perspective(30.0, 320.0 / 240.0, 1.0, 10.0)
        #GL.Translate(0.0, 0.0, 10.0)
        # オブジェクトの位置は固定
        # 視点をずらす
        GLU.LookAt(0.0, 0.0, @zoom,
                   0.0, 0.0, 0.0,
                   0.0, 1.0, 0.0)

        # Y軸を中心として回転(横回転)
        GL.Rotate(@rotateX, 0.0, 1.0, 0.0)
        # X軸を中心として回転(縦回転)
        GL.Rotate(@rotateY, 1.0, 0.0, 0.0)

        #隠面処理の有効範囲
        GL.Enable(GL::GL_DEPTH_TEST)

        # X-Z
        GL.Begin(GL::GL_QUADS)
        GL.Color3d(1.0,0.0,0.0)
        GL.Vertex3f(-0.5,0.0,-0.5)
        GL.Vertex3f(0.5,0.0,-0.5)
        GL.Vertex3f(0.5,0.0,0.5)
        GL.Vertex3f(-0.5,0.0,0.5)
        
        # Y-Z
        GL.Color3d(0.0,1.0,0.0)
        GL.Vertex3f(0.0,-0.5,-0.5)
        GL.Vertex3f(0.0,0.5,-0.5)
        GL.Vertex3f(0.0,0.5,0.5)
        GL.Vertex3f(0.0,-0.5,0.5)
        GL.End()

        #隠面処理おわり
        GL.Disable(GL::GL_DEPTH_TEST)

        # GL.Flush()は使わない
        GLUT.SwapBuffers()
    end
    
    def keyboard(key,x,y)
        spd = 5
        # keyboard: Esc
        if key == 27 then exit() end
        # keyboard: l
        if key == 108 then @rotateX -= spd end
        # keyboard: h
        if key == 104 then @rotateX += spd end
        # keyboard: j
        if key == 106 then @rotateY -= spd end
        # keyboard: k
        if key == 107 then @rotateY += spd end
        # keyboard: u
        if key == 117 then @zoom += 1.0 end
        # keyboard: n
        if key == 110 then @zoom -= 1.0 end
    end

    def repaint()
        # 再描画
        GLUT.PostRedisplay()
    end

    def initialize()

        @rotateX = 10
        @rotateY = 10

        @zoom = -5.0

        GLUT.InitWindowPosition(100,100)
        GLUT.InitWindowSize(320,240)
        GLUT.Init
        GLUT.InitDisplayMode(GLUT::GLUT_DOUBLE | GLUT::GLUT_RGB | GLUT::GLUT_DEPTH)
        GLUT.CreateWindow("ruby-opengl 01")

        GLUT.DisplayFunc(method(:display).to_proc())
        GLUT.KeyboardFunc(method(:keyboard).to_proc())

        # repaint
        GLUT.IdleFunc(method(:repaint).to_proc())

        GL.ClearColor(1.0, 1.0, 1.0, 1.0)
    end

    def start()
        GLUT.MainLoop()
    end
end

Sample.new().start()
