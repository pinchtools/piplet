class TrustedDomain < ApplicationRecord
  validates :domain, presence:true
  validates :site_id, presence:true
  validates :domain, uniqueness: {scope: :site_id}

  belongs_to :site

  def self.search_by_domain(domain)
    domain_without_sub = domain.sub(/\A[^\.]+\.(\w+\.[^\.]+)\z/,'\1')
    self.where(domain: [domain, domain_without_sub].uniq)
    # self.where("domain = ?","(^|\/)#{domain}").or()
  end
end

# == Schema Information
#
# Table name: trusted_domains
#
#  id         :integer          not null, primary key
#  domain     :string
#  site_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_trusted_domains_on_site_id  (site_id)
#
