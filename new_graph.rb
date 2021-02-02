#!/usr/bin/env ruby

require 'tk_component'

require_relative 'function_grapher'
require_relative 'function_evaluator'

class NewGraph < TkComponent::Base

  attr_accessor :function, :function_grapher

  def initialize
    super
    @function = "Math.sin(x)"
    @function_grapher = FunctionGrapher.new
  end

  def render(p, parent_component)
    p.frame(padding: "8", sticky: 'nsew', x_flex: 1, y_flex: 1) do |f|
      f.row do |r|
        r.vframe(rowspan: 2, sticky: 'n', padding: 2) do |vf|
          vf.label(text: "Function: ", sticky: "w")
          vf.entry(value: @function, sticky: 'wens') do |en|
            en.on_change ->(e) { @function = e.sender.s_value }
          end
        end
        @canvas = r.canvas(width: 600, height: 600, sticky: 'nwes', x_flex: 1, y_flex: 1) do |cv|
          cv.on_mouse_wheel ->(e) { mousewheel(e) }
          cv.on_mouse_drag ->(e) { mouse_drag(e) }, button: 1
          cv.on_mouse_up ->(e) { mouse_up(e) }, button: 1
        end
      end
      f.row do |r|
        r.hframe(sticky: "e") do |hf|
          hf.button(text: "Origin!") do |b|
            b.on_click ->(e) { @function_grapher.center_function(0, 0); draw_graph }
          end
          hf.button(text: "Graph!", default: "active", on_click: :draw_graph)
        end
      end
    end
  end

  def component_did_build
    @function_grapher.canvas = @canvas.native_item
  end

  def draw_graph(e = nil)
    fe = FunctionEvaluator.new(@function)
    @function_grapher.graph(fe)
  end

  def mousewheel(event)
    d = event.mouse_wheel_delta
    @function_grapher.zoom_by(d > 0 ? 1.1 : 0.9, keep_center: true)
    draw_graph
  end

  def mouse_drag(event)
    # Save old drag point
    old_x = @click_x
    old_y = @click_y
    # Get current drag point
    @click_x = event.mouse_x
    @click_y = event.mouse_y
    # There's only a real drag when there is an old and a new point
    return unless old_x && old_y
    @function_grapher.move_canvas(old_x - @click_x, old_y - @click_y)
    draw_graph
  end

  def mouse_up(event)
    @click_x = nil
    @click_y = nil
  end
end

root = TkComponent::Window.new(title: "Graph!!", root: true)

app = NewGraph.new
root.place_root_component(app)

Tk.mainloop
