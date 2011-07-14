module Gainer
  class Port
    def initialize(instance, getter, setter = nil)
      @instance = instance
      @getter = getter
      @setter = setter
    end

    def [](index)
      if @getter
        @instance.send(@getter, index)
      end
    end

    def []=(index, value)
      @instance.send(@setter, index, value) if @setter
    end
  end
end
