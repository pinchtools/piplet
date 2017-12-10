require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:conversation_id) }
  it { should validate_presence_of(:slug) }

  describe '#slug' do
    subject { create(:post) }

    it { expect(subject.slug).to be_present }

    context 'message is long' do
      let(:message) { 100.times.map(&:to_s).join }
      subject { create(:post, message: message) }
      before { expect(subject.message).to eq(message) }

      it { expect(subject.slug).to be_present }
      it { expect(subject.slug.length).to be < subject.message.length }
    end

    context 'message with same content exists' do
      let(:message) { 100.times.map(&:to_s).join }
      let!(:existing_post) { create(:post, message: message) }
      subject { create(:post, message: message) }

      it { expect(subject.slug).not_to eq(existing_post.slug) }
    end
  end
end
