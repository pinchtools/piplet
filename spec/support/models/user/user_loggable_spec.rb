RSpec.shared_examples "user loggable" do

  #
  # TODO add test for important & restricted + test some actions can't be restricted some others must
  #
  
  it 'should delayed a notice log' do
    expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(0)
    
    subject.log_notice(UserLog.actions[:created], "Created!")
    
    expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(1)
  end
  
  it 'should be able to save a notice log' do
    
    expect(UserLog).to receive(:delay).and_return(UserLog)
    
    log = subject.log_notice(UserLog.actions[:created], "Created!")
    
    expect(log.valid?).to be false
    
  end
end
