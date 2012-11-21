

class Point
    attr_accessor :x, :y, :value
    def initialize(aX, aY)
        @x = aX
        @y = aY
    end

    def setValue(sValue)
        @value = sValue
    end

    def equals(sPoint)
        if (sPoint.x == @x and sPoint.y == @y) then return true else false end
    end

    def dump
        print 'X: ', @x , ' Y: ', @y
        puts
    end

    def clear
        @x = 0
        @y = 0
    end
end
