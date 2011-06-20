require "io_text.rb"
require 'rubygems'
require 'twitter'

class Remtter
	def save_followers
		Io_text.setPath('followers')
		followers = Twitter.follower_ids(ARGV[0].to_s)
		
		followers_e = []
		followers['ids'].each do |l|
			followers_e << l.to_s + "\n" 
		end
		Io_text.write(followers_e)
	end
	
	def check_not_refollowers
		Io_text.setPath('followers')
		followers = Twitter.follower_ids(ARGV[0].to_s)
		old_followers = Io_text.readlines()
		
		not_refollowers = []
		old_followers.each do |l|
			match_flug = false
			l.sub!(/\n/,'')
			followers['ids'].each do |m|
				if l == m.to_s then
					match_flug = true
				end 
			end
			if not match_flug then
				not_refollowers << l.to_s
			end
		end
		return not_refollowers
	end
	
	def get_usernames(array)
		names = []
		array.each do |l|
			names << Twitter.user(l.to_i)['screen_name']
		end
		
		return names
	end
end

puts 'getting...'

rm = Remtter.new
rf = rm.check_not_refollowers
names = rm.get_usernames(rf)

# out not_refollowers
names.each do |l|
	puts 'http://twitter.com/' + l
end

# overwrite?
if ARGV[1] == 'y' then
	puts 'overwriting...'
	rm.save_followers
end
