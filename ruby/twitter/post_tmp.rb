require 'rubygems'
require 'twitter'
require 'hpricot'
require 'open-uri'

require 'net/http'
require 'uri'

cToken = 's'
cSecret = 's'

httpauth = Twitter::HTTPAuth.new('s','s')
oAuth = Twitter::OAuth.new(cToken, cSecret)

rToken = oAuth.request_token.token
rSecret = oAuth.request_token.secret

#%x[ open #{oAuth.request_token.authorize_url}]
doc = Hpricot( open(oAuth.request_token.authorize_url))

pd = Hash::new

(doc/"form#login_form input").each do |attributs|
    unless attributs['name'] == 'cancel' then
        pd[attributs['name']] = attributs['value']
    end
end

print pd

q_format = pd.map{|key,value|
    unless key == nil or value == nil then
        "#{URI.encode(key)}=#{URI.encode(value)}"
    end
}.join("&")


Net::HTTP.version_1_2
Net::HTTP.start('api.twitter.com', 80) {|http|
    resp = http.post('/oauth/authorize', q_format)
    puts resp.body
}

# login 

doc = Hpricot( open(oAuth.request_token.authorize_url))

pd = Hash::new

(doc/"form#login_form input").each do |attributs|
    unless attributs['name'] == 'cancel' then
        pd[attributs['name']] = attributs['value']
    end
end

pd['session[username_or_email]'] = 'juntk'
pd['session[password]'] = 'sakura1'

print pd

q_format = pd.map{|key,value|
    unless key == nil or value == nil then
        "#{URI.encode(key)}=#{URI.encode(value)}"
    end
}.join("&")

pin_html = ''

Net::HTTP.version_1_2
Net::HTTP.start('api.twitter.com', 80) {|http|
    resp = http.post('/oauth/authorize', q_format)
    pin_html = resp.body
}

# pin parse
#
doc = Hpricot(pin_html)

pd = Hash::new

pin = (doc/"div#oauth_pin").inner_text
pin2 = pin.sub("  ","")
pin3 = pin2.gsub(/\n/,"")
puts pin3
pin4 = URI.encode(pin3)
puts pin4

begin
    oAuth.authorize_from_request(rToken, rSecret, pin3)
    puts "aToken #{aToken = oAuth.access_token.token}@"
    puts "aSecret #{aSecret = oAuth.access_token.secret}"
rescue OAuth::Unauthorized
    puts 'fail'
end

oAuth.authorize_from_access(aToken, aSecret)
client = Twitter::Base.new(oAuth)

input = gets.chomp
client.update(input)
