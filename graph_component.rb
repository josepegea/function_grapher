require_relative 'lib/tk_component'

class GraphComponent < TkComponent::Base
  def generate(parent)
    parent.parse_component do |p|
      p.frame(padding: "3 3 12 12", sticky: 'nsew', h_weight: 1, v_weight: 1) do |f|
        f.row do |r|
          r.vframe(rowspan: 2, sticky: 'n', padding: "0") do |vf|
            vf.label(text: "Function: ")
            vf.entry(width: 20, value: "100 * Math.sin(x)", sticky: 'wns') do |e|
              e.on_change -> { graph }
            end
          end
          r.canvas(width: 600, height: 600, sticky: 'nwes', h_weight: 1, v_weight: 1) do |cv|
            cv.on_mouse_wheel ->(val) { mousewheel(val) }
            cv.on_mouse_drag ->(x, y) { mouse_drag(x, y) }, button: 1
            cv.on_mouse_up ->(x, y) { mouse_up(x, y) }, button: 1
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
              b.on_click -> { graph }
            end
          end
        end
      end
    end
  end

  def graph
    puts("graph")
  end

  def mousewheel(val)
    puts("mousewheel #{val}")
  end

  def mouse_drag(x, y)
    puts("mouse_drag #{x}-#{y}")
  end

  def mouse_up(x, y)
    puts("mouse_up #{x}-#{y}")
  end
end

