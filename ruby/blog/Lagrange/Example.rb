require "Lagrange_Gen.rb"

result = Lagrange_Gen.new([[1,10],[2,15],[10,55]])
y = result.generate(4)
print y