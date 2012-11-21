require "nn/base.rb"

"""
誤り訂正学習法（教師付き）
"""

class ErrorCorrectionLearningMethod < Base
    attr_accessor :learningRate, :weight, :threshold
    def initialize(aLearningRate=0.1, aWeight=0, aThreshold=1.5)
        @learningRate = aLearningRate 
        @weight = aWeight
        @threshold = aThreshold
    end
    def Neuron(aIn)
        """
        *Arguments
        aIn :   入力
        @weight:    重み（荷重）
        @threshold: しきい値
        """
        totalAmount = 0.0;
        if aIn.size > @weight.size then
            error("Invalid input value")
            return
        end
        aIn.each_with_index do |lIn, i| 
            totalAmount += lIn * @weight[i];
            #dump {
                p [:i=>i, :in=>lIn, :totalAmount=>totalAmount]
            # }
            if totalAmount > @threshold then
                return 1
            end
        end
        return 0
    end

    def ErrorCorrection(aOldWeight, aOut, aTeacher) 
        """
            (@teacher - out) = {
                @teacher == 1 & out == 0    のとき  1
                @teacher == 0 & out == 1    のとき  -1
                @teacher == out             のとき  0
            }
        """
        newWeight = []
        aOldWeight.each_with_index do |oldWeight, i|
            newWeight[i] = oldWeight + @learningRate * (aTeacher - aOut)
        end
        return newWeight;
    end
end

