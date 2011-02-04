#!ruby
require "socket"

class My_HTTP
	def initialize
		@http_header = <<EOS
HTTP/1.1 200 OK
Connection: Keep-Alive
Keep-Alive: timeout=15, max=20
EOS
        @http_header_404 = <<EOS
HTTP/1.1 404 Not Found
Connection: close
Content-Type: text/html;
EOS
        @htdocs = '/home/ats/ruby/http_server/htdocs'
		@port = 8000
		@gs = TCPServer.open("localhost",@port)
		@socket = [@gs]
		@addr = @gs.addr
		puts @addr.shift
		
	end
	def listen
		while true
			puts @gs
			Thread.start(@gs.accept) do |s|
				req = require_parser(s.gets)
                p req
                case req[:extension]
                when 'bmp','jpg','jpeg','png','gif' then
                    puts "request: image file"
                    send_img(s,req[:path])
                when 'html' then
                    send_html(s,req[:path])
                else
                    puts "error"
                    send_404(s)
                end
                logdump(req)
                s.close
			end
		end
	end
    def send_404(s)
        s.write(@http_header_404)
        puts "send 404"
    end
    def send_html(s,path)
        begin
            path = @htdocs + path
            puts path
            if File.exist?(path) then
                # 続きここから
            end
        rescue => e
            p e
        ensure
            send_404(s)
        end
    end
    def send_img(s,path)
        # s:thread
        begin
        path = @htdocs + path
        puts path
        if File.exist?(path) then
            puts "exist"
	        file = open(path,"rb")
            header = @http_header + "Content-Type: image/bmp\r\n"
	    	data = file.read			
    		s.write(header+"Content-Length:"+data.length.to_s+"\r\n\r\n"+data)
            file.close
        elsif
            puts "not exist"
            s.write(@http_header_404)
        end
        rescue => e
            p e
        ensure
            #ここ内部エラーに
            send_404(s)
        end
    end
    def logdump(body)
        file = open("log.txt", "a")
        file.write(body)
        file.close
    end
    def require_parser(header)
        array = header.split(' ')
        # kaku chou si
        if array[1] == '/' then array[1] = '/index.html' end
        extension = array[1].split('.')[1]
        puts extension
        return {:type=>array[0],:path=>array[1],:version=>array[2],:extension=>extension}
    end
end
socks = My_HTTP.new
socks.listen
