require "ReinforcementLearning/point.rb"

class Basic
    WIDTH = 6
    HEIGHT = 4
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
        @countT = 0
        @countStudy = 0
        @countStudyCheck = 0
        @countRandom = 0
        @countRandomAmount = 0
        @averageCountRandom = 0
        @averageCountStudy = 0
        @countTry = 1

        1000000.times do |t|
            dump2DimWithState(@r, @s)
            s = @s
            canTo = canToMove(s, @action)

            if @countStudyCheck > 50 then
                nextPoint = moveRandom(s, @action, canTo)
                nextQIndex = nil
                nextQMax = nil
                @countStudyCheck = 0
                puts "***無限ループが発生したためランダム移動します***"
                sleep(0.5)
            else
                # 次の行動とその先のQ値を取得
                result = action(s, @action, canTo)
                nextPoint = result[0]
                nextQMax = result[1]
                nextQIndex = result[2]
            end

            # 手前から現在位置までのQ値の更新
            if nextQIndex != nil and nextQMax != 0 then
                @countStudyCheck += 1
                @countStudy += 1
                #puts "Q値が最大の方を選択しました。"
                @q[@sBefore.y][@sBefore.x][nextQIndex] = @q[@sBefore.y][@sBefore.x][nextQIndex] + 
                    ALPHA * (@r[@s.y][@s.x] + GAMMA * nextQMax - @q[@sBefore.y][@sBefore.x][nextQIndex])
            else
                #puts "Q値が存在しないためランダムで選択しました。"
                @countRandom += 1
                @countRandomAmount += 1
            end

            @sBefore = @s
            @s = nextPoint

            if @r[@s.y][@s.x] > 0 then
                @countTry += 1
                dump2DimWithState(@r, @s)
                dumpQDim(@q)
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
                #p @q
                @s = @start



                if @countRandom == 0 then
                print "ランダム試行数"
                puts @countRandomAmount
                print "学習回数"
                puts @countTry
                puts "👇(Q値が保存されている状態でスタート地点からやり直す。)"
                print "試行回数"
                puts @countT
                    puts "学習完了しています。"
                    @countStudy = 0
                    sleep(6)
                end
                @countRandom = 0
            end
                print 'ランダム試行数'
                puts @countRandomAmount
                print '学習回数'
                puts @countStudy
                puts '👇(Q値が保存されている状態でスタート地点からやり直す。)'
                print '試行回数'
                puts @countTry

            # sleep(0.1)
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

    def dumpQDim(aArray)
        aArray.size.times do |y|
            3.times do |m|
                y.size.times do |x|
                    if aArray[y][x] == nil then
                        print '   '
                        next
                    end
                        
                    if m == 0 then
                        print '   '
                        print aArray[y][x][3]
                        (3 - aArray[y][x][3].floor.to_s.size).times do |t|
                            print ' '
                        end
                        print '   '
                    elsif m == 1 then
                        print aArray[y][x][1]
                        (3 - aArray[y][x][1].floor.to_s.size).times do |t|
                            print ' '
                        end
                        print '   '
                        print aArray[y][x][0]
                        (3 - aArray[y][x][0].floor.to_s.size).times do |t|
                            print ' '
                        end
                    elsif m == 2 then
                        print '   '
                        print aArray[y][x][2]
                        (3 - aArray[y][x][2].floor.to_s.size).times do |t|
                            print ' '
                        end
                        print '   '
                    end
                    print '|'
                end
                puts
            end
                (9*7).times do |i|
                    print '-'
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
