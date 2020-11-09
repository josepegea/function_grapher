require_relative 'lib/tk_component'

class ParamComponent < TkComponent::Base
  attr_accessor :name, :value, :min, :max

  def initialize(options = {})
    super
    @name = options[:name]
    @value = options[:value]
    @min = options[:min]
    @max = options[:max]
  end

  def generate(parent_component, options = {})
    parse_component(parent_component, options) do |p|
      p.vframe do |vf|
        vf.hframe(sticky: "ew", h_weight: 1) do |hf|
          hf.label(text: "Param: " + name)
          @value_w = hf.entry(value: @value, width: 4, sticky: 'e', v_weight: 1) do |e|
            e.on_change ->(e) { @value = e.sender.f_value; update }
          end
        end
        vf.hframe(sticky: "ew", h_weight: 1) do |hf|
          hf.label(text: "Min: ")
          @min_w = hf.entry(value: @min, width: 4, sticky: 'w', v_weight: 1) do |e|
            e.on_change ->(e) { @min = e.sender.f_value; update }
          end
          @scale_w = hf.scale(orient: 'horizontal', from: @min, to: @max, h_weight: 1) do |s|
            s.on_change ->(e) { @value = e.sender.f_value; update }
          end
          hf.label(text: "Max: ")
          @max_w = hf.entry(value: @max, width: 4, sticky: 'e', v_weight: 1) do |e|
            e.on_change ->(e) { @max = e.sender.f_value; update }
          end
        end
      end
    end
  end

  def update
    @value_w.update_value(@value)
    @min_w.update_value(@min)
    @max_w.update_value(@max)
    @scale_w.from(@min)
    @scale_w.to(@max)
    @scale_w.update_value(@value)
    emit('ParamChanged')
  end
end
