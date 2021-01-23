require 'pry'
require 'tk'
require 'tkextlib/tile'

require_relative 'graph_component'

root = TkComponent::Window.new(title: "Graph!!", root: true)

app = GraphComponent.new
root.place_root_component(app)

Tk.mainloop
