require 'rails_helper'

RSpec.describe Site, type: :model do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:uid) }

  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_uniqueness_of(:uid).case_insensitive }

  it { should validate_length_of(:name).is_at_least(3) }

  describe 'uid' do
    subject{ build(:site) }

    it 'generates uid on creation' do
      expect{ subject.save }.to change{ subject.uid }.from(nil)
      expect(subject.uid).to be_present
    end

    it 'does not change uid when name is update' do
      expect(subject.save).to be_truthy
      expect(subject.uid).to be_present

      subject.name += "a"

      expect{ subject.save }.not_to change{ subject.uid }
      expect(subject.errors).to be_empty
    end


  end

  describe 'api_uid' do
    subject{ build(:site) }

    it 'is generated on new record' do
      expect{ subject.save }.to change{ subject.api_uid }.from(nil)
      expect(subject.api_uid).to be_present

    end

    it 'does not change on update' do
      expect(subject.save).to be_truthy
      expect(subject.api_uid).to be_present

      subject.name += "a"

      expect{ subject.save }.not_to change{ subject.api_uid }
      expect(subject.errors).to be_empty
    end

  end

  describe 'api_key' do
    subject{ build(:site) }

    it 'is generated on new record' do
      expect{ subject.save }.to change{ subject.api_key }.from(nil)
      expect(subject.api_key).to be_present
    end

    it 'does not change on update' do
      expect(subject.save).to be_truthy
      expect(subject.api_key).to be_present

      subject.name += "a"

      expect{ subject.save }.not_to change{ subject.api_key }
      expect(subject.errors).to be_empty
    end
  end

end
