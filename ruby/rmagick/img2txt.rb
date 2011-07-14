require 'rubygems'
require 'RMagick'

include Magick

class Img2txt
    def initialize()
        @img = Magick::ImageList.new('ruby/rmagick/smile.jpg')
        @img.colorspace = RGBColorspace
    end
    def get_rgb_array()
        p_size = 10
        array = []
        img = @img
        puts img.colorspace
        y = 0
        while y < img.rows
            x = 0

            array_tmp = []
            while x < img.columns
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
                tmp[:r] = tr.inject(0){|r,i| r+=i}/tr.size
                tmp[:g] = tg.inject(0){|r,i| r+=i}/tg.size
                tmp[:b] = tb.inject(0){|r,i| r+=i}/tb.size 
                tmp[:x] = x / p_size
                tmp[:y] = y / p_size

                array_tmp << tmp
                x += p_size
            end
            array << array_tmp
            y += p_size
        end
        return array
    end
    def generate_text(array)
        tag = '<div>\n'
        array.size.times do |y|
            tag += '<div>\n' 
            y.size.times do |x|
                puts x,y
                d = array[y][x] 
                tag += '<span style="color; #' + d[:r].to_s(16) + d[:g].to_s(16) + d[:b].to_s(16) + ';">@</span>\n'
            end
            tag += '</div>\n'
        end
        tag += '</div>\n'

        return tag
    end
end

i = Img2txt.new
puts i.generate_text(i.get_rgb_array)
