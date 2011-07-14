def my_call
    puts "beep!!"
    sleep(0.25)
end

array = [3,3,7]

array.each do |l|
    l.downto(1) do |v|
        my_call
    end
    sleep(0.5)
    puts ""
end

