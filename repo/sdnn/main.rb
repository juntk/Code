require 'sdnn/network.rb'

n = Network.new
inputLayer = [1,1]
middleLayer = n.makeMiddleLayer(inputLayer)
outputLayer = n.makeOutputLayer(middleLayer, 500)

count = 1
100.times do |t|
    t += 1
    teacher = 60
    inputLayer = [10,20]
    puts "[" + t.to_s + "] input x1,x2 = " + inputLayer.join(',')
    middleLayer = n.makeMiddleLayer(inputLayer)

     n.checkFireAtOutputLayer(outputLayer, middleLayer)
    result = n.getAmountValueOfOutput(outputLayer)
    outputLayer = n.fixWeight(teacher, result, 0.9999, outputLayer)
    result = n.getAmountValueOfOutput(outputLayer)
    puts "output Y = " + result.to_s
    if result == 60 then
        puts
        puts "complete! CountOfLearing:[" + count.to_s + "]"
        break
    end
    count += 1
end

puts
puts "check"
puts "input x1,x2 = 10,20"
    inputLayer = [10,20]
    middleLayer = n.makeMiddleLayer(inputLayer)

     n.checkFireAtOutputLayer(outputLayer, middleLayer)
    result = n.getAmountValueOfOutput(outputLayer)
    puts "output Y = " + result.to_s
