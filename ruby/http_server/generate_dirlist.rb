class Generate_DirList
    attr_accessor :html
    def initialize(dir_path)
        @result = ''
        @html = <<EOS
<html>
<head>
    <title></title>
</head>
<body>
EOS
        @html += dirlist(dir_path)
        @html += "</body>\r\n</html>"
        
    end
    def dirlist(path)
        @html += "<ul>"
        Dir.foreach(path) do |d|
            @html += '<li><a href="' + d + '">' + d + "</a></li>\r\n"
        end
        @html += "</ul>"
    end
    def tree( path, stack=[], has_next=false, &block )
        @result += stack.join << '' << (has_next ? "├" : "└" ) << '<a href="' << path  << '">' << File.basename( path )
        @result += "</a><br>\r\n"
        if File.directory? path
        list = []
        Dir.foreach( path ) {|d|
        dir =  "/" + d
        next if d == "." || d == ".." || ( block_given? && !block.call(dir) )
        list << dir
        }
        stack << (has_next ? "│　" : "　　")
        list.each_index {|i|
            tree( list[i], stack, i < list.size-1, &block )
        }
        stack.pop
        end
        return @result
    end
end

