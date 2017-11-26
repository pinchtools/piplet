require 'rails_helper'

RSpec.describe Conversation, type: :model do
  it { should validate_presence_of(:identifier) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:site_id) }

  it { should validate_uniqueness_of(:identifier).case_insensitive }
end
