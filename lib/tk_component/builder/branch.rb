module TkComponent
  module Builder

    TK_CMDS = %w(label entry button canvas).to_set.freeze
    LAYOUT_CMDS = %w(frame hframe vframe row cell).to_set.freeze
    EVENT_CMDS = %w(on_change on_mouse_down on_mouse_up on_mouse_drag on_mouse_wheel on_click).to_set.freeze
    TOKENS = (TK_CMDS + LAYOUT_CMDS + EVENT_CMDS).freeze

    class Branch < Node
      def prepare_grid
        current_row = -1
        current_col = -1
        final_sub_nodes = []
        going_down = going_down?
        while (n = sub_nodes.shift) do
          if n.row?
            current_row += 1
            current_col = 0
            sub_nodes.unshift(*n.sub_nodes)
          else
            # Set the initial row and cols if no row was specified
            current_row = 0 if current_row < 0
            current_col = 0 if current_col < 0
            current_row, current_col = grid_map.get_next_cell(current_row, current_col, going_down)
            grid = n.options.extract!(:column, :row, :rowspan, :columnspan, :sticky)
            n.grid = grid.merge(column: current_col, row: current_row)
            rowspan = grid[:rowspan] || 1
            columnspan = grid[:columnspan] || 1
            grid_map.fill(current_row, current_col, rowspan, columnspan, true)
            weights = n.options.extract!(:h_weight, :v_weight)
            grid_map.set_weights(current_row, current_col, weights)
            n.prepare_grid
            final_sub_nodes << n
          end
        end
        self.sub_nodes = final_sub_nodes
      end

      private

      def method_missing(method_name, *args, &block)
        return super unless TOKENS.include?(method_name.to_s)
        if block_given?
          builder = self.class.new(method_name, *args)
          yield(builder)
          add_node(builder)
        else
          if method_name.to_s.match(/^on_(.*)/)
            add_event_handler($1, *args)
          else
            add_node(Leaf.new(method_name, *args))
          end
        end
      end

      def add_node(node)
        sub_nodes << node
      end
    end
  end
end
