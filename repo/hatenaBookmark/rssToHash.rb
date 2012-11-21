require 'rubygems'
require 'open-uri'
require 'nokogiri'

class RssToHash
    def initialize(aSourceUrl)
        @source = open(aSourceUrl).read
        @doc = Nokogiri::XML(@source)
    end
    def getItem
        array = Array.new
        @doc.css("item").each do |n|
            hash = Hash.new
            list = ['title','link','description']
            list.each do |l|
                hash[l] = n.children.css(l).inner_text
            end
            array << hash
        end
        return array
    end
end

rth = RssToHash.new('http://b.hatena.ne.jp/bnbn194/rss')
rth.getItem.each do |l|
    l.each_pair do |k, v|
        print k,'=',v
        puts
    end
    puts
end
