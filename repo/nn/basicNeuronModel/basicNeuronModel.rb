require "nn/base.rb"

"""
ニューロンのモデル
"""

class BasicNeuronModel < Base
    attr_accessor :weight, :threshold, :output
    def initialize(aWeight=[],aThreshold=0)
        """
        aWeight:    重み（荷重）
        aThreshold: しきい値
        """
        @weight = aWeight 
        @threshold = aThreshold
        @output = 0
    end
    def Neuron(aIn)
        """
        *Arguments
        aIn :   入力

        *Return value
        Σ(入力×重み)-しきい値>0となる時に1を返す。
        Σ(入力×重み)-しきい値<0のとき0を返す。

        *Reference
        ニューロンのモデル
        http://www.geocities.co.jp/SiliconValley-Cupertino/3384/nn/NN.html#model
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
        end
        if totalAmount > @threshold then
            return 1
        else
            return 0
        end
    end
end

