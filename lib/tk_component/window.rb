module TkComponent
  class Window < Base
    def initialize(options = {})
      super
      @tk_item = Builder::TkItem.create(nil, :root, options)
    end

    def name
      "Window"
    end
  end
end
