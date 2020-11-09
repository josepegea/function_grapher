require 'pry'
require 'tk'
require 'tkextlib/tile'

require_relative './function_evaluator'
require_relative './function_grapher'

def graph
  fe = FunctionEvaluator.new($function)
  fg = FunctionGrapher.new($canvas, $zoom, $x_orig, $y_orig)
  fg.graph(fe)
  emit_custom_event
end

# Main window
root = TkRoot.new { title "Graph!!" }

# Inside window frame and layout
content = Tk::Tile::Frame.new(root) {padding "3 3 12 12"}.grid(sticky: 'nsew')
TkGrid.columnconfigure root, 0, weight: 1
TkGrid.rowconfigure root, 0, weight: 1

# Left bar
left_bar = Tk::Tile::Frame.new(content) {padding "0"}.grid(column: 1, row: 1, rowspan: 2, sticky: 'nsew')

Tk::Tile::Label.new(left_bar) {text 'Function:'}.grid(column: 1, row: 1)
$function = TkVariable.new("100 * Math.sin(x*0.05)")
function_t = Tk::Tile::Entry.new(left_bar) {width 20; textvariable $function}.grid(column: 1, row: 2)

$text = TkText.new(left_bar) { width 20; height 20 }.grid(column: 1, row: 3)
$text.bind("<Modified>", ->(x,y) { puts(x,y) }, '%x %y')


TkGrid.columnconfigure left_bar, 1, weight: 1
TkGrid.rowconfigure left_bar, 1, weight: 0
TkGrid.rowconfigure left_bar, 2, weight: 0

# Big canvas
$canvas = TkCanvas.new(content) { width 200; height 200 }
$canvas.grid sticky: 'nwes', column: 2, row: 1

# Button bar below canvas
buttons = Tk::Tile::Frame.new(content) {padding "0"}.grid( sticky: 'nsew').grid(:column => 2, :row => 2)

$zoom = TkVariable.new(1)
zoom_l = Tk::Tile::Label.new(buttons) {text 'Zoom:'}.grid(column: 1, row: 1)
zoom_t = Tk::Tile::Entry.new(buttons) {width 4; textvariable $zoom}.grid(column: 2, :row => 1)

$x_orig = TkVariable.new(-100)
x_orig_l = Tk::Tile::Label.new(buttons) {text 'Left X:'}.grid(column: 3, row: 1)
x_orig_t = Tk::Tile::Entry.new(buttons) {width 4; textvariable $x_orig}.grid(column: 4, :row => 1)

$y_orig = TkVariable.new(-100)
y_orig_l = Tk::Tile::Label.new(buttons) {text 'Bottom Y:'}.grid(column: 5, row: 1)
y_orig_t = Tk::Tile::Entry.new(buttons) {width 4; textvariable $y_orig}.grid(column: 6, row: 1, sticky: 'w')

graph_button = Tk::Tile::Button.new(buttons) { text "Graph!"; default "active"; command { graph } }.grid(column: 7, row: 1, sticky: 'es')

TkGrid.columnconfigure buttons, 1, weight: 0
TkGrid.columnconfigure buttons, 2, weight: 0
TkGrid.columnconfigure buttons, 3, weight: 0
TkGrid.columnconfigure buttons, 4, weight: 0
TkGrid.columnconfigure buttons, 5, weight: 0
TkGrid.columnconfigure buttons, 6, weight: 0
TkGrid.columnconfigure buttons, 6, weight: 1
TkGrid.rowconfigure buttons, 1, weight: 1

# Top layour
TkGrid.columnconfigure content, 1, weight: 0
TkGrid.columnconfigure content, 2, weight: 1
TkGrid.rowconfigure content, 1, weight: 1
TkGrid.rowconfigure content, 2, weight: 0

# Mouse events

def mousewheel
  proc do |d|
    z = $zoom.value.to_f
    z = d > 0 ? z * 1.1 : z * 0.9
    $zoom.value = (z).to_s
    graph
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
    x_orig = $x_orig.value.to_f
    y_orig = $y_orig.value.to_f
    x_orig += (old_x - x)
    y_orig += (y - old_y)  # y coords are reversed
    $x_orig.value = x_orig
    $y_orig.value = y_orig
    graph
  end
end

def mouse_up
  proc do |x, y|
    mouse_drag.call(x, y)
    $mouse_x = nil
    $mouse_y = nil
  end
end

$canvas.bind("MouseWheel", mousewheel, '%D')
$canvas.bind("B1-Motion", mouse_drag, '%x %y')
$canvas.bind("B1-ButtonRelease", mouse_up, '%x %y')

# Virtual events
$canvas.bind("<FunctionUpdated>", proc { |e| puts "FunctionUpdated #{e}" }, '%D')

def emit_custom_event
  Tk.event_generate($canvas, "<FunctionUpdated>")
end

# Turn everything on!!
Tk.mainloop


