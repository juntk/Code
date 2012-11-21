require "nn/basicNeuronModel/basicNeuronModel.rb"

"""
ニューロンのモデル　使用例
"""

n = BasicNeuronModel.new

# 入力
_in = [1,2,3,4,5,6,7,8,9,10]
# 重み
n.weight = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]
# しきい値
n.threshold = 12

print n.Neuron(_in)

