class CourierHandoverWorker
  include Sidekiq::Worker

  def self.max; 10; end

  def perform(box_id)
    sleep rand(self.class.max)
    update_status(
      value: self.class.max,
      status_text: "Courier has collected box: #{box_id}"
    )
  end
end
