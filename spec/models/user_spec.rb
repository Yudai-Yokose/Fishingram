require 'rails_helper'
require 'open-uri'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'Validations' do
    it 'is valid with a username and email' do
      expect(user).to be_valid
    end

    it 'is invalid without a username' do
      user.username = nil
      expect(user).to_not be_valid
    end

    it 'is invalid without a unique username' do
      create(:user, username: user.username)
      expect(user).to_not be_valid
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'is invalid with a duplicate email' do
      create(:user, email: user.email)
      expect(user).to_not be_valid
    end
  end

  describe 'Associations' do
    it 'has many likes' do
      assoc = described_class.reflect_on_association(:likes)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end

    it 'has many liked_catches through likes' do
      assoc = described_class.reflect_on_association(:liked_catches)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:through]).to eq :likes
      expect(assoc.options[:source]).to eq :catch
    end

    it 'has many comments' do
      assoc = described_class.reflect_on_association(:comments)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end

    it 'has many catches' do
      assoc = described_class.reflect_on_association(:catches)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end

    it 'has many diaries' do
      assoc = described_class.reflect_on_association(:diaries)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end
  end

  describe 'Profile Image' do
    it 'attaches a default profile image if none is uploaded' do
      user.save
      expect(user.profile_image).to be_attached
    end

    it 'does not attach a default profile image if one is uploaded' do
      user.profile_image.attach(
        io: File.open(Rails.root.join('public', 'icon.png')),
        filename: 'icon.png',
        content_type: 'image/png'
      )
      user.save
      expect(user.profile_image.filename.to_s).to eq('icon.png')
    end
  end

  describe 'from_omniauth method' do
    let(:auth) do
      OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456789012345678901',
        info: {
          name: 'Sample User',
          email: 'sampleuser@example.com',
          image: 'https://example.com/sample_image.jpg'
        }
      })
    end

    before do
      allow(URI).to receive(:open).and_return(File.open(Rails.root.join('public', 'icon.png')))
    end

    it 'creates a user from google auth' do
      user = User.from_omniauth(auth)
      expect(user).to be_valid
      expect(user.username).to eq('Sample User')
      expect(user.email).to eq('sampleuser@example.com')
    end

    it 'attaches a profile image from google auth' do
      user = User.from_omniauth(auth)
      expect(user.profile_image).to be_attached
    end
  end
end
