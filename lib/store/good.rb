module Store
  class Good
    attr_reader :id, :cost, :device, :color
    attr_accessor :in_stock

    def initialize(model:, cost:, device:, id: nil, color: nil, in_stock: true)
      @id = id
      @model = model
      @cost = cost
      @device = device
      @color = color
      @in_stock = in_stock
    end

    def model = @model.gsub(device, "").strip

    def new? = @id.nil?
  end
end
