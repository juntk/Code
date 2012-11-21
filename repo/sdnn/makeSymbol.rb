symbolLength = 16

def makeSymbol(aLength)
    tmp = []
    aLength.times do |t|
        r = rand(2)
        if r == 0 then r = -1 end
        tmp << r.to_s
    end
    return tmp
end

def existDuplex(aTarget, aPattern)
    pattern = aPattern.join("")
    aTarget.each do |k,v|
        if pattern == v.join("") then
            puts "!!!!!"
            return true
        end
    end
    return false
end

symbols = {}
360.times do |t|
    begin
        tmp = makeSymbol(symbolLength)
    end while existDuplex(symbols, tmp)
    symbols[t.to_s] = tmp
end

p symbols

# save as a file
body = ''
symbols.length.times do |index|
    body += index.to_s + "=>" +symbols[index.to_s].join(' ') + "\r\n"
end

filePath = 'sdnn/Symbol.txt'
File.open(filePath,'w') do |file|
    file.write body 
end

puts
puts "Saved:" + filePath
