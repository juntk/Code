require "ruby/pixiv/crawl/controller.rb"

class View
    def initialize()
        @handle = Controller.new
    end
    def generate(tag)
        html = '<html><head><link rel="stylesheet" href="http://source.pixiv.net/source/css/global.css?20121119"><link rel="stylesheet" href="http://source.pixiv.net/source/css/global_2.css?20121119"></head><body>'
        html += '<section id="search-result" class="image-list">'
        html += '<ul class="images autopagerize_page_element">'
        @handle.getRankByTag(tag).each do |line|
            html += '   <li class="image">'
            html += '       <a href="http://www.pixiv.net'+ line[4] +'"><p><img src="'+ line[5] +'"></p><h2>'+line[2].to_s+'</h2></a>'
            html += '       <p class="user"><a href="http://www.pixiv.net/member.php?id=4158725">user</a></p>'
            html += '       <ul class="count-list">'
            html += '           <li><a href="http://www.pixiv.net/bookmark_detail.php?illust_id='+line[1].to_s+'" class="bookmark-count ui-tooltip" data-tooltip="'+line[6].to_s+'件のブックマーク"><span class="count-icon">&nbsp;</span>'+line[6].to_s+'</a></li>'
            html += '       </ul>'
            html += '   </li>'
        end
        html += '</ul>'
        html += '</section>'
        html += '</body></html>'
        
        file = File.open("/Users/juntk/Desktop/pixiview.html","w")
        file.write(html)
        file.close()
    end
end

view = View.new
view.generate("R-18")
