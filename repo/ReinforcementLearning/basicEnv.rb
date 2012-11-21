require "ReinforcementLearning/point.rb"

class Basic
    WIDTH = 5
    HEIGHT = 2
    def initialize
        @action = [
            Point.new(1,0),
            Point.new(0,1),
            Point.new(-1,0),
            Point.new(0,-1)
        ]
        # Q-Value
        @q = Array.new(HEIGHT).map! {
            Array.new(WIDTH).map! {
            Array.new(2, 0)
        }
        } 
        # Remuneration-Value
        @r = Array.new(HEIGHT).map! {
            Array.new(WIDTH,0)
        } 
        @r[0][4] = 10
        # State
        @s = Point.new(0,0)

        1000000.times do |t|
            move(@s, @action)
            dump2DimWithState(@r, @s)
            if @r[@s.y][@s.x] > 0 then
                puts 'goal!!'
                @s.clear
                sleep(1)
            end
            sleep(0.1)
        end
    end

    def move(aPoint, aAction)
        # CanTo
        # 0 :   right 
        # 1 :   down
        # 2 :   left
        # 3 :   up
        canTo = []
        if aPoint.x + 1 < WIDTH then
            canTo << 0 
        end
        if aPoint.y + 1 < HEIGHT then
            canTo << 1
        end
        if aPoint.x - 1 >= 0 then
            canTo << 2
        end
        if aPoint.y - 1 >= 0 then
            canTo << 3
        end

        # select where to move
        actionIndex = canTo[rand(canTo.length)]
        actionPoint = aAction[actionIndex]
        # move
        aPoint.x += actionPoint.x
        aPoint.y += actionPoint.y

        return aPoint
    end

    def dump2Dim(aArray)
        aArray.each do |y|
            y.each do |x|
                print "|"
                print x
            end
            puts
        end
    end

    def dump2DimWithState(aArray,aState)
        # print map and location(state)
        aArray.each_with_index do |y,yi|
            y.each_with_index do |x,xi|
                print "|"
                if aState.equals(Point.new(xi,yi)) then
                    print "*"
                else
                    print x
                end
            end
            puts
        end
    end
end

Basic.new
