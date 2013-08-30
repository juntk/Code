require 'ruby/pixiv/crawl/controller.rb'
require 'ruby/pixiv/crawl/pixiv.rb'

class Main
    def initialize()
        @handle = Controller.new()
        @pixiv = Pixiv.new()
        res = @pixiv.login("a","p")
    end
    def check(tag, p)
        res = @pixiv.get("http://www.pixiv.net/search.php?s_mode=s_tag&r18=1&word="+tag+"&p="+p.to_s)
        res = @pixiv.parse(res.body)
        res.each do |line|
            @handle.setRank(line[0],line[1],tag,line[3],line[4],line[5])
        end
    end
end

main = Main.new()
1000.times do |t|
    main.check("R-18",t+1)
    sleep 5
end
