require "ReinforcementLearning/point.rb"

class Basic
    WIDTH = 5
    HEIGHT = 2
    ALPHA = 0.8
    GAMMA = 0.5
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
            Array.new(4, 0)
        }
        } 
        # Remuneration-Value
        @r = Array.new(HEIGHT).map! {
            Array.new(WIDTH,0)
        } 
        @r[0][4] = 100
        # State
        @start = Point.new(0,1)
        @s = @start 

        1000000.times do |t|
            dump2DimWithState(@r, @s)
            s = @s
            canTo = canToMove(s, @action)

            # 次の行動とその先のQ値を取得
            result = action(s, @action, canTo)
            nextPoint = result[0]
            nextQMax = result[1]
            nextQIndex = result[2]

            # 手前から現在位置までのQ値の更新
            if nextQIndex != nil and nextQMax != 0 then
                puts "Q値が最大の方を選択しました。"
                @q[@sBefore.y][@sBefore.x][nextQIndex] = @q[@sBefore.y][@sBefore.x][nextQIndex] + 
                    ALPHA * (@r[@s.y][@s.x] + GAMMA * nextQMax - @q[@sBefore.y][@sBefore.x][nextQIndex])
            else
                puts "Q値が存在しないためランダムで選択しました。"
            end

            @sBefore = @s
            @s = nextPoint

            if @r[@s.y][@s.x] > 0 then
                dump2DimWithState(@r, @s)
                puts '*** ゴールに到達しました。 ***'
                # ゴールに到達後、手前に戻りQ値を更新
                # nextQIndex値を逆取得
                tmpAction = Point.new(@s.x - @sBefore.x, @s.y - @sBefore.y)
                @action.each_with_index do |a, i|
                    if tmpAction.x == a.x and tmpAction.y == a.y then
                        nextQIndex = i
                    end
                end

                @q[@sBefore.y][@sBefore.x][nextQIndex] = @q[@sBefore.y][@sBefore.x][nextQIndex] + 
                        ALPHA * (GAMMA *  @r[@s.y][@s.x] - @q[@sBefore.y][@sBefore.x][nextQIndex])
                p @q
                @s = @start
                sleep(1)
            end


            sleep(0.1)
        end
    end

    def canToMove(aPoint, aAction)
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
        
        return canTo
    end

    def action(aState, aAction, aCanTo)
        qMax = 0
        nextPoint = nil
        qIndex = nil
        # 移動できる場所すべて探索対象
        aCanTo.each do |canToIndex|
            # 周辺でQ値が最大となる場所を探す
            if @q[aState.y][aState.x][canToIndex] > qMax then
                qMax = @q[aState.y][aState.x][canToIndex]
                nextPoint = Point.new(aState.x + aAction[canToIndex].x,
                                      aState.y + aAction[canToIndex].y)
                qIndex = canToIndex
            end
        end
        
        # Q値が最大となる場所が見つからない（初期探索など）
        # ランダムで移動
        if nextPoint == nil then
            nextPoint = moveRandom(aState, aAction, aCanTo)
        end

        return [nextPoint, qMax, qIndex]
    end

    def moveRandom(aPoint, aAction, aCanTo)
        # select where to move
        actionIndex = aCanTo[rand(aCanTo.length)]
        actionPoint = aAction[actionIndex]
        # move
        return Point.new(aPoint.x + actionPoint.x, aPoint.y + actionPoint.y)
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
