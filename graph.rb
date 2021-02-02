#!/usr/bin/env ruby

require 'tk'
require 'tkextlib/tile'

require_relative './function_evaluator'
require_relative './function_grapher'

$function_grapher = FunctionGrapher.new
$function_grapher.zoom = 1
$function_grapher.x_orig = -100
$function_grapher.y_orig = -100

def draw_graph
  fe = FunctionEvaluator.new($function)
  $function_grapher.graph(fe)
end

# Main window
root = TkRoot.new { title "Graph!!" }

# Inside window frame and layout
content = Tk::Tile::Frame.new(root) { padding "8" }
            .grid(sticky: 'nsew')

TkGrid.columnconfigure root, 0, weight: 1
TkGrid.rowconfigure root, 0, weight: 1

# Left bar
left_bar = Tk::Tile::Frame.new(content) { padding "0" }
             .grid(column: 1, row: 1, rowspan: 2, sticky: 'nsew')

Tk::Tile::Label.new(left_bar) { text 'Function:' }
  .grid(column: 1, row: 1, sticky: 'w')
$function = TkVariable.new("100 * Math.sin(x*0.05)")
function_t = Tk::Tile::Entry.new(left_bar) { width 20; textvariable $function }
               .grid(column: 1, row: 2)

TkGrid.columnconfigure left_bar, 1, weight: 1
TkGrid.rowconfigure left_bar, 1, weight: 0
TkGrid.rowconfigure left_bar, 2, weight: 0

# Big canvas
$canvas = TkCanvas.new(content) { width 200; height 200 }
$canvas.grid sticky: 'nwes', column: 2, row: 1
$function_grapher.canvas = $canvas

# Button bar below canvas
buttons = Tk::Tile::Frame.new(content) { padding "0" }
            .grid( sticky: 'nsew', column: 2, row: 2)

origin_button = Tk::Tile::Button.new(buttons) do
  text "Origin!"
  command { $function_grapher.center_function(0, 0); draw_graph }
end.grid(column: 1, row: 1, sticky: 'es')

graph_button = Tk::Tile::Button.new(buttons) do
  text "Graph!"
  default "active"
  command { draw_graph }
end.grid(column: 2, row: 1, sticky: 'es')

TkGrid.columnconfigure buttons, 1, weight: 1
TkGrid.columnconfigure buttons, 2, weight: 0
TkGrid.rowconfigure buttons, 1, weight: 1

# Top layout

TkGrid.columnconfigure content, 1, weight: 0
TkGrid.columnconfigure content, 2, weight: 1
TkGrid.rowconfigure content, 1, weight: 1
TkGrid.rowconfigure content, 2, weight: 0

# Mouse events

def mousewheel
  proc do |d|
    $function_grapher.zoom_by(d > 0 ? 1.1 : 0.9, keep_center: true)
    draw_graph
  end
end

$mouse_x = nil
$mouse_y = nil

def mouse_down
  proc do |x, y|
    $mouse_x = x
    $mouse_y = y
  end
end

def mouse_drag
  proc do |x, y|
    old_x = $mouse_x
    old_y = $mouse_y
    $mouse_x = x
    $mouse_y = y
    return unless old_x && old_y
    $function_grapher.move_canvas(old_x - x, old_y - y)
    draw_graph
  end
end

def mouse_up
  proc do |x, y|
    # mouse_drag.call(x, y)
    $mouse_x = nil
    $mouse_y = nil
  end
end

$canvas.bind("MouseWheel", mousewheel, '%D')
$canvas.bind("B1-Motion", mouse_drag, '%x %y')
$canvas.bind("B1-ButtonRelease", mouse_up, '%x %y')

# Turn everything on!!
Tk.mainloop
