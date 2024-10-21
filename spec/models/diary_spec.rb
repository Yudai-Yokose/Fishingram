require 'rails_helper'

RSpec.describe Diary, type: :model do
  let(:user) { create(:user) }
  let(:diary) { build(:diary, user: user) }

  describe 'バリデーション' do
    it '適切なdiaryインスタンスであれば有効であること' do
      expect(diary).to be_valid
    end

    it 'ユーザーがない場合は無効であること' do
      diary.user = nil
      expect(diary).to_not be_valid
    end

    it '天候がない場合は無効であること' do
      diary.weather = nil
      expect(diary).to_not be_valid
    end

    it '釣果数がない場合は無効であること' do
      diary.catch_count = nil
      expect(diary).to_not be_valid
    end

    it '時間帯がない場合は無効であること' do
      diary.time_of_day = nil
      expect(diary).to_not be_valid
    end

    it '気温がない場合は無効であること' do
      diary.temperature = nil
      expect(diary).to_not be_valid
    end
  end

  describe '関連付け' do
    it 'ユーザーに属すること' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it '画像を多く持つこと' do
      expect(diary.images).to respond_to(:attach)
    end
  end

  describe '列挙型' do
    it '有効な天候の列挙型を持つこと' do
      expect(diary.weather).to be_present
    end

    it '有効な釣果数の列挙型を持つこと' do
      expect(diary.catch_count).to be_present
    end

    it '有効な時間帯の列挙型を持つこと' do
      expect(diary.time_of_day).to be_present
    end

    it '有効な気温の列挙型を持つこと' do
      expect(diary.temperature).to be_present
    end
  end
end
