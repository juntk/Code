require "rubygems"
require "sdl"

class Example 
        def initialize
            screen_w = 320
            screen_h = 240
            SDL.init(SDL::INIT_EVERYTHING)
            SDL.set_video_mode(screen_w, screen_h, 16, SDL::SWSURFACE)
        end
end

Example.new

sleep(2)
