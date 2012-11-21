require "nn/basicNeuronModel/errorCorrectionLearningMethod.rb"

"""
誤り訂正学習法（教師付き）　論理演算
"""

def study(aN, aIn, aTeacher, aThreshold)
    weight = [0,0,0]
    out = -1 
    print "in:"
    p aIn
    print "teacher:"
    puts aTeacher
    until out == aTeacher
        # 基本的にはココでweight(重み)の訂正してる。
        # teacher(理想の答え)と一致したら重みを保存することで
        # 学習したことになる。
        aN.weight = weight
        aN.threshold = aThreshold
        out = aN.Neuron(aIn)
        weight = aN.ErrorCorrection(weight, out, aTeacher)
        print "weight:"
        p weight
    end
    print "out:"
    puts out
    puts
    return weight
end

def test(aN, aProblem, aThreshold)
    aProblem[:in].each_with_index do |_in, i|
        print "in:"
        p _in
        print "weight:"
        p aProblem[:memory][i]
        aN.weight = aProblem[:memory][i]
        aN.threshold = aThreshold
        out = aN.Neuron(_in)
        print "out:"
        puts out
        puts
    end
end

n = ErrorCorrectionLearningMethod.new
threshold = 1.5

# 結果が長いので
# true ...  AND演算 
# false ... OR演算
if false then

puts "*AND演算"
"""
x_1 |   x_2 |   x_3 |   y
0   |   0   |   0   |   0
1   |   0   |   0   |   0
1   |   0   |   1   |   0
1   |   1   |   0   |   0
1   |   1   |   1   |   1
"""
problem = {
        :in => [
            [0, 0, 0],
            [1, 0, 0],
            [1, 0, 1],
            [1, 1, 0],
            [1, 1, 1]
        ],
        :teacher => [0, 0, 0, 0, 1],
        :memory => []
}

else

puts "*OR演算"
"""
x_1 |   x_2 |   x_3 |   y
0   |   0   |   0   |   0
1   |   0   |   0   |   1
1   |   0   |   1   |   1
1   |   1   |   0   |   1
1   |   1   |   1   |   1
"""
problem = {
        :in => [
            [0, 0, 0],
            [1, 0, 0],
            [1, 0, 1],
            [1, 1, 0],
            [1, 1, 1]
        ],
        :teacher => [0, 1, 1, 1, 1],
        :memory => []
}

end

puts "学習はじめ"
problem[:in].each_with_index do |_in, i|
    problem[:memory][i] = study(n, _in, problem[:teacher][i], threshold)
end
puts "学習おわり"
puts

puts "学習結果"
print "memory:"
p problem[:memory]
puts

puts "テストはじめる"
puts "*test"
test(n, problem, threshold)
puts "テストおわり"
