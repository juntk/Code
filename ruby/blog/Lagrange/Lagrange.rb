class Lagrange
	def initialize(array=[])
		@array = array
	end
	def calc(x)
		y = 0.0
		@array.each_with_index do |i,count|
			a = 1.0
			b = 1.0
			@array.each_with_index do |j,count_|
				if count != count_ then
					a *= (x - j[0])
					b *= (i[0] - j[0])
				end
			end
			y += (i[1] * (a / b))
		end
		return y
	end
end