RSpec.shared_examples "user loggable" do

  
  it 'should delayed a normal log' do
    should_delayed_method  do
      subject.log(UserLog.actions[:generic], "normal log")
    end
  end

  
  it 'should delayed an important log' do
    should_delayed_method  do
      subject.log(UserLog.actions[:created], "important log")
    end
  end

  
  it 'should delayed a sensitive log' do
    should_delayed_method  do
      subject.log(UserLog.actions[:admin], "sensitive log")
    end
  end

  
  it 'should be able to save a notice log' do
    should_save_log do
      subject.log(UserLog.actions[:generic], "normal log")
    end
  end
  
  
  it 'should be able to save an important log' do
    should_save_log do
      subject.log(UserLog.actions[:created], "important log")
    end
  end
  
  
  it 'should be able to save a restricted log' do
    should_save_log do
      subject.log(UserLog.actions[:admin], "sensitive log")
    end
  end
  
  
  private
  
  
  def should_delayed_method
    expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(0)

    yield

    expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(1)
  end
  
  
  def should_save_log
    expect(UserLog).to receive(:delay).and_return(UserLog)
    
    expect(yield.valid?).to be false
  end
  
end