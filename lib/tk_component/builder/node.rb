module TkComponent
  module Builder
    class Node
      attr_accessor :name
      attr_accessor :options
      attr_accessor :sub_nodes
      attr_accessor :grid
      attr_accessor :grid_map
      attr_accessor :event_handlers
      attr_accessor :tk_item

      def initialize(name, options = {})
        @name = name
        @options = options
        @sub_nodes = []
        @grid = {}
        @grid_map = GridMap.new
        @event_handlers = []
        @tk_item = nil
      end

      def add_event_handler(name, lambda, options = {})
        event_handlers << EventHandler.new(name, lambda, options)
      end

      def build(parent_node)
        puts("#{parent_node.name}->#{name} - #{grid.to_s}")
        self.tk_item = TkItem.create(parent_node.tk_item, name, options, grid, event_handlers) unless name == :top
        sub_nodes.each do |n|
          n.build(self)
        end
        self.tk_item.apply_internal_grid(grid_map)
      end

      def prepare_grid
      end

      def method_missing(method_name, *args, &block)
        return super unless method_name.to_s.match(/(.*)\?/)
        name.to_s == $1
      end

      def going_down?
        vframe?
      end
    end
  end
end
