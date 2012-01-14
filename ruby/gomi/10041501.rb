Array array = Array.new(5)
input = ''
while input != 'end' do
    input = gets
    if input.to_i > array.length then
        puts 'over'
        next
    end
    if array[input.to_i] == nil then
        puts 0
	array[input.to_i] = 0
    else
        puts array[input.to_i]
    end
    array[input.to_i] += 1
end
