class ProductPickerWorker
  include Sidekiq::Worker

  def self.max; 35; end

  def perform(product_id)
    sleep rand(self.class.max)
    update_status(
      value: self.class.max,
      status_text: "Picked #{Product.find(product_id).title}"
    )
  end
end
