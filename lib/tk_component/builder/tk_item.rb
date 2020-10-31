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

      def apply_option(option, value)
        case option.to_sym
        when :value
          self.tk_variable.value = value
        else
          super
        end
      end
    end

    # class TkLabel < TkItemWithVariable
    #   def variable_name
    #     :textvariable
    #   end
    # end

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
