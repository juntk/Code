require 'nn/node.rb'
require 'nn/basicNeuronModel/basicNeuronModel.rb'

"""
３つのニューロンモデルを組み合わせることでXOR関数を実現
*参考
http://ipr20.cs.ehime-u.ac.jp/column/neural/chapter5.html#1st
"""

_in = [
    [0,0],
    [0,1],
    [1,0],
    [1,1]
]

bn1 = BasicNeuronModel.new([1.0,-1.0],0.5)
bn2 = BasicNeuronModel.new([-1.0,1.0],0.5)
bn3 = BasicNeuronModel.new([1.0,1.0],0.5)

_in.each_with_index do |x12, i|
    print "in:"
    p x12
    bn1Out = bn1.Neuron(x12)
    bn2Out = bn2.Neuron(x12)
    bn3Out = bn3.Neuron([bn1Out,bn2Out])
    print "out:"
    puts bn3Out
    puts
end
