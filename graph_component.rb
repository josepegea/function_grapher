require_relative 'lib/tk_component'

class GraphComponent < TkComponent::Base
  def generate(parent)
    parent.parse_component do |p|
      p.frame(padding: "3 3 12 12", sticky: 'nsew', h_weight: 1, v_weight: 1) do |f|
        f.row do |r|
          r.vframe(rowspan: 2, sticky: 'n', padding: "0") do |vf|
            vf.label(text: "Function: ")
            vf.entry(width: 20, value: "100 * Math.sin(x)", sticky: 'wns') do |e|
              e.on_change ->(e) { graph(e) }
            end
          end
          r.canvas(width: 600, height: 600, sticky: 'nwes', h_weight: 1, v_weight: 1) do |cv|
            cv.on_mouse_wheel ->(e) { mousewheel(e) }
            cv.on_mouse_drag ->(e) { mouse_drag(e) }, button: 1
            cv.on_mouse_up ->(e) { mouse_up(e) }, button: 1
          end
        end
        f.row do |r|
          r.hframe(sticky: "e") do |hf|
            hf.label(text: "Zoom: ")
            hf.entry(value: 1)
            hf.label(text: "Left X: ")
            hf.entry(value: -100)
            hf.label(text: "Bottom Y: ")
            hf.entry(value: -200)
            hf.button(text: "Graph!", default: "active") do |b|
              b.on_click ->(e) { graph(e) }
            end
          end
        end
      end
    end
  end

  def graph(event)
    puts("graph")
  end

  def mousewheel(event)
    puts("mousewheel #{event.mouse_wheel_delta}")
  end

  def mouse_drag(event)
    puts("mouse_drag #{event.mouse_x}-#{event.mouse_y}")
  end

  def mouse_up(event)
    puts("mouse_up #{event.mouse_x}-#{event.mouse_y}")
  end
end

