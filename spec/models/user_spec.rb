require 'rails_helper'
require 'open-uri'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'バリデーション' do
    it 'ユーザー名とメールアドレスがあれば有効であること' do
      expect(user).to be_valid
    end

    it 'ユーザー名がない場合は無効であること' do
      user.username = nil
      expect(user).to_not be_valid
    end

    it '一意のユーザー名がない場合は無効であること' do
      create(:user, username: user.username)
      expect(user).to_not be_valid
    end

    it 'メールアドレスがない場合は無効であること' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it '重複したメールアドレスがある場合は無効であること' do
      create(:user, email: user.email)
      expect(user).to_not be_valid
    end
  end

  describe '関連付け' do
    it '多くのいいねを持つこと' do
      assoc = described_class.reflect_on_association(:likes)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end

    it 'いいねを通じて多くの好きな釣果を持つこと' do
      assoc = described_class.reflect_on_association(:liked_catches)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:through]).to eq :likes
      expect(assoc.options[:source]).to eq :catch
    end

    it '多くのコメントを持つこと' do
      assoc = described_class.reflect_on_association(:comments)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end

    it '多くの釣果を持つこと' do
      assoc = described_class.reflect_on_association(:catches)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end

    it '多くの日記を持つこと' do
      assoc = described_class.reflect_on_association(:diaries)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end
  end

  describe 'プロフィール画像' do
    it '画像がアップロードされていない場合はデフォルトのプロフィール画像を添付すること' do
      user.save
      expect(user.profile_image).to be_attached
    end

    it '画像がアップロードされている場合はデフォルトのプロフィール画像を添付しないこと' do
      user.profile_image.attach(
        io: File.open(Rails.root.join('public', 'icon.png')),
        filename: 'icon.png',
        content_type: 'image/png'
      )
      user.save
      expect(user.profile_image.filename.to_s).to eq('icon.png')
    end
  end

  describe 'from_omniauthメソッド' do
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

    it 'Google認証からユーザーを作成すること' do
      user = User.from_omniauth(auth)
      expect(user).to be_valid
      expect(user.username).to eq('Sample User')
      expect(user.email).to eq('sampleuser@example.com')
    end

    it 'Google認証からプロフィール画像を添付すること' do
      user = User.from_omniauth(auth)
      expect(user.profile_image).to be_attached
    end
  end
end
