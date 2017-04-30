require 'rails_helper'

RSpec.describe Users::ConcernedByFiltersService do
  subject {described_class.new(user)}

  let(:user) {build(:user)}

  it 'returns false when user is not impacted by any filters' do
    expect(subject.call).to be_falsy
  end


  shared_examples 'concerned by filter' do
    it { expect(subject.call).to be_truthy }

    it 'adds an error into user record' do
      subject.call
      expect(user.errors).to have_key(:base)
    end
  end


  context 'concerned by an email filter' do
    let!(:filter) {create(:user_filter_blocked_email)}

    before do
      user.email = "aaa@#{filter.email_provider}"
    end

    include_examples 'concerned by filter'
  end

  context 'concerned by an ip address filter' do
    let!(:user_filter) {create(:user_filter_blocked_ip)}

    describe 'when creation ip match to a filter ip' do
      before do
        user.creation_ip_address = user_filter.cidr_address.to_cidr_s
      end

      include_examples 'concerned by filter'
    end

    describe 'when creation ip is contained into an ip range defined by a filter' do
      let(:ip_range) { '127.23.4.*' }
      let!(:user_filter) {create(:user_filter_blocked_ip, ip_address: ip_range)}

      before do
        user.creation_ip_address = ip_range.sub('*', '2')
      end

      include_examples 'concerned by filter'
    end
  end
end