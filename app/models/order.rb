class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items, dependent: :destroy

  BOX_VOLUME = 25

  after_create :fulfil

  def boxes
    volumes = products.map {|product| product[:volume]}
    packaged_seperately = volumes.reduce([]) {|m,v| v >= BOX_VOLUME ? m << v : m }
    for_boxing = volumes - packaged_seperately
    boxes_required = (for_boxing.map(&:to_f).sum / BOX_VOLUME).ceil + packaged_seperately.count
    Array.new(boxes_required) {
      OpenStruct.new(id: SecureRandom.uuid)
    }
  end

  private
  def fulfil
    Fulfilment.create(self)
  end
end
