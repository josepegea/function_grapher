class FunctionGrapher
  attr_accessor :function
  attr_accessor :canvas

  attr_accessor :x_orig, :y_orig, :x_size, :y_size
  
  def initialize(function, canvas, x_orig = -100, y_orig = -100, x_size = 200, y_size = 200)
    @function = function
    @canvas = canvas
    @x_orig = x_orig
    @y_orig = y_orig
    @x_size = x_size
    @y_size = y_size
  end

  def graph
    canvas.delete('all')
    draw_axes
    x = min_x
    while x < max_x do
      old_x = x
      old_y = function.evaluate(x: old_x)
      x += 1
      y = function.evaluate(x: x)
      TkcLine.new(canvas, c_x(old_x), c_y(old_y), c_x(x), c_y(y))
    end
  end

  def draw_axes
    TkcLine.new(canvas, c_x(0), c_y(min_y), c_x(0), c_y(max_y))
    TkcLine.new(canvas, c_x(min_x), c_y(0), c_x(max_x), c_y(0))
  end

  def min_x
    x_orig
  end

  def max_x
    x_orig + x_size
  end

  def min_y
    y_orig
  end

  def max_y
    y_orig + y_size
  end

  def c_x(x)
    (x - x_orig) * canvas.winfo_width / x_size
  end

  def c_y(y)
    canvas.winfo_height - ((y - y_orig) * canvas.winfo_height / y_size)
  end
end
