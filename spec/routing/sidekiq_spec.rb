require 'rails_helper'

RSpec.describe "Sidekiq route", type: :routing do
  include Helpers
  
  describe "GET #index" do
    it "can't be rooted by default" do
      expect(:get => sidekiq_web_path).not_to be_routable
    end
  end

end
