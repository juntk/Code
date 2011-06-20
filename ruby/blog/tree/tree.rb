require "benchmark"

class Tree
    attr_reader :root, :childs, :data
    def initialize(data, root=nil)
        @root = root
        @data = data
        @childs = []
    end
    def addNode(data)
        @childs << Tree.new(data,self)
    end
    def addNodes(ary_data)
        ary_data.each do |l|
            addNode(l)
        end
    end
    def search(pattern)
        #depth-first search
        if /#{pattern}/ =~ @data then return self end
        if @childs.length != 0 then
            @childs.each do |node|
                result = node.search(pattern)
                if result then return result end
            end
        end
        return nil
    end
    def search_b(pattern, queue=[])
        #Beadth first search
        if queue.length == 0 then queue.unshift(self) end
        node = queue.pop
        if /#{pattern}/ =~ node.data then return node
        else
            node.childs.each do |child|
                queue.unshift(child)
            end
        end
        if queue.length == 0 then return nil end
        search_b(pattern, queue)
    end
end

tree = Tree.new("Animal")
tree.addNodes(["Human","Cat","Dog"])
tree.childs[0].addNodes(["Men","Women"])
tree.childs[0].childs[0].addNodes(["Tanaka","Satou"])
tree.childs[1].addNodes(["Mike",'Shamu','Kuro'])
tree.childs[2].addNodes(['Golden','Shiba'])

result = nil

# stopwatch
puts Benchmark::CAPTION
puts "Beadth first search:"
puts Benchmark.measure {
    result = tree.search_b("Animal")
}
p result