require 'rails_helper'

require 'letter_avatar/avatar_helper'
require 'carrierwave/test/matchers'

RSpec.describe UserAvatar, type: :model do

  include LetterAvatar::AvatarHelper
  include CarrierWave::Test::Matchers
  
  context 'default avatar' do
    subject { create(:user_avatar_default) }

    it 'generate an avatar correctly' do
      path = File.join(Rails.root, '/public', letter_avatar_url(subject.user.username, DefaultAvatar.small_size))

      expect(File.file?(path)).to be true
    end

  end
  
  context 'upload avatar' do
    subject { create(:user_avatar_upload) }
      
      context 'valid upload' do
        let(:uploader) { AvatarUploader.new(subject, :uri) }
      
        before do
          AvatarUploader.enable_processing = true
          File.open(Rails.root.join("spec", "fixtures", "avatars", "correct.jpg")) { |f| uploader.store!(f) }
        end
      
        after do
          AvatarUploader.enable_processing = false
          uploader.remove!
        end
    
        it 'generate an avatar correctly' do
          expect(uploader.small).to have_dimensions(AvatarUploader.small_size, AvatarUploader.small_size)
          expect(uploader.medium).to have_dimensions(AvatarUploader.medium_size, AvatarUploader.medium_size)
          expect(uploader.large).to have_dimensions(AvatarUploader.large_size, AvatarUploader.large_size)
        end
      end
      
      context 'unpermitted extension upload' do
        subject { build(:user_avatar_upload) }
        let(:uploader) { AvatarUploader.new(subject, :uri) }
      

        after do
          AvatarUploader.enable_processing = false
          uploader.remove!
        end
    
        it 'should not be validate' do
          AvatarUploader.enable_processing = true
          
          path = Rails.root.join("spec", "fixtures", "avatars", "unpermitted_extension.csv")
          
          expect { File.open(path) { |f| uploader.store!(f) } }.to raise_error(CarrierWave::IntegrityError)
        end
      end

    context 'unpermitted content upload' do
      subject { build(:user_avatar_upload) }
      let(:uploader) { AvatarUploader.new(subject, :uri) }
    

      after do
        AvatarUploader.enable_processing = false
        uploader.remove!
      end
  
      it 'should not be validate' do
        AvatarUploader.enable_processing = true
        
        path = Rails.root.join("spec", "fixtures", "avatars", "unpermitted_content.png")
        
        expect { File.open(path) { |f| uploader.store!(f) } }.to raise_error(CarrierWave::ProcessingError)
      end
    end
      
  end
  
  context 'gravatar avatar' do

  end

end
