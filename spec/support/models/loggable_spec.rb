RSpec.shared_examples "loggable" do

  describe 'log send' do
    
    before(:each) do
      subject.save
      
      Sidekiq::Extensions::DelayedClass.clear
    end
    
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

  end

  context 'create ' do
    before {
      subject.save
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
    expect(subject.logs).to receive(:delay).at_least(:once).and_return(subject.logs)

    expect(yield).to be_valid
  end
  
end