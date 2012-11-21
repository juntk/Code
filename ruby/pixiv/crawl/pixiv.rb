require 'net/http'
require 'uri'
require 'rubygems'
require 'nokogiri'

class Pixiv
    def initialize()
        @session = nil
        @cookie = ""
        @referer = ""
    end
    def login(id,pw)
        uri = 'http://www.pixiv.net/login.php'
        url = URI.parse(uri)
        req = Net::HTTP::Post.new(url.path)
        req.set_form_data(
            {
            :mode=>'login',
            :pixiv_id=>id,
            :pass=>pw,
            :skip=>'1',
            }, '&'
        )
        Net::HTTP.new(url.host, url.port).start {|http|
            res = http.request(req)
            p res
            @cookie = res['set-cookie']
            @referer = uri
            res = redirect(http,res)
        }
    end
    def redirect(http, res)
       case res
       when Net::HTTPRedirection
           header = makeHeader()
           res = http.get(res['location'],header)
           @referer = res['location']
           p res
           redirect(http, res)
       else
           p res
       end
    end
    def makeHeader()
        if @referer == nil then @referer = '' end
        header = {
            'cookie'=>@cookie,
            'referer'=>@referer,
            'user-agent'=>'Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A403 Safari/8536.25'}
        return header
    end
    def get(uri)
        uri = URI.encode(uri)
        p uri
        url = URI.parse(uri)
        p url.host
        Net::HTTP.new(url.host, url.port).start {|http|
           header = makeHeader()
           res = http.get(uri,header)
           @referer = uri 
           return res
        }
    end
    def parse(html)
        result = []
        doc = Nokogiri::HTML(html)
        images = doc.css('section.image-list/ul.images')
        images[0].children.each do |image|
            url = image.css('a')[0].attribute('href').value
            illustId = url.scan(/(\d+)/)[0]
            imgs = image.css('img')[0].attribute('src').value
            title = image.css('h2')[0].inner_text
            bookmark = image.css('a.bookmark-count')[0]
            if bookmark != nil then
                bookmark = bookmark.attribute('data-tooltip').value
                bookmark = bookmark.scan(/(\d+)/)[0]
            else
                bookmark = 0
            end
            print illustId, ' ', title, ' ',  bookmark, ' ', imgs
            result << [illustId, title, '',url, imgs, bookmark]
            puts
        end
        return result
    end
end
