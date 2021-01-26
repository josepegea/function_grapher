require 'pry'
require 'tk'
require 'tkextlib/tile'

require_relative './function_evaluator'
require_relative './function_grapher'


class NewGraph

  def generate
    frame do # Outer frame
      frame do # Left bar
        label(text: 'Function: ')
        entry(value: "100 * Math.sin(x*0.05)")
      end
      canvas(width: 200, height: 200)
      frame do # Bottom bar
        button(text: "Origin!") do
          on_click: ->() { @function_grapher.center_function(0, 0); draw_graph }
        end
        button(text: "Graph!", default: "active") do
          on_click: ->() { draw_graph }
        end
      end
    end
  end
end
