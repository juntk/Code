require "rubygems"
require "opengl"
require "glut"

def InterSectionEx(line1_ax, line1_ay, line1_bx, line1_by, line2_ax, line2_ay, line2_bx, line2_by)
	if (
		((line1_ax - line1_bx) * (line2_ay - line1_ay) + (line1_ay - line1_by) * (line1_ax - line2_ax)) * ((line1_ax - line1_bx) * (line2_by - line1_ay) + (line1_ay - line1_by) * (line1_ax - line2_bx)) < 0
		) then
		if (
			((line2_ax - line2_bx) * (line1_ay - line2_ay) + (line2_ay - line2_by) * (line2_ax - line1_ax)) * ((line2_ax - line2_bx) * (line1_by - line2_ay) + (line2_ay - line2_by) * (line2_ax - line1_bx)) < 0
			) then
			return true
		end
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
		# [[[1,5],[4,0]],[[0,0],[5,5]]]
		@ls.each { |line|
		# [[1,5],[4,0]]
			line.each {|point| 
				GL.Vertex2d(point[0]/10.0,point[1]/10.0)
			}
		}
		GL.End()

		GLUT.SwapBuffers()
	end
	
	def repaint()
		GLUT.PostRedisplay()
	end

	def initialize()
		@ls = [ [[1,5],[4,0]],[[0,0],[5,5]] ,[[3,3],[4,4]],[[0,0],[3,5]]]
		result = ""
		@ls.each { |line|
			@ls.each { |line2|
				result = InterSectionEx(line[0][0],line[0][1],line[1][0],line[1][1],line2[0][0],line2[0][1],line2[1][0],line2[1][1])
				puts line[0][0],line[0][1],line[1][0],line[1][1],line2[0][0],line2[0][1],line2[1][0],line2[1][1]
				puts result
			}
		}
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