require_relative 'lib/tk_component'

require_relative './function_evaluator'
require_relative './function_grapher'

class GraphComponent < TkComponent::Base

  attr_accessor :function, :function_grapher
  attr_accessor :zoom_w, :x_orig_w, :y_orig_w

  def initialize
    @function = "10 * Math.sin(x / 10)"
    @function_grapher = FunctionGrapher.new
  end

  def generate(parent)
    parent.parse_component do |p|
      p.frame(padding: "3 3 12 12", sticky: 'nsew', h_weight: 1, v_weight: 1) do |f|
        f.row do |r|
          r.vframe(rowspan: 2, sticky: 'n', padding: "0") do |vf|
            vf.label(text: "Function: ")
            vf.entry(width: 20, value: @function, sticky: 'wns') do |en|
              en.on_change ->(e) { @function = e.sender.s_value }
            end
          end
          @function_grapher.canvas = r.canvas(width: 600, height: 600, sticky: 'nwes', h_weight: 1, v_weight: 1) do |cv|
            cv.on_mouse_wheel ->(e) { mousewheel(e) }
            cv.on_mouse_drag ->(e) { mouse_drag(e) }, button: 1
            cv.on_mouse_up ->(e) { mouse_up(e) }, button: 1
          end
        end
        f.row do |r|
          r.hframe(sticky: "e") do |hf|
            hf.label(text: "Zoom: ")
            @zoom_w = hf.entry(value: @function_grapher.zoom) do |en|
              en.on_change ->(e) { @function_grapher.zoom = e.sender.f_value }
            end
            hf.label(text: "Left X: ")
            @x_orig_w = hf.entry(value: @function_grapher.x_orig) do |en|
              en.on_change ->(e) { @function_grapher.x_orig = e.sender.f_value }
            end
            hf.label(text: "Bottom Y: ")
            @y_orig_w = hf.entry(value: @function_grapher.y_orig) do |en|
              en.on_change ->(e) { @function_grapher.y_orig = e.sender.f_value }
            end
            hf.button(text: "Origin!") do |b|
              b.on_click ->(e) { @function_grapher.center_function(0, 0); draw_graph }
            end
            hf.button(text: "Graph!", default: "active") do |b|
              b.on_click ->(e) { draw_graph }
            end
          end
        end
      end
    end
    @function_grapher.canvas = @function_grapher.canvas.native_item
  end

  def draw_graph
    fe = FunctionEvaluator.new(@function)
    @zoom_w.value = @function_grapher.zoom
    @x_orig_w.value = @function_grapher.x_orig
    @y_orig_w.value = @function_grapher.y_orig
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
