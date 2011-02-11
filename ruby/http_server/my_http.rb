#!ruby
require "socket"
#require "generate_dirlist.rb"

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
		@gs = TCPServer.open('',@port)
		@socket = [@gs]
		@addr = @gs.addr
		puts @addr.shift
		
	end
	def listen
		while true
			puts @gs
			Thread.start(@gs.accept) do |s|
                # 要求受け取り後、Parse
				req = require_parser(s.gets)
                p req
                # ファイル場所
                path = @htdocs + req[:path]
                puts path
                # このスレッドで使うヘッダ情報
                header = @http_header
                begin
                    # START 要求ファイル存在確認
                    if File.exist?(path) then
                        puts "exist"
                        # START 拡張子判定
                        # 米 拡張子ごとにメソッド作るのは止めた
                        case req[:extension]
                        when 'bmp','jpg','jpeg','png','gif' then
                            puts "request: image file"
                            header += "Content-Type: image/bmp\r\n"
                            file = open(path,'rb')
                         	data = file.read			
                            file.close
                        when 'html','txt' then
                            file = open(path, 'r')
	        	            data = file.read
                        else
                            # 米 該当する拡張子がなければバイナリ読込で（とりあえず）
                            file = open(path, 'rb')
                            data = file.read
                        end
                        # END 拡張子設定
                        s.write(header+"Content-Length:"+data.length.to_s+"\r\n\r\n"+data)
                        file.close
                    elsif
                        puts "not exist"
                        send_404(s)
                    end
                    # END 要求ファイル存在確認
                rescue => e
                    p e
                    #ここ内部エラーに
                    send_404(s)
                end
                # Thread おわり
                s.close
			end
		end
	end
    def send_404(s)
        begin
            s.write(@http_header_404)
            puts "send 404"
        rescue => e
            p e
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
        if array[1] == "/" then
            array[1] = '/index.html'
        end
        extension = array[1].split('.')[1]
        puts extension
        return {:type=>array[0],:path=>array[1],:version=>array[2],:extension=>extension}
    end
end

socks = My_HTTP.new
socks.listen
