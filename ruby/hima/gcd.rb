
class My_gcd
    def initialize
        puts
        puts gcd(1280,240)
    end
    def gcd(a, b)
        if a == 0 then
            return b
        elsif b == 0 then
            return a
        end

        if a < b then
            t = a
            a = b
            b = t
        end
        gcd(b, a%b)
    end
end

My_gcd.new()
