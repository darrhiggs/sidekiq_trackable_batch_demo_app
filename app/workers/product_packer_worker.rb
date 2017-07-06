class ProductPackerWorker
  include Sidekiq::Worker

  def self.max; 22; end

  def perform(box_id)
    sleep rand(self.class.max)
    update_status(value: self.class.max, status_text: "Packed box: #{box_id}")
  end
end
