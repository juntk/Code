require "rubygems"
require "opengl"
require "glut"

def InterSectionEx(line1_ax, line1_ay, line1_bx, line1_by, line2_ax, line2_ay, line2_bx, line2_by)
	if ((
		((line1_ax - line1_bx) * (line2_ay - line1_ay) + (line1_ay - line1_by) * (line1_ax - line2_ax)) * ((line1_ax - line1_bx) * (line2_by - line1_ay) + (line1_ay - line1_by) * (line1_ax - line2_bx)) < 0
		) and (
			((line2_ax - line2_bx) * (line1_ay - line2_ay) + (line2_ay - line2_by) * (line2_ax - line1_ax)) * ((line2_ax - line2_bx) * (line1_by - line2_ay) + (line2_ay - line2_by) * (line2_ax - line1_bx)) < 0
			)) then
			return true
	else
		return false
	end
end
	
class Sample

	def display()
		GL.Clear(GL::GL_COLOR_BUFFER_BIT | GL::GL_DEPTH_BUFFER_BIT)
		GL.LoadIdentity()
		GL.LineWidth(4)
		GL.Begin(GL::GL_LINES)
			GL.Color3d(1,0,0)
			GL.Vertex2d(@ls[0]/10.0,@ls[1]/10.0)
			GL.Vertex2d(@ls[2]/10.0,@ls[3]/10.0)
			
			GL.Color3d(0,1,0)
			GL.Vertex2d(@ls[4]/10.0,@ls[5]/10.0)
			GL.Vertex2d(@ls[6]/10.0,@ls[7]/10.0)
		GL.End()

		GLUT.SwapBuffers()
	end
	
	def repaint()
		GLUT.PostRedisplay()
	end

	def initialize()
		@ls = [2,5,6,3,0,0,5,5]
		result = InterSectionEx(@ls[0],@ls[1],@ls[2],@ls[3],@ls[4],@ls[5],@ls[6],@ls[7])
		if result then
			puts result, "Intersection of Two lines"
		else
			puts result, "Non intersection of Two lines"
		end
		GLUT.InitWindowPosition(100,100)
		GLUT.InitWindowSize(320,240)
		GLUT.Init
		GLUT.InitDisplayMode(GLUT::GLUT_DOUBLE | GLUT::GLUT_RGB | GLUT::GLUT_DEPTH)
		GLUT.CreateWindow("ruby-opengl")
		GLUT.DisplayFunc(method(:display).to_proc())
		GLUT.IdleFunc(method(:repaint).to_proc())
		GL.ClearColor(1.0, 1.0, 1.0, 1.0)
	end
	
	def start()
		GLUT.MainLoop()
	end
	
end

Sample.new().start()
