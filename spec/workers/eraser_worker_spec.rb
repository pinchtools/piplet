require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe EraserWorker do

  describe "perform" do
    before { Sidekiq::Testing.fake! }
    
    it "add a task in cron queue" do
      expect(EraserWorker.jobs).to be_empty
      
      expect {
        EraserWorker.perform_async
      }.to change(EraserWorker.jobs, :size).by(1)
      
      
      expect(EraserWorker.jobs.first).to include('queue' => 'crons')
      
    end
    
    it "remove users in attempt of deletion" do
      expect(User.deletion_ready).to be_empty
      
      user = create(:user_to_be_deleted)
      
      expect(User.deletion_ready).to be_present
      
      EraserWorker.new.perform
      
      expect(User.where(:id => user.id)).to be_empty
      
      expect(User.deletion_ready).to be_empty
    end
    
    it "doesn't remove future deletion" do
      expect(User.deletion_ready).to be_empty
      
      user = create(:user_to_be_deleted)
      
      user.update_column(:to_be_deleted_at, 1.days.from_now)
      
      expect(User.deletion_ready).to be_empty
      
      EraserWorker.new.perform
      
      expect(User.where(:id => user.id)).to be_present
        
      expect(User.deletion_ready).to be_empty
    end
    
    it "ignore not to be deleted user" do
      expect(User.deletion_ready).to be_empty
      
      user = create(:user)
      
      expect(user.to_be_deleted).to be_falsy
      expect(user.to_be_deleted_at).to be_nil
            
      
      expect(User.deletion_ready).to be_empty
      
      EraserWorker.new.perform
      
      expect(User.where(:id => user.id)).to be_present
        
      expect(User.deletion_ready).to be_empty
    end
    
  end

end