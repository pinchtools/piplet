require 'rails_helper'
require Rails.root.join('lib/json_web_token')

RSpec.describe Users::GenerateCsrfTokenService do
  let(:user) {create(:user)}
  subject {described_class.new(user)}

  it 'returns a jwt containing the user id' do
    jwt = JsonWebToken.decode(subject.call)
    expect(jwt).to include("user" => user.id)
  end
end
