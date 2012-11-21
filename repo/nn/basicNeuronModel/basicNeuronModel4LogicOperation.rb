require "nn/basicNeuronModel/basicNeuronModel.rb"

"""
ニューロンのモデルで論理演算
"""

n = BasicNeuronModel.new

# AND演算
"""
x_1 |   x_2 |   y
0   |   0   |   0
0   |   1   |   0
1   |   0   |   0
1   |   1   |   1
"""
puts "*AND演算"
n.weight = [1,1]
n.threshold = 1.5

_in = [0,0]
puts n.Neuron(_in)
_in = [0,1]
puts n.Neuron(_in)
_in = [1,0]
puts n.Neuron(_in)
_in = [1,1]
puts n.Neuron(_in)


# OR演算
"""
x_1 |   x_2 |   y
0   |   0   |   0
0   |   1   |   1
1   |   0   |   1
1   |   1   |   1
"""
puts
puts "*OR演算"
n.weight = [1,1]
n.threshold = 0.5

_in = [0,0]
puts n.Neuron(_in)
_in = [0,1]
puts n.Neuron(_in)
_in = [1,0]
puts n.Neuron(_in)
_in = [1,1]
puts n.Neuron(_in)
