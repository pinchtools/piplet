#
# Remove Users which deletion date expired
#
class EraserWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :crons, :retry => false
  
  def perform
    
    Rails.logger.info("Performing cron EraserWorker")
    
    User.deletion_ready.destroy_all
    
  end
end