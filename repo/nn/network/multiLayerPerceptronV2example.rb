require "nn/network/multiLayerPerceptronV2.rb"

inputValue = [1,0,1]
weightInputToMedium = [
    [0.1,0.2,0.3],
    [0.1,0.2,0.3],
    [0.1,0.2,0.3]
]
weightMediumToOutput = [
    [0.4,0.5,0.6],
    [0.4,0.5,0.6],
    [0.4,0.5,0.6]
]

thresholdMedium = [0.2,0.3,0.4]
thresholdOutput = [0.2,0.3,0.4]

mlp = MultiLayerPerceptronV2.new

""" 入力層を作成 """
input = mlp.makeNeuron(3)

""" 中間層を作成 """
medium = mlp.makeNeuron(3)
medium.each_with_index do |neuron, index|
    neuron.weight = weightInputToMedium[index]
    neuron.threshold = thresholdMedium[index]
end

""" 出力層を作成 """
output = mlp.makeNeuron(3)
output.each_with_index do |neuron, index|
    neuron.weight = weightMediumToOutput[index]
    neuron.threshold = thresholdOutput[index]
end
mlp.addLayer(1, input)
mlp.addLayer(2, medium)
mlp.addLayer(3, output)

mlp.dumpStateOfLayer()

""" 実行 """
mlp.run(inputValue)
