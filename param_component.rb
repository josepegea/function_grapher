require 'tk_component'

class ParamComponent < TkComponent::Base
  attr_accessor :name, :value, :min, :max

  def initialize(options = {})
    super
    @name = options[:name]
    @value = options[:value]
    @min = options[:min]
    @max = options[:max]
  end

  def render(p, parent_component)
    p.group do |g|
      g.vframe do |vf|
        vf.hframe(sticky: "ew", x_flex: 1) do |hf|
          hf.label(text: "Param: ")
          hf.label(text: name, font: 'TkCaptionFont')
          @value_w = hf.entry(value: @value, width: 8, sticky: 'e', y_flex: 1) do |e|
            e.on_change ->(e) { @value = e.sender.f_value; update }
          end
        end
        vf.hframe(sticky: "ew", x_flex: 1) do |hf|
          @min_w = hf.entry(value: @min, font: 'TkSmallCaptionFont', width: 4, sticky: 'w', y_flex: 1) do |e|
            e.on_change ->(e) { @min = e.sender.f_value; update }
          end
          @scale_w = hf.scale(orient: 'horizontal', from: @min, to: @max, x_flex: 1) do |s|
            s.on_change ->(e) { @value = e.sender.f_value; update }
          end
          @max_w = hf.entry(value: @max, font: 'TkSmallCaptionFont', width: 4, sticky: 'e', y_flex: 1) do |e|
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
