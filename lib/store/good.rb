module Store
  class Good
    attr_reader :id, :cost, :device, :color

    def initialize(id: nil, model:, cost:, device:, color: nil)
      @id = id
      @model = model
      @cost = cost
      @device = device
      @color = color
    end

    def model = @model.gsub(device, "").strip

    def new? = @id.nil?
  end
end
