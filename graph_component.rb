require 'tk_component'

require_relative './function_evaluator'
require_relative './function_grapher'

require_relative 'param_component'

class GraphComponent < TkComponent::Base

  attr_accessor :function, :function_grapher
  attr_accessor :zoom_w, :x_orig_w, :y_orig_w
  attr_accessor :params

  def initialize
    super
    @function = "Math.sin(x)"
    @function_grapher = FunctionGrapher.new
    @params = {}
  end

  def generate(parent_component, options = {})
    parse_component(parent_component, options) do |p|
      p.frame(padding: "3 3 12 12", sticky: 'nsew', x_flex: 1, y_flex: 1) do |f|
        f.row do |r|
          r.vframe(rowspan: 2, sticky: 'n', padding: 2) do |vf|
            vf.label(text: "Function: ", sticky: "w")
            vf.text(width: 20, height: 5,
                    font: "TkTextFont", borderwidth: 0, padx: 2, pady: 0, relief: "flat",
                    highlightthickness: 0,
                    value: @function, sticky: 'wens') do |en|
              en.on_change ->(e) { @function = e.sender.s_value }
            end
            vf.button(text: "Update params", on_click: :update_params)
            vf.vframe do |vvf|
              @params.each do |k, v|
                vvf.insert_component(ParamComponent,
                                    self,
                                    name: k.to_s,
                                    value: v || 0.0,
                                    min: 0.0,
                                    max: 1.0) do |pc|
                  pc.on_event 'ParamChanged', ->(e) do
                    param = e.data_object
                    params[param.name.to_sym] = param.value
                    draw_graph
                  end
                end
              end
            end
          end
          @function_grapher.canvas = r.canvas(width: 600, height: 600, sticky: 'nwes', x_flex: 1, y_flex: 1) do |cv|
            cv.on_mouse_wheel ->(e) { mousewheel(e) }
            cv.on_mouse_drag ->(e) { mouse_drag(e) }, button: 1
            cv.on_mouse_up ->(e) { mouse_up(e) }, button: 1
          end
        end
        f.row do |r|
          r.hframe(sticky: "e") do |hf|
            hf.label(text: "Zoom: ")
            @zoom_w = hf.entry(value: @function_grapher.zoom, width: 6) do |en|
              en.on_change ->(e) { @function_grapher.zoom = e.sender.f_value }
            end
            hf.label(text: "Left X: ")
            @x_orig_w = hf.entry(value: @function_grapher.x_orig, width: 6) do |en|
              en.on_change ->(e) { @function_grapher.x_orig = e.sender.f_value }
            end
            hf.label(text: "Bottom Y: ")
            @y_orig_w = hf.entry(value: @function_grapher.y_orig, width: 6) do |en|
              en.on_change ->(e) { @function_grapher.y_orig = e.sender.f_value }
            end
            hf.button(text: "Origin!") do |b|
              b.on_click ->(e) { @function_grapher.center_function(0, 0); draw_graph }
            end
            hf.button(text: "Graph!", default: "active", on_click: :draw_graph)
          end
        end
      end
    end
  end

  def component_did_build
    @function_grapher.canvas = @function_grapher.canvas.native_item
  end

  def draw_graph(e = nil)
    fe = FunctionEvaluator.new(@function)
    @zoom_w.value = @function_grapher.zoom
    @x_orig_w.value = @function_grapher.x_orig
    @y_orig_w.value = @function_grapher.y_orig
    @function_grapher.graph(fe, params)
  end

  def update_params(e = nil)
    fe = FunctionEvaluator.new(@function)
    puts("Found params: #{fe.find_params}")
    puts ("Current params: #{params}")
    new_params = fe.find_params - [:x]
    old_params = params.keys
    (old_params - new_params).each { |p| params.delete(p) }
    (new_params - old_params).each { |p| params[p] = 0.0 }
    puts ("New params: #{params}")
    regenerate
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
