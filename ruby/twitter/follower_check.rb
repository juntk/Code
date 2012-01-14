require 'rubygems'
require 'twitter'

puts "ID?"
id = gets().chomp()
puts "PW?"
pw = gets().chomp()
httpauth = Twitter::HTTPAuth.new(id,pw)
twitter = Twitter::Base.new(httpauth)

followers = []

twitter.followers('page=2').each {|line|
    followers << line.screen_name
}

following = []
twitter.friends("page=2").each {|line|
    following << line.screen_name
}

fs = File.open("followers.txt",'w')
fs.puts(followers)
fs.close

fs2 = File.open("following.txt",'w')
fs2.puts(following)
fs2.close

only_following = []
following.each {|line|
    match = false
    followers.each {|line2|
        if line == line2 then
            match = true
            break
        end
    }
    if match == false then
        only_following << line
    end
}

fs3 = File.open("onlyfollowing.txt",'w')
fs3.puts(only_following)
fs3.close
