# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  username          :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default(FALSE)
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#

require 'rails_helper'
require "shared/contexts/email_validation"
require "shared/contexts/username_validation"
require "shared/contexts/password_validation"

RSpec.describe User, type: :model do
  
  context 'load default_settings' do
    
    before(:each) do
      @section = "mysection"
      @mystring = "mystring"
      @myarray = ["a", "b"]
      @myhash = { "myprop" => "p" }
       @hash = {
         "mystring" => @mystring,
         "myarray" => @myarray,
         "myhash" => @myhash
       }
       
      Setting.create_section_settings(@section, @hash)
     end
    
    it 'should have created namespaced settings' do
      expect(Setting.get_all("#{@section}.")).to be_present
    end
    
    it 'should correctly save variables' do
      expect(Setting["#{@section}.mystring"]).to eq @mystring
      expect(Setting["#{@section}.myarray"]).to eq @myarray
      expect(Setting["#{@section}.myhash"]).to eq @myhash
    end
      
  end
  
end
