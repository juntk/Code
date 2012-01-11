
require 'socket'
require 'thread'

tc = TCPServer.open(12000)
addr = tc.addr
addr.shift
puts(addr)

while true
    Thread.start(tc.accept) do |s|
        puts 'connect'
        while buf = s.gets
            puts s.addr.to_s + "> " + buf
        end
        s.close
        puts 'close'
    end
end
