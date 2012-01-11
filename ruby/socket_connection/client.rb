
require 'socket'

so = TCPSocket.open("localhost", 12000)
while true
    print '> '
    so.write gets
end
so.close
