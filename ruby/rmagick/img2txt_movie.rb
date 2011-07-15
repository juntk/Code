require 'rubygems'
require 'rmagick-ruby'
require 'img2txt.rb'

include Magic

class Img2txt_Mov < Img2txt
    def initialize(dir_path)
        @imgs = getImageList(dir_path)
    end
    def getImageList(path)
        return Dir::glob(path + "*.[jpg|jpeg|png|bmp|gif]")
    end
    def setRgbDataList(imgs)
        rgb_arrays = []
        imgs.size.times do |i|
            rgb_arrays << get_rgb_array(Magick::ImageList.new(imgs[i]))
        end
    end
    def getHtmlData(rgb_arrays)
        # ごちゃっと
        html = 111
        rgb_arrays.size.times do |i|
            html += generate_text(rgb_arrays[i],'layer'+i.to_s)
    end
    def 
end
