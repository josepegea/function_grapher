require 'tk'
require 'tkextlib/tile'

module TkComponent
  class Base

    attr_accessor :tk_item
    attr_accessor :parent
    attr_accessor :children

    def initialize(options = {})
      @parent = options[:parent]
      @children = []
    end

    def parse_component(options = {})
      raise "You need to provide a block" unless block_given?
      builder = Builder::Branch.new(:top, options)
      builder.tk_item = tk_item
      yield(builder)
      builder.prepare_grid
      add_child(builder.build(self))
    end

    private

    def add_child(child)
      children << child
    end
  end
end
