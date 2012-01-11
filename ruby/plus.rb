


class Plus
    attr_accessor :s
    def initialize(s, l)
        @s_length = ((l-1)*12+1)
        @s = (s * (@s_length / s.length))
        @s += s[0..(@s_length % s.length)]
    end
end


s = 'abcd'
l = 3

p = Plus.new(s,l)
puts p.s
