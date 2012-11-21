require 'nn/node.rb'
require 'nn/basicNeuronModel/basicNeuronModel.rb'

require 'rubygems'
require 'graphviz'

class MultiLayerPerceptron
    attr_accessor :threshold
    attr_reader :mediumLayer, :outputLayer
    def initialize
        @threshold = 0
        @iuputLayer = []
        @mediumLayer = []
        @outputLayer = []
    end
    def setInputLayer(aInputArray)
        @inputLayer = aInputArray
    end
    def makeMediumLayer(aNumberOfLayers, aNumberOfInputs)
        weight = 0.15
        tmp = @threshold
        aNumberOfLayers.times do |i|
            @mediumLayer << BasicNeuronModel.new
            @threshold += 0.1
            @mediumLayer[@mediumLayer.size-1].threshold = @threshold
            weightArray = []
            aNumberOfInputs.times do |j|
                weightArray << j * 0.7
            end
            @mediumLayer[@mediumLayer.size-1].weight = weightArray
        end
        @threshold = tmp
    end
    def makeOutputLayer(aNumberOfLayers, aNumberOfInputs)
        weight = 0.2
        tmp = @threshold
        aNumberOfLayers.times do |i|
            @outputLayer << BasicNeuronModel.new
            @threshold += 0.1
            @outputLayer[@outputLayer.size-1].threshold = @threshold
            # Start 重みセット
            # 入力の数（aNumberOfInputs)だけ重みを持つ
            weightArray = []
            aNumberOfInputs.times do |j|
                weightArray << j * 0.4
            end
            @outputLayer[@outputLayer.size-1].weight = weightArray
            # End 重みセット
        end
        @threshold = tmp
    end
    def checkMediumLayer()
        @mediumLayer.size.times do |i|
            amountInputAndWeight = 0
            @inputLayer.size.times do |j|
                amountInputAndWeight += @mediumLayer[i].weight[j] * @inputLayer[j]
            end
            puts @mediumLayer[i].threshold
            if @mediumLayer[i].threshold - amountInputAndWeight > 0 then
                @mediumLayer[i].output = 0
            elsif @mediumLayer[i].threshold - amountInputAndWeight < 0 then
                @mediumLayer[i].output = 1
            end
            puts @mediumLayer[i].output
        end
    end
    def checkOutputLayer(aInputLayer)
        @outputLayer.size.times do |i|
            amountInputAndWeight = 0
            aInputLayer.size.times do |j|
                amountInputAndWeight += @outputLayer[i].weight[j] * aInputLayer[j]
            end
            puts @outputLayer[i].threshold
            if @outputLayer[i].threshold - amountInputAndWeight > 0 then
                @outputLayer[i].output = 0
            elsif @outputLayer[i].threshold - amountInputAndWeight < 0 then
                @outputLayer[i].output = 1
            end
            puts @outputLayer[i].output
        end
    end
end

threshold = 1
inputX = [1,0,1,0]

mlp = MultiLayerPerceptron.new
mlp.threshold = threshold
# 入力層をセット
mlp.setInputLayer(inputX)
# 中間層を作る
mlp.makeMediumLayer(inputX.size, inputX.size)
# 出力層を作る
mlp.makeOutputLayer(inputX.size, inputX.size)

mlp.checkMediumLayer()
mediumInput = []
mlp.mediumLayer.each do |v|
    mediumInput << v.output
end
mlp.checkOutputLayer(mediumInput)

g = GraphViz::new("G", :rankdir => "LR",:type=>"digraph",:use=>"dot")
inputX.each_with_index do |v,i|
    tmp = g.add_nodes(v.to_s+"(input:X_"+i.to_s+")")
        flug = 0
    mlp.mediumLayer.each_with_index do |v2,i2|
        if v2.output == 1 then
            puts "call"
            tmp2 = g.add_nodes(v2.threshold.to_s+"(medium)",:style=>'filled',:fillcolor=>"#cc9999")
        else
            tmp2 = g.add_nodes(v2.threshold.to_s+"(medium)")
        end
        if flug == 0 then
            g.add_edges(tmp,tmp2,:label=>v2.weight[i].to_s,:penwidth=>1+2*v2.weight[i])
        else
            g.add_edges(tmp,tmp2,:penwidth=>1+v2.weight[i]*2)
        end
        if i == 0 then
            mlp.outputLayer.each_with_index do |v3,i3|
                if v3.output == 1 then
                    tmp3 = g.add_nodes(v3.threshold.to_s+"(output)",:style=>'filled',:fillcolor=>"#cc9999")
                else
                    tmp3 = g.add_nodes(v3.threshold.to_s+"(output)")
                end
                if flug == 0 then
                    g.add_edges(tmp2,tmp3,:label=>v3.weight[i3].to_s,:penwidth=>1+2*v3.weight[i2])
                    tmp4 = g.add_nodes(v3.output.to_s+"(Y_"+i3.to_s+")")
                    g.add_edges(tmp3,tmp4,:style=>'dashed')
                else
                    g.add_edges(tmp2,tmp3,:penwidth=>1+2*v3.weight[i2])
                end
            end
        end
        flug += 1
    end
end
g.output(:png => "result.png")


