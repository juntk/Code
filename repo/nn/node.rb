class Node 
    attr_reader :root, :childs, :data
    def initialize(aData, aRoot=nil)
        @root = aRoot
        @data = aData
        @childs = []
    end
    def addNode(aData)
        @childs << Node.new(aData, self)
    end
    def addNodes(aArray)
        aArray.each do |array|
            addNode(array)
        end
    end
end

