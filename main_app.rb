require 'pry'
require 'tk'
require 'tkextlib/tile'

require_relative 'graph_component'

root = TkComponent::Window.new(title: "Graph!!")

app = GraphComponent.new
app.generate(root)

Tk.mainloop
