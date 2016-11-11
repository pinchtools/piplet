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
    subject.save

    expect(subject.uid).to be_present
    expect(subject.errors).to be_empty

    subject.name += "a"

    expect{ subject.save }.not_to change{ subject.uid }
  end
end

end
