require 'rails_helper'
RSpec.describe User::CheckNewAccountWorker, type: :worker do
  subject { described_class.new }
  let(:user) {create(:user)}

  shared_examples 'marks suspect and logs' do
    let(:attribute) { 'email' }
    let(:value) { user.email }
    let(:similar_value) { value + 'a' }

    before do
      allow(subject).to receive(:found_similiraty).and_yield(attribute, value, similar_value ){true}
      allow(Log).to receive(:delay).and_return(Log)
    end

    it 'marks user as suspect' do
      expect{subject.perform(user.id)}.to change{user.reload.suspected_at}.from nil
    end

    it 'generates a log' do
      expect{subject.perform(user.id)}.to change{Log.count}.by_at_least(1)
    end
  end

  context 'signaled similar blocked account' do
    before do
      User.signaled_matching_with_blocked_account = true
      User.signaled_matching_with_suspected_account = false
    end

    include_examples 'marks suspect and logs'
  end

  context 'have a similar blocked username' do
    before do
      User.signaled_matching_with_blocked_account = false
      User.signaled_matching_with_suspected_account = true
    end

    include_examples 'marks suspect and logs'
  end
end