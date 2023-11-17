module Store
  class Good
    attr_reader :id, :cost, :device

    def initialize(id: nil, model:, cost:, device:)
      @id = id
      @model = model
      @cost = cost
      @device = device
    end

    def model = @model.gsub(device, "").strip

    def new? = @id.nil?
  end
end
