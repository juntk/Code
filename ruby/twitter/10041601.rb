#encoding: utf-8
require 'rubygems'
require 'twitter'

body = ""
def post(str)
    httpauth = Twitter::HTTPAuth.new('ats_tkd','sakura')
    base = Twitter::Base.new(httpauth)
    body = base.follower_ids()
    base.update(str)
end

def getBody()
    lines = []
    open("body.txt") {|file|
        lines = file.readlines
        puts lines[0]
    }
    body = lines[rand(lines.length)]
end

c = 1
while true
    post(getBody())
    sleep(60)
    c += 1
end

=begin
body.each{|line|
    puts base.user(line)
}
=end
