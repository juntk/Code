
class DrawPlus
	def initialize(str)
		@n = str.length
		@size = (@n - 1) * 12
		@data = (str * (@size / @n)) + str[0..(@size % @n)]
		@dp = 0			# data point
		@dp_e = @n - 1		# data point from end
		@sp = @n - 1		# start point
		@ep = @sp + @n - 1	# end point
	end
	def draw
		puts @data
		a
		b
		c
		d
		e
		b
		a
	end
	def a
		puts (" " * @sp) + @data[@dp..(@dp+@n - 1)]
		@dp += @n
	end
	def b
		@n.times do |l|
			puts (" " * @sp) + @data[@dp_e,1] + (" " * (@n - 2))+ @data[@dp,1]
			@dp += 1
			@dp_e -= 1
		end
	end
	def c
		puts @data[(@dp_e-@n+1)..@dp_e] + (" " * (@n - 2)) + @data[@dp..(@dp+@n-1)]
		@dp += @n
		@dp_e -= @n		
	end
	def d
		@n.times do |l|
			puts @data[@dp_e,1] + (" " * ((@n * 3) - 4)) + @data[@dp,1]
			@dp += 1
			@dp_e -= 1
		end
	end
	def e
		puts @data[(@dp_e-@n+1)..@dp_e].reverse + (" " * (@n - 2)) + @data[@dp..(@dp+@n-1)].reverse
		@dp += @n
		@dp_e -= @n		
	end
end

DrawPlus.new("doukaku").draw
