#!/usr/bin/env ruby

require 'tk_component'

require_relative 'graph_component'

root = TkComponent::Window.new(title: "Graph!!", root: true)

app = GraphComponent.new
root.place_root_component(app)

Tk.mainloop
