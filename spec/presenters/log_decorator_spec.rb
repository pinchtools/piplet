require 'rails_helper'

describe LogPresenter do
  
  describe "message" do
    
    it 'should call for translation when it started with logs.messages' do
      log = create(:log_i18n)
      
      log_decorated = LogPresenter.new( log, nil )
      
      expect(I18n).to receive(:t).with(log.message, any_args)
      
      log_decorated.message
      
    end
  
    it 'should inject parameters to translation when messages.vars defined' do
      log = create(:log_i18n_with_vars)
      
      log_decorated = LogPresenter.new( log, nil )
      
      expect(log.message_vars).not_to be_empty
      
       expect(log_decorated.message).to eq (I18n.t(log.message, log.message_vars))
    end
    
  end
  
end
