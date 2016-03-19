RSpec.shared_examples "user loggable" do

  
  it 'should delayed a normal log' do
    should_delayed_method  do
      subject.log(:generic)
    end
  end

  
  it 'should delayed an important log' do
    should_delayed_method  do
      subject.log(:created)
    end
  end

  
  it 'should delayed a sensitive log' do
    should_delayed_method  do
      subject.log(:admin)
    end
  end

  context 'create ' do
    before {
      allow(subject).to receive(:id) {1}
    }

    
    it 'should be able to save a notice log' do
      should_save_log do
        subject.log(:generic)
      end
    end
    
    
    it 'should be able to save an important log' do
      should_save_log do
        subject.log(:created)
      end
    end
    
    
    it 'should be able to save a restricted log' do
      should_save_log do
        subject.log(:admin)
      end
    end
  
  end
  
  private
  
  
  def should_delayed_method
    expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(0)

    yield

    expect(Sidekiq::Extensions::DelayedClass.jobs.size).to eq(1)
  end
  
  
  def should_save_log
    expect(UserLog).to receive(:delay).at_least(:once).and_return(UserLog)

    expect(yield.valid?).to be true
  end
  
end