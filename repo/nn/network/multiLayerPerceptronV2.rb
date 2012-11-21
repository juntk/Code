require 'nn/node.rb'
require 'nn/basicNeuronModel/basicNeuronModelV2.rb'

class MultiLayerPerceptronV2
    attr_accessor :inputLayer, :mediumLayer, :outputLayer
    def initialize
        @inputLayer = []
        @mediumLayer = []
        @outputLayer = []
    end
    def addLayer(aLayerPosition, aNeuron)
        if aLayerPosition == 1 then
            @inputLayer += aNeuron
        elsif aLayerPosition == 2 then
            @mediumLayer += aNeuron
        elsif aLayerPosition == 3 then
            @outputLayer += aNeuron
        end
        updateConnectionOfLayer()
    end
    def updateConnectionOfLayer()
        @inputLayer.each do |neuron|
            neuron.afterNeuron = @mediumLayer
        end
        @mediumLayer.each do |neuron|
            neuron.afterNeuron = @outputLayer
            neuron.beforeNeuron = @inputLayer
        end
        @outputLayer.each do |neuron|
            neuron.beforeNeuron = @mediumLayer
        end
    end
    def makeNeuron(aNum)
        neuronArray = []
        aNum.times do |time|
            neuronArray << BasicNeuronModel.new
        end
        return neuronArray
    end
    def makeRelativeNeuron(aNeuronNum, aBeforeNeuronNum)
        relativeNeuronArray = []
        aBeforeNeuronNum.times do |t|
            neuronArray = []
            aNum.times do |time|
                neuronArray << BasicNeuronModel.new
            end
            relativeNeuronArray << neuronArray
        end
        return relativeNeuronArray
    end
    def run(aInputValue)
        """ 入力層の出力に引数（入力値）を設定 """
        @inputLayer.each_with_index do |neuron, index|
            neuron.output = aInputValue[index]
        end
        """ 入力層->中間層の実行 """
        @mediumLayer.each do |mediumNeuron|
            amountValue = 0.0
            @inputLayer.each_with_index do |inputNeuron, inputIndex|
               amountValue += inputNeuron.output * mediumNeuron.weight[inputIndex] 
            end
            mediumNeuron.output = sigmoid(amountValue)
            """
            if amountValue > mediumNeuron.threshold then
                mediumNeuron.output = 1
                puts 'fire!!!'
            end
            """
        end
        """ 中間層->出力層の実行 """
        @outputLayer.each do |outputNeuron|
            amountValue = 0.0
            @mediumLayer.each_with_index do |mediumNeuron, mediumIndex|
               amountValue += mediumNeuron.output * outputNeuron.weight[mediumIndex] 
            end
            outputNeuron.output = sigmoid(amountValue)
            """
            if amountValue > outputNeuron.threshold then
                outputNeuron.output = 1
                puts 'fire!!!'
            end
            """
        end
    end
    def sigmoid (aIn)
        a = 1.0 / (1.0 + Math.exp(-aIn))
        return a
    end
    def dumpStateOfLayer()
        puts "*** inputLayer ***"
        @inputLayer.each_with_index do |neuron, index|
            puts index.to_s + " => {"
            print "    beforeNeuron: "
            p neuron.beforeNeuron.size
            print "    afterNeuron: "
            p neuron.afterNeuron.size
            puts "}"
        end
        puts
        puts "*** mediumLayer ***"
        @mediumLayer.each_with_index do |neuron, index|
            puts index.to_s + " => {"
            print "    beforeNeuron: "
            p neuron.beforeNeuron.size
            print "    afterNeuron: "
            p neuron.afterNeuron.size
            puts "}"
        end
        puts
        puts "*** outputLayer ***"
        @outputLayer.each_with_index do |neuron, index|
            puts index.to_s + " => {"
            print " beforeNeuron: "
            p neuron.beforeNeuron.size
            print " afterNeuron: "
            p neuron.afterNeuron.size
            puts "}"
        end
    end
end
