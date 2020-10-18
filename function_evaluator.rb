class FunctionEvaluator
  attr_accessor :expression

  def initialize(expr)
    compile_expression(expr)
  end

  def compile_expression(expr)
    @expression = expr
  end

  def evaluate(vars = {})
    begin
      eval(expression, M.binding_from_hash(vars))
    rescue
      binding.pry
      raise $!
    end
  end
end

# See https://stackoverflow.com/questions/18552891/how-to-dynamically-create-a-local-variable

module M
  def self.clean_binding
    binding
  end

  def self.binding_from_hash(**vars)
    b = self.clean_binding
    vars.each do |k, v|
      b.local_variable_set k.to_sym, v
    end
    return b
  end
end
