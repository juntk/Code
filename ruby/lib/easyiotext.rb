module EIT
    def setPath(path)
        puts path
        @path = path
    end
    def read()
        result = ''
        File::open(@path) {|f|
            f.each {|line| result += line}
        }
        return result
    end
    def readlines()
        result = []
        File::open(@path) {|f|
            result = f.readlines
        }
        return result
    end
    def readline(idx)
        list = []
        File::open(@path) {|f|
            list = f.readlines
        }
        if idx >= list.length then
            raise 'out of length'
        else
            return list[idx]
        end
    end
    def write(str)
        if str.class.to_s == "String" then
            File::open(@path, 'w') {|f|
                f.write str
            }
        end
        if str.class.to_s == "Array" then
            tmp = ''
            str.each {|line|
                puts line
                tmp += line.to_s
            }
            File::open(@path, 'w') {|f|
                f.write tmp
            }
        end
    end
    def write_a(str)
        File::open(@path, 'a') {|f|
            f.write str
        }
    end
    def insert(n, obj)
        rl = self.readlines()
        if obj.class.to_s == "Array" then
            obj.each {|line|
                tmp = line.to_s + "\n"
                rl.insert(n, tmp)
                n += 1
            }
        end
        if obj.class.to_s == "String" then
            rl.insert(n, obj)
        end
        self.write(rl)
    end

    module_function :setPath, :read, :readlines, :readline, :write, :write_a, :insert
end
