# == Schema Information
#
# Table name: user_filters
#
#  id             :integer          not null, primary key
#  email_provider :string
#  ip_address     :inet
#  blocked        :boolean
#  trusted        :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class UserFilter < ActiveRecord::Base
end
