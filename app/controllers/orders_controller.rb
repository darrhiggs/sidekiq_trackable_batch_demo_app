class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def random
    order = gen_random_order
    if order.save
      flash.notice = "Order #{order.id} has been created, and is being processed"
      redirect_to action: 'index'
    else
      flash.alert = "There was a problem, please try again"
      redirect_to action: 'new'
    end
  end

  def index
    @orders = Order.includes(:products).last(10).reverse
  end

  private
  def gen_random_order
    qty = rand(5..Product.count)
    products = Product.limit(qty).order('RANDOM()')
    Order.new(products: products)
  end
end
