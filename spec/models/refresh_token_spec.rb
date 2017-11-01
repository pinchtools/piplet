require 'rails_helper'

RSpec.describe RefreshToken, type: :model do

  it { should belong_to(:user) }

  it { should validate_presence_of(:token) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:platform) }

  it { should validate_uniqueness_of(:token).scoped_to(:user_id) }

end
