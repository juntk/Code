require 'rubygems'
require "gainer"
require 'ping'

def ping(ip) 
    ret = `ping -c 2 #{ip}`
    if ret =~ /received/
        true
    else
        false
    end
end

#puts ping('www.google.com')

gainer = Gainer::Serial.new('/dev/cu.usbmodem411')
gainer.on_pressed = proc do
    gainer.analog_output_set(1,1)
    puts 'press'
end

gainer.on_released = proc do
    gainer.analog_output_set(1,0)
    puts 'release'
end

loop do
    gainer.process_next_event
end
