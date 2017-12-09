require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  it { should validate_presence_of(:label) }
  it { should validate_uniqueness_of(:label).case_insensitive }
  it { should validate_uniqueness_of(:public_key).case_insensitive }
  it { should validate_uniqueness_of(:secret_key).case_insensitive }

  describe '#public_key' do
    subject{ build(:api_key, public_key: nil ) }

    it 'is generated on new record' do
      expect{ subject.save }.to change{ subject.public_key }.from(nil)
      expect(subject.public_key).to be_present
    end

    it 'does not change on update' do
      expect(subject.save).to be_truthy
      expect(subject.public_key).to be_present

      subject.label += "a"

      expect{ subject.save }.not_to change{ subject.public_key }
      expect(subject.errors).to be_empty
    end
  end

  describe '#secret_key' do
    subject{ build(:api_key, secret_key: nil) }

    it 'is generated on new record' do
      expect{ subject.save }.to change{ subject.secret_key }.from(nil)
      expect(subject.secret_key).to be_present
    end

    it 'does not change on update' do
      expect(subject.save).to be_truthy
      expect(subject.secret_key).to be_present

      subject.label += "a"

      expect{ subject.save }.not_to change{ subject.secret_key }
      expect(subject.errors).to be_empty
    end
  end

end
