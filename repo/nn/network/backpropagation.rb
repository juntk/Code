require "nn/network/multiLayerPerceptronV2.rb"

def errorSignalOutput(aY, aOut)
    return -(aY-aOut) * aOut * (1.00 - aOut)
end

def errorSignalMedium(aErrorSignalOutput, aWeight, aOut)
    amount = 0.0
    aErrorSignalOutput.each_with_index do |v, i|
        aWeight[i].each_with_index do |v2, i2|
            amount += v * aWeight[i][i2]
        end
    end
    return amount * aOut * (1.00 - aOut)
end

inputValue = [0,0,1]
teacherValue = [1.0,1.0,0]

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

weightInputToMedium.each_with_index do |a, ai|
    a.each_with_index do |b, bi|
        weightInputToMedium[ai][bi] = rand(0)/10
    end
end
weightMediumToOutput.each_with_index do |a, ai|
    a.each_with_index do |b, bi|
        weightMediumToOutput[ai][bi] = rand(0)/10
    end
end

thresholdMedium = [0.2,0.3,0.4]
thresholdOutput = [0.3,0.2,0.1]

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

mlp.run(inputValue)
puts mlp.outputLayer[0].output
def learning(teacherValue, mlp, weightMediumToOutput)
    errorSignalOutput = []
    teacherValue.each_with_index do |v, i|
        errorSignalOutput << errorSignalOutput(teacherValue[i], mlp.outputLayer[i].output)
    end
    p errorSignalOutput
    errorSignalMedium = []
    mlp.mediumLayer.each_with_index do |v, i|
        errorSignalMedium << errorSignalMedium(errorSignalOutput, weightMediumToOutput, mlp.mediumLayer[i].output)
    end
    p errorSignalMedium

    mlp.mediumLayer.each_with_index do |neuron, index|
        neuron.weight.each_with_index do |network, index2|
            mlp.mediumLayer[index].weight[index2] += errorSignalMedium[index2]
        end
    end
    mlp.outputLayer.each_with_index do |neuron, index|
        neuron.weight.each_with_index do |network, index2|
            tmp = -0.1 * (-1.0*(teacherValue[index]-mlp.outputLayer[index].output)*mlp.outputLayer[index].output*(1.0-mlp.outputLayer[index].output)*mlp.mediumLayer[index2].output)
            mlp.outputLayer[index].weight[index2] += tmp
        end
    end
end
10000.times do |t|
    mlp.run(inputValue)
    learning(teacherValue, mlp,weightMediumToOutput)
    p mlp.mediumLayer[0].weight
    p mlp.mediumLayer[1].weight
    p mlp.mediumLayer[2].weight
mlp.outputLayer.each do |v|
    p v.output
end
mlp.mediumLayer.each do |v|
    p v.output
end
end

