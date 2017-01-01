# == Schema Information
#
# Table name: site_signatures
#
#  id          :integer          not null, primary key
#  public_key  :text
#  private_key :text
#  site_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_site_signatures_on_site_id  (site_id)
#
# Foreign Keys
#
#  fk_rails_05c47f1cda  (site_id => sites.id)
#

class SiteSignature < ApplicationRecord
  belongs_to :site
end
