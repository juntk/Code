require "Lagrange.rb"

class Lagrange_Gen < Lagrange
	def generate(x)
		# mathematical expression
		@a = []
		@a_str = []
		@array.each_with_index do |n,count|
			@b = 1.0
			@c = 1.0
			@b_str = ''
			@c_str = ''
			@array.each_with_index do |n_,count_|
				if count != count_ then
					@b_str += '('+x.to_s+' - '+n_[0].to_s+')*'
					@c_str += '('+n[0].to_s+' - '+n_[0].to_s+')*'
					@b *= (x - n_[0])
					@c *= (n[0] - n_[0])
				end
			end
			str = n[1].to_s + " * ((" + @b_str.chomp('*') + ') / (' + @c_str.chomp('*') +')) + '
			num = (n[1] * (@b / @c))
			@a_str << str
			@a << num
		end
		str = ''
		@a_str.each do |s|
			str += s
		end
		return str.chomp('+ ')
	end
end