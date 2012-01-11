require "Lagrange.rb"

class Lagrange_Gen < Lagrange
	def generate(x)
		# mathematical expression
		y_str = []
		y = 0.0
		@array.each_with_index do |i,count|
			a = 1.0
			b = 1.0
			a_str = ''
			b_str = ''
			@array.each_with_index do |j,count_|
				if count != count_ then
					a_str += '('+x.to_s+' - '+j[0].to_s+')*'
					b_str += '('+i[0].to_s+' - '+j[0].to_s+')*'
					a *= (x - j[0])
					b *= (i[0] - j[0])
				end
			end
			str = i[1].to_s + " * ((" + a_str.chomp('*') + ') / (' + b_str.chomp('*') +')) + '
			y += (i[1] * (a / b))
			y_str << str
		end
		str = ''
		y_str.each do |s|
			str += s
		end
		return str.chomp('+ ')
	end
end