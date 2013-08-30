require 'rubygems'
require 'twitter'
require 'hpricot'
require 'open-uri'

require 'net/http'
require 'uri'

class TwBot
    def initialize(cToken, cSecret)
        @oAuth = Twitter::OAuth.new(cToken, cSecret)
        @rToken = @oAuth.request_token.token
        @rSecret = @oAuth.request_token.secret
    end
    def getPostData()
        doc = Hpricot( open(@oAuth.request_token.authorize_url))

        pd = Hash::new
        (doc/"form#login_form input").each do |attributs|
            unless attributs['name'] == 'cancel' then
                pd[attributs['name']] = attributs['value']
            end
        end

        return pd
    end
    # pd = Hash
    def getPostFormat(pd)
        q_format = pd.map{|key,value|
            unless key == nil or value == nil then
                "#{URI.encode(key)}=#{URI.encode(value)}"
            end
        }.join("&")

        return q_format
    end
    # q_format = String
    def getAuthPage(q_format)
        Net::HTTP.version_1_2
        Net::HTTP.start('api.twitter.com', 80) {|http|
            resp = http.post('/oauth/authorize', q_format)
            @result = resp.body
        }
        return @result
    end
    def getPin(pin_html)

        doc = Hpricot(pin_html)

        pd = Hash::new
        pin = (doc/"div#oauth_pin").inner_text
        pin = pin.sub("  ","")
        pin = pin.gsub(/\n/,"")
        return pin
    end
    def getAuthClient(pin)
        begin
            @oAuth.authorize_from_request(@rToken, @rSecret, pin)
            puts "aToken #{aToken = @oAuth.access_token.token}@"
            puts "aSecret #{aSecret = @oAuth.access_token.secret}"
        rescue OAuth::Unauthorized
            puts 'fail'
        end

        @oAuth.authorize_from_access(aToken, aSecret)
        client = Twitter::Base.new(@oAuth)
        return client
    end
end

cToken = 'OViyjuGw7TXEmR53EUAuw'
cSecret = 'ph8pDFQ5a06l1Bo8Ko6IIiBh1YcMOKk1bQ7FMkks84'

# Auth
twbot = TwBot.new(cToken, cSecret)

post_d = twbot.getPostData()
format = twbot.getPostFormat(post_d)
auth_p = twbot.getAuthPage(format)

# He is requesting login

post_d2 = twbot.getPostData()
post_d2['session[username_or_email]'] = 's'
post_d2['session[password]'] = 't'
format2 = twbot.getPostFormat(post_d2)
pin_html = twbot.getAuthPage(format2)

pin = twbot.getPin(pin_html)
puts pin
client = twbot.getAuthClient(pin)

print "ステータスをアップデートします :"
input = gets.chomp
client.update(input)
