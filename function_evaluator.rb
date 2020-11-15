# TODO: Use a proper parser to get params: https://github.com/whitequark/parser

class FunctionEvaluator
  attr_accessor :expression

  def initialize(expr)
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

  def find_params
    found_params = {}
    stop = false
    while (p = find_missing_params(found_params)) && !stop do
      v = find_initial_value_for_param(found_params, p)
      found_params.merge! p => v
      stop = !v # Once we don't find good param values we stop and return what we have so far
    end
    found_params.keys
  end

  private

  def find_missing_params(found_params)
    param_name = nil
    begin
      eval(expression, M.binding_from_hash(found_params))
    rescue NameError => e
      param_name = e.name
    rescue
      # Any other exception we ignore now
      param_name = nil
    end
    param_name
  end

  def find_initial_value_for_param(found_params, new_param)
    param_value = 1
    tries = 0
    found = false
    while !found && tries < 10 do
      begin
        eval(expression, M.binding_from_hash(found_params.merge(new_param => param_value)))
        found = true
      rescue ZeroDivisionError
        param_value += 1
      rescue Math::DomainError
        param_value *= -1
      rescue NameError => e
        # This should be just another param still not found
        found = true
      ensure
        tries += 1
      end
    end
    found && param_value
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
