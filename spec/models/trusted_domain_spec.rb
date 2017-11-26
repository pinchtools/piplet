require 'rails_helper'

RSpec.describe TrustedDomain, type: :model do
  it { should validate_presence_of(:domain) }
  it { should validate_presence_of(:site_id) }

  it { should validate_uniqueness_of(:domain).scoped_to(:site_id)}

  describe '.search_by_domain' do
    let(:domain) { 'plop.example.com' }
    subject { create(:trusted_domain, domain: domain) }

    context 'an entry with the exact match exists' do
      it {
        expect(described_class.search_by_domain(domain)).to include(subject)
      }
    end

    context 'an entry with no sub-domain defined exists' do
      let(:domain) { 'example.com' }
      let(:search) { 'wiz.example.com' }
      it {
        expect(described_class.search_by_domain(domain)).to include(subject)
      }
    end

    context 'a trusted domain with a different sub-domain is defined' do
      let(:domain) { 'paf.example.com' }
      let(:search) { 'wiz.example.com' }
      it {
        expect(described_class.search_by_domain(search)).not_to include(subject)
      }
    end
  end
end
