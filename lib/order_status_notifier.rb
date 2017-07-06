class OrderStatusNotifier
  def on_update(status, order_id:)
    ActionCable.server.broadcast(
      "order_fulfilment_#{order_id}",
      status.merge!({timestamp: Time.now.to_f})
    )
  end
end
