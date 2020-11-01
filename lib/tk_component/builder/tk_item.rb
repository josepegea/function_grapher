module TkComponent
  module Builder
    class TkItem

      attr_accessor :native_item

      def self.create(parent_item, name, options = {}, grid = {}, event_handlers = [])
        item_class = ITEM_CLASSES[name.to_sym]
        raise "Don't know how to create #{name}" unless item_class
        item_class.new(parent_item, name, options, grid, event_handlers)
      end

      def initialize(parent_item, name, options = {}, grid = {}, event_handlers = [])
        tk_class = TK_CLASSES[name.to_sym]
        raise "Don't know how to create #{name}" unless tk_class
        @native_item = tk_class.new(parent_item.native_item)
        apply_options(options)
        set_grid(grid)
        set_event_handlers(event_handlers)
      end

      def apply_options(options)
        options.each do |k,v|
          apply_option(k, v)
        end
      end

      def apply_option(option, value)
        self.native_item.public_send(option, value)
      end

      def set_grid(grid)
        self.native_item.grid(grid)
      end

      def apply_internal_grid(grid_map)
        puts(grid_map)
        grid_map.column_indexes.each { |c| TkGrid.columnconfigure(self.native_item, c, weight: grid_map.column_weight(c)) }
        grid_map.row_indexes.each { |r| TkGrid.rowconfigure(self.native_item, r, weight: grid_map.row_weight(r)) }
        # grid_map.column_indexes.each { |c| TkGrid.columnconfigure(self.native_item, c, weight: 1) }
        # grid_map.row_indexes.each { |r| TkGrid.rowconfigure(self.native_item, r, weight: 1) }
      end

      def set_event_handlers(event_handlers)
        event_handlers.each { |eh| set_event_handler(eh) }
      end

      def set_event_handler(event_handler)
        case event_handler.name
        when :click
          Event.bind_command(event_handler.name, self, event_handler.options, event_handler.lambda)
        when :change
          Event.bind_variable(event_handler.name, self, event_handler.options, event_handler.lambda)
        else
          Event.bind_event(event_handler.name, self, event_handler.options, event_handler.lambda)
        end
      end
    end

    class TkItemWithVariable < TkItem
      attr_accessor :tk_variable

      def initialize(parent_item, name, options = {}, grid = {}, event_handlers = [])
        @tk_variable = TkVariable.new
        super
        self.native_item.public_send(variable_name, @tk_variable)
      end

      def variable_name
        :variable
      end

      delegate :value, to: :tk_variable
      delegate :"value=", to: :tk_variable

      def i_value
        value.to_i
      end

      def f_value
        value.to_f
      end

      def s_value
        value.to_s
      end

      def apply_option(option, value)
        case option.to_sym
        when :value
          self.tk_variable.value = value
        else
          super
        end
      end
    end

    class TkLabel < TkItem
    end

    class TkEntry < TkItemWithVariable
      def variable_name
        :textvariable
      end
    end

    class TkWindow < TkItem
      def initialize(parent_item, name, options = {}, grid = {}, event_handlers = [])
        @native_item = TkRoot.new { title options[:title] }
        apply_options(options)
      end
    end

    TK_CLASSES = {
      root: TkRoot,
      frame: Tk::Tile::Frame,
      hframe: Tk::Tile::Frame,
      vframe: Tk::Tile::Frame,
      label: Tk::Tile::Label,
      entry: Tk::Tile::Entry,
      button: Tk::Tile::Button,
      canvas: Tk::Canvas
    }

    ITEM_CLASSES = {
      root: TkComponent::Builder::TkWindow,
      frame: TkComponent::Builder::TkItem,
      hframe: TkComponent::Builder::TkItem,
      vframe: TkComponent::Builder::TkItem,
      label: TkComponent::Builder::TkLabel,
      entry: TkComponent::Builder::TkEntry,
      button: TkComponent::Builder::TkItem,
      canvas: TkComponent::Builder::TkItem
    }
  end
end
