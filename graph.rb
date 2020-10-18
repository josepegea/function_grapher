require 'pry'
require 'tk'
require 'tkextlib/tile'

require_relative './function_evaluator'
require_relative './function_grapher'

def graph
  fe = FunctionEvaluator.new($function)
  fg = FunctionGrapher.new(fe, $canvas, $zoom)
  fg.graph
end

def mousewheel
  proc do |d|
    z = $zoom.value.to_f
    z = d > 0 ? z * 1.1 : z * 0.9
    $zoom.value = (z).to_s
    graph
  end
end

# Main window
root = TkRoot.new { title "Graph!!" }

# Inside window frame and layout
content = Tk::Tile::Frame.new(root) {padding "3 3 12 12"}.grid( sticky: 'nsew')
TkGrid.columnconfigure root, 0, weight: 1
TkGrid.rowconfigure root, 0, weight: 1

Tk::Tile::Label.new(content) {text 'Function:'}.grid( :column => 1, :row => 1, :sticky => 'nw')
$function = TkVariable.new("100 * Math.sin(x)")

# function_t = TkText.new(content) {width 40; height 5; wrap "none"; textvariable $function}
# ys = Tk::Tile::Scrollbar.new(root) {orient 'vertical'; command proc{|*args| function_t.yview(*args);}}
# function_t['yscrollcommand'] = proc{|*args| ys.set(*args);}
function_t = Tk::Tile::Entry.new(content) {width 20; textvariable $function}.grid( column: 1, :row => 2, :sticky => 'wns' )

graph_button = Tk::Tile::Button.new(content) { text "Graph!"; default "active"; command { graph } }
graph_button.grid(column: 1, row: 3, sticky: 'ews')

$canvas = TkCanvas.new(content) { width 200; height 200 }
$canvas.grid sticky: 'nwes', column: 2, row: 1, rowspan: 2

$zoom = TkVariable.new(1)
zoom_l = Tk::Tile::Label.new(content) {text 'Zoom:'}.grid( :column => 2, :row => 3, :sticky => 'ws')
zoom_t = Tk::Tile::Entry.new(content) {width 4; textvariable $zoom}.grid( column: 2, :row => 3 )

$canvas.bind("MouseWheel", mousewheel, '%D')

TkGrid.columnconfigure content, 1, weight: 0
TkGrid.columnconfigure content, 2, weight: 1
TkGrid.rowconfigure content, 1, weight: 0
TkGrid.rowconfigure content, 2, weight: 1

Tk.mainloop


