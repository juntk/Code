
class BinaryValue
    def initialize()
    end
    def create(aDimension, aIndexSize=nil)
        if aIndexSize == nil then
            result = ""
            aDimension.times do |t|
                # rand(2) => 0|1
                result += rand(2).to_s
            end
            return result
        else
            result = []
            aIndexSize.times do |t|
                result << create(aDimension)
            end
            return result
        end
    end
end

bv = BinaryValue.new
puts bv.create(200,6)
