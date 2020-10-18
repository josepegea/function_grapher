class FunctionGrapher
  attr_accessor :function
  attr_accessor :canvas

  attr_accessor :x_orig, :y_orig, :zoom
  
  def initialize(function, canvas, zoom = 1, x_orig = -100, y_orig = -100)
    @function = function
    @canvas = canvas
    @zoom = zoom
    @x_orig = x_orig
    @y_orig = y_orig
  end

  def graph
    canvas.delete('all')
    draw_axes
    cx = 0
    max_cx = canvas.winfo_width
    while cx < max_cx do
      old_x = f_x(cx)
      old_y = function.evaluate(x: old_x)
      cx += 2
      x = f_x(cx)
      y = function.evaluate(x: x)
      TkcLine.new(canvas, c_x(old_x), c_y(old_y), c_x(x), c_y(y))
    end
  end

  def draw_axes
    TkcLine.new(canvas, c_x(0), 0, c_x(0), canvas.winfo_height)
    TkcLine.new(canvas, 0, c_y(0), canvas.winfo_width, c_y(0))
  end

  def min_x
    f_x(0)
  end

  def max_x
    f_x(canvas.winfo_width)
  end

  def min_y
    f_y(0)
  end

  def max_y
    f_y(canvas.winfo_height)
  end

  # Convert function coordinates to canvas coordinates

  def c_x(x)
    (x - x_orig) * zoom
  end

  def c_y(y)
    canvas.winfo_height - ((y - y_orig) * zoom)
  end

  # Convert canvas coordinates to function coordinates

  def f_x(x)
    x / zoom + x_orig
  end

  def f_y(y)
    y / zoom + y_orig
  end
end
