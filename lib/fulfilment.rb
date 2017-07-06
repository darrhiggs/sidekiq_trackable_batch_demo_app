class Fulfilment
  include Sidekiq::TrackableBatch::Persistance # access #update_status

  class << self
    def create(order)
      trackable_batch = Sidekiq::TrackableBatch.new do
        on(:update, OrderStatusNotifier, order_id: order.id)
        self.update_queue = 'priority'
        start_with('pick', 'Fulfilment#pick', products: order.products)
        .then('pack', 'Fulfilment#pack', boxes: order.boxes)
        .finally('ship', 'Fulfilment#ship', boxes: order.boxes)
        on(:complete, 'Fulfilment#fulfilment_complete', order_id: order.id)
        update_status(self, status_text: 'Order sent for picking')
      end
    end
  end

  def pick(nested_batch, products:)
    nested_batch.on(:complete, 'Fulfilment#pick_complete', status_text: 'Awaiting packing')
    nested_batch.jobs do
      products.each {|product| ProductPickerWorker.perform_async(product[:id])}
    end
  end

  def pack(nested_batch, boxes:)
    nested_batch.on(
      :complete,
      'Fulfilment#pack_complete',
      status_text: 'Packed and awaiting courier collection'
    )
    nested_batch.jobs do
      boxes.each do |box|
        ProductPackerWorker.perform_async(box.id)
      end
    end
  end

  def ship(nested_batch, boxes:)
    nested_batch.on(:complete, 'Fulfilment#ship_complete', status_text: 'Shipped')
    nested_batch.jobs do
      boxes.each do |box|
        CourierHandoverWorker.perform_in(
          SpeedyCourier.next_collection,
          box.id
        )
      end
    end
  end

  def pick_complete(status, options)
    batch = Sidekiq::Batch.new(status.bid)
    update_status(batch, options)#.symbolize_keys)
  end

  def pack_complete(status, options)
    batch = Sidekiq::Batch.new(status.bid)
    update_status(batch, options.symbolize_keys)
  end

  def ship_complete(status, options)
    batch = Sidekiq::Batch.new(status.bid)
    update_status(batch, options.symbolize_keys)
  end

  def fulfilment_complete(status, options)
    Order.find(options['order_id']).update(fulfiled: true)
  end
end
