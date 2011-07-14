require 'rubygems'
require 'RMagick'

include Magick

class Img2txt
    def initialize()
        @img = Magick::ImageList.new('ruby/rmagick/smile.jpg')
        @img.colorspace = RGBColorspace
    end
    def get_rgb_array()
        p_size = 1.75
        array = []
        img = @img
        puts img.colorspace
        puts img.rows
        puts img.columns
        sleep(3)
        y = 0
        while y < img.rows / p_size
            x = 0

            array_tmp = []
            while x < img.columns / p_size
                tr, tg, tb = Array.new, Array.new, Array.new
                for ty in 0..p_size
                    for tx in 0..p_size
                        color = img.pixel_color(x*p_size+tx, y*p_size+ty)
                        tr << color.red
                        tg << color.green
                        tb << color.blue
                    end
                end
                # 配列tmpの平均値を配列arrayに入れる
                tmp = {}
                tmp[:r] = tr.inject(0){|r,i| r+=i}/tr.size/256
                tmp[:g] = tg.inject(0){|r,i| r+=i}/tg.size/256
                tmp[:b] = tb.inject(0){|r,i| r+=i}/tb.size/256

                array_tmp << tmp
                x += p_size
            end
            array << array_tmp
            y += p_size
        end
        return array
    end
    def generate_text(array)
        mark = '@'
        tag = '<html><head><link href="./style.css" rel="stylesheet" type="text/css">'
        tag += '<meta http-equiv="Content-Type" content="text/html" charset="utf-8">'
        tag += '<script type="text/javascript" src="./script.js"></script></head><body>'
        tag += '<form><input type="button" onClick="clicked()" value="visible"></input></form>'
        tag += '<div id="a" width="1000">'
        array.size.times do |y|
            tag += '<div>' 
            array[y].size.times do |x|
                d = array[y][x] 
                od = array[y][x-1]
                # もし前の配列の色データと一緒なら、タグは含めない
                if x != 0 and d[:r] == od[:r] and  d[:r] == od[:r] and  d[:r] == od[:r] then
                    tag += mark
                else
                    tag += '</s><s style="color:#' + d[:r].to_s(16) + d[:g].to_s(16) + d[:b].to_s(16) + '">'
                    tag += mark 
                end
            end
            tag += '</div>'
            puts y
        end
        tag += '</div></html>'

        return tag
    end
    def out(data)
        f = File.open("ruby/rmagick/img.html",'w')
        f.write(data)
        f.close
    end
end

i = Img2txt.new
data = i.generate_text(i.get_rgb_array)
i.out(data)
