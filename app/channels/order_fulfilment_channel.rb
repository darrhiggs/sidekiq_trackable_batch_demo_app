class OrderFulfilmentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "order_fulfilment_#{params[:order_id]}"
  end
end
