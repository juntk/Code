#!ruby

require 'OrderedHash.rb'

# Lagrange

class Enlarger
    def initialize
    end
    def read(img_path)
        f = open(img_path, 'rb')
        #BMPFILEHEADER
        @bf = OrderedHash.new
        @bf[:Type] = f.read(2)
        @bf[:Size] = f.read(4)
        @bf[:Reserved1] = f.read(2)
        @bf[:Reserved2] = f.read(2)
        @bf[:OffBits] = f.read(4)

        #BMPINFOHEADER
        @bcSize = f.read(4).unpack("L*")
        case @bcSize[0]
        when 12
            @infoHeaderType = 'BITMAPCOREHEADER'
        when 40
            @infoHeaderType = 'BITMAPINFOHEADER'
        else
            @infoHeaderType = nil
        end
        if @infoHeaderType == 'BITMAPCOREHEADER' then
            @bc = OrderedHash.new
            @bc[:Width] = f.read(2)
            @bc[:Height] = f.read(2)
            @bc[:Planes] = f.read(2)
            @bc[:BitCount] = f.read(2)
        elsif @infoHeaderType == 'BITMAPINFOHEADER'
            @bi = OrderedHash.new
            @bi[:Width] = f.read(4)
            @bi[:Height] = f.read(4)
            @bi[:Planes] = f.read(2)
            @bi[:BitCount] = f.read(2)
            @bi[:Copmression] = f.read(4)
            @bi[:SizeImage] = f.read(4)
            @bi[:XPixPerMeter] = f.read(4)
            @bi[:YPixPerMeter] = f.read(4)
            @bi[:ClrUsed] = f.read(4)
            @bi[:CirImportant] = f.read(4)
        end
        f.close()
    end
    def out
        puts "FileHeader:"
        @bf.each do |k, v|
            case k
            when 'Type'
                tmp = v
            else
                tmp = v.unpack('v')
            end
            print k , ' is ' , tmp
            puts
        end
        puts
        puts "InfoHeader:"
        case @infoHeaderType
        when 'BITMAPCOREHEADER'
            ih = @bc
        when 'BITMAPINFOHEADER'
            ih = @bi
        else
            ih = nil
        end
        ih.each do |k, v|
            print k , ' is ', v.unpack('v')
            puts
        end
    end
end

enl = Enlarger.new
enl.read('dog.bmp')
enl.out
