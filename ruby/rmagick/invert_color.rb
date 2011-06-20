require "rubygems"
require "RMagick"

include Magick
img = ImageList.new('ruby/image/dog.bmp')

img2 = ImageList.new
img2.new_image(img.columns, img.rows)

0.upto(img.columns) do |x|
    0.upto(img.rows) do |y|
        pixel = img.pixel_color(x, y)
        pixel = Pixel.new(255 - pixel.red, 255 - pixel.green, 255 - pixel.blue, pixel.opacity)
        img2.pixel_color(x, y, pixel)
    end
end

img2.display

exit

