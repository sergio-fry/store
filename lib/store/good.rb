module Store
  class Good
    attr_reader :cost, :device

    def initialize(model:, cost:, device:)
      @model = model
      @cost = cost
      @device = device
    end

    def model = @model.gsub(device, "").strip
  end
end
