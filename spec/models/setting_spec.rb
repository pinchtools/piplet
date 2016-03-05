# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  var        :string           not null
#  value      :text
#  thing_id   :integer
#  thing_type :string(30)
#  created_at :datetime
#  updated_at :datetime
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
