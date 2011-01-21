def foo(n)
	1.upto(n) do |num|
		print num
		if num % 5 == 0 then
			puts ''
		elsif num == n then
			return
		else
			print ','
		end
	end
end

foo(10)