require 'easyiotext'

EIT.setPath("test")
puts EIT.read()
puts "#######"

atr = [1,2,3]
EIT.insert(2,atr)
