class FunctionGrapher
  attr_accessor :canvas
  attr_accessor :x_orig, :y_orig, :zoom
  
  def initialize(canvas = nil, zoom = 1.0, x_orig = -100.0, y_orig = -100.0)
    @canvas = canvas
    @zoom = zoom
    @x_orig = x_orig
    @y_orig = y_orig
  end

  # Drawing functions

  def draw_axes
    TkcLine.new(@canvas, f2c_x(0), 0, f2c_x(0), @canvas.winfo_height, fill: 'blue')
    TkcLine.new(@canvas, 0, f2c_y(0), @canvas.winfo_width, f2c_y(0), fill: 'blue')
  end

  def graph(function, vars = {})
    @canvas.delete('all')
    draw_axes
    points = []
    (0..@canvas.winfo_width).each do |cx|
      x = c2f_x(cx)
      y = function.evaluate(vars.merge x: x)
      next if y.is_a?(Complex)
      points += [f2c_x(x), f2c_y(y)]
    end
    TkcLine.new(@canvas, *points)
  end

  # Zooming and panning

  def zoom_by(factor, options = {})
    old_center_x = old_center_y = nil
    if options[:keep_center]
      old_center_x = min_x + (max_x - min_x) / 2.0
      old_center_y = min_y + (max_y - min_y) / 2.0
    end
    @zoom *= factor
    center_function(old_center_x, old_center_y) if old_center_x
  end

  def move_canvas(dx, dy)
    move_function(c2f_x(dx) - c2f_x(0), c2f_y(dy) - c2f_y(0))
  end

  def move_function(dx, dy)
    @x_orig += dx
    @y_orig += dy
  end

  def center_canvas(x, y)
    center_function(c2f_x(x), c2f_y(y))
  end

  def center_function(x, y)
    @x_orig = x - ((max_x - min_x) / 2)
    @y_orig = y - ((max_y - min_y) / 2)
  end

  # Get function bounds for current canvas, position and zoom

  def min_x
    c2f_x(0)
  end

  def max_x
    c2f_x(@canvas.winfo_width)
  end

  def min_y
    c2f_y(@canvas.winfo_height)
  end

  def max_y
    c2f_y(0)
  end

  # Convert function coordinates to canvas coordinates

  def f2c_x(x)
    (x - x_orig) * zoom
  end

  def f2c_y(y)
    @canvas.winfo_height - ((y - y_orig) * zoom)
  end

  # Convert canvas coordinates to function coordinates

  def c2f_x(x)
    x / zoom + x_orig
  end

  def c2f_y(y)
    (@canvas.winfo_height - y) / zoom + y_orig
  end
end
