require "./nn/basicNeuronModel/basicNeuronModelV2.rb"


class Network
    def initialize
        @currentPath = './sdnn'
        @symbolPath = @currentPath + '/Symbol.txt'
    end
    def encodeNumToSymbol(aNum)
        """ 数字をシンボル（±1）の羅列に変換 """
        """ 3 => [1,1,-1,...]に変換する。戻り値は配列 """
        """ 数字以外の文字などにも対応できるようにハッシュで """
        symbolRelation = Hash.new
        open(@symbolPath) do |file|
            file.each do |line|
                tmp = line.split("=>")
                num = tmp[0]
                symbol = tmp[1].delete("\r\n")
                symbolList = symbol.split(' ').map {|s|s.to_i}
                symbolRelation[num] = symbolList
            end
        end
        if symbolRelation.key?(aNum.to_s) then
            return symbolRelation[aNum.to_s]
        else
            return false
        end
    end

    def modify(aSymbol, aModifier)
        """ 修飾パターンの並び替え """
        aModifier = permutation(aModifier)

        """ 修飾パターンが-1のとき0に不感化 """
        result = []
        aSymbol.each_with_index do |word, index|
            if aModifier[index] == -1 then
                result << 0
            else
                result << word
            end
        end
        return result
    end
    def permutation(aModifier)
        """ 巡回置換 """
        cyclicPermutation = [1,8,12,5,13,2,10,0,4,11,15,6,3,14,7,9]
        (cyclicPermutation.length-1).times do |i|
            tmp = aModifier[cyclicPermutation[i]]
            aModifier[cyclicPermutation[i]] = aModifier[cyclicPermutation[i+1]]
            aModifier[cyclicPermutation[i+1]] = tmp
        end
        return aModifier
    end
    def makeMiddleLayer(aInputLayer)
        """ 中間層の出力を作る。あくまでも出力値のみ。"""
        """ 中間層のニューロンはmakeOutputLayerで作っています。"""
        """ 中間層の素子群の数は、入力変数の数×入力変数の数-1 """

        """ 入力変数をシンボルに変換 """
        aInputLayer = aInputLayer.map {|num|encodeNumToSymbol(num)}

        """ 出力値を設定したニューロンを持つリスト """
        middleLayer = []
        """ 出力値のみ持つリスト """
        middleLayerOutputValue = []
        aInputLayer.each_with_index do |value,index|
            aInputLayer.each_with_index do |value2, index2|
                if index != index2 then
                    tvalue = modify(value, value2)
                    tvalue.each_with_index do |atv, atv_index|
                        n = BasicNeuronModel.new
                        n.output = atv
                        middleLayer << n
                    end
                    middleLayerOutputValue << tvalue
                end
            end
        end
        return middleLayer
    end
    def makeOutputLayer(aMiddleLayer, aNuronNum)
        """ 出力層を作る。 """

        """ ニューロンクラスのリスト """
        outputLayer = []
        aNuronNum.times do |t|
            outputLayer << makeOutputNeuron(aMiddleLayer)
        end
        return outputLayer
    end
    def makeOutputNeuron(aMiddleLayer)
        """ 出力層の単体のニューロンのみ作る """
        output = BasicNeuronModel.new
        output.threshold = rand(30) + 10
        aMiddleLayer.each_with_index do |value, index|
            """ 出力層と中間層の繋がりと重み関係を把握するため """
            aMiddleLayer[index].afterNeuron << output
            output.beforeNeuron << aMiddleLayer[index]
            output.weight << 1
        end
        return output
    end
    def checkFireAtOutputLayer(aOutputLayer, aMiddleLayer)
        result = []
        aOutputLayer.each_with_index do |value, index|
            result << checkFireAtOutputNeuron(value, aMiddleLayer)
        end
        return result;
    end
    def checkFireAtOutputNeuron(aNeuronAtOutput, aMiddleLayer)
        """ 単体のニューロンを渡してください。層ではないです。 """
        """ 中間層->出力層に入力を与え、実際に発火するかどうか検証 """

        """ 中間層の全ての素子を取得 """
        allMiddleLayer = []
        aMiddleLayer.each_with_index do |value, index|
            allMiddleLayer << value.output
        end
        """ 中間層の出力が出力層の入力になる """
        """ 入力値として与える """
        return aNeuronAtOutput.Neuron(allMiddleLayer)
    end
    def getAmountValueOfOutput(aOutputLayer)
        result = 0
        aOutputLayer.each do |v|
            result += v.output
        end
        return result
    end
    def fixWeight(aTeacher, aOutput, aLearningRate, aLayer)
        changeWeight = []
        if aTeacher > aOutput then
            """ 教師の方が大きければ-1を1に修正する"""
            before = -1
            after = 1
            if aOutput < 0 then
                """ example) ( -1*(-60) + 30 )/2 = 45""" 
                defFixCount = (-1*aOutput + aTeacher)/2
            else
                defFixCount = (aTeacher - aOutput)/2
            end
        elsif aTeacher < aOutput then
            """ 出力値の方が大きければ1を-1に修正する"""
            before = 1
            after = -1
            if aOutput < 0 then
                """ example) -30 - (-60) = 30 , 30/2 =15"""
                defFixCount = (aOutput - aTeacher)/2
            else
                """ example) 60 - 30 = 30 , 30/2 =15"""
                defFixCount = (aOutput - aTeacher)/2
            end
        else
            """ 教師と出力値が同じであれば修正の必要なし"""
            return aLayer
        end
        fixCount = 0
        begin
            index = rand(aLayer.length)
            neuron = aLayer[index]
            if neuron.output == before then
                neuron.weight.each_with_index do |weight, windex|
                    changeWeight = aLearningRate * after * weight
                    aLayer[index].weight[windex] += changeWeight
                end
                fixCount += 1
            end
        end while fixCount <= defFixCount
        return aLayer
    end

end

