require 'rails_helper'

RSpec.describe Conversation, type: :model do
  it { should validate_presence_of(:identifier) }
  it { should validate_presence_of(:site_id) }

  it { should validate_uniqueness_of(:identifier).case_insensitive }

  describe '#title' do
    subject { create(:conversation) }

    context 'having at least one page' do
      let!(:page) { create(:page, conversation: subject) }
      it { expect(subject.title).to eq(page.title) }
    end

    context 'does not reference any page' do
      it { expect(subject.title).to be_nil }
    end
  end
end
