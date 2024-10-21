require 'rails_helper'

RSpec.describe Catch, type: :model do
  let(:user) { create(:user) }
  let(:catch_record) { build(:catch, user: user) }

  describe 'バリデーション' do
    it '適切なcatchインスタンスであれば有効であること' do
      expect(catch_record).to be_valid
    end

    it 'ユーザーがない場合は無効であること' do
      catch_record.user = nil
      expect(catch_record).to_not be_valid
    end

    it '潮がない場合は無効であること' do
      catch_record.tide = nil
      expect(catch_record).to_not be_valid
    end

    it '潮位がない場合は無効であること' do
      catch_record.tide_level = nil
      expect(catch_record).to_not be_valid
    end

    it 'レンジがない場合は無効であること' do
      catch_record.range = nil
      expect(catch_record).to_not be_valid
    end

    it 'サイズがない場合は無効であること' do
      catch_record.size = nil
      expect(catch_record).to_not be_valid
    end
  end

  describe '関連付け' do
    it '多くのいいねを持つこと' do
      assoc = described_class.reflect_on_association(:likes)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end

    it 'いいねを通じて多くのいいねしたユーザーを持つこと' do
      assoc = described_class.reflect_on_association(:liked_users)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:through]).to eq :likes
      expect(assoc.options[:source]).to eq :user
    end

    it '多くのコメントを持つこと' do
      assoc = described_class.reflect_on_association(:comments)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end
  end

  describe '列挙型' do
    it '有効な潮の列挙型を持つこと' do
      expect(Catch.tides.keys).to contain_exactly("大潮", "中潮", "小潮", "若潮", "長潮")
    end

    it '有効な潮位の列挙型を持つこと' do
      expect(Catch.tide_levels.keys).to contain_exactly("満潮前後", "上げ前半", "上げ後半", "干潮前後", "下げ前半", "下げ後半")
    end

    it '有効なレンジの列挙型を持つこと' do
      expect(Catch.ranges.keys).to contain_exactly("トップ", "表層", "中層", "ボトム")
    end

    it '有効なサイズの列挙型を持つこと' do
      expect(Catch.sizes.keys).to contain_exactly("20cm以下", "20~30cm", "30~40cm", "40~50cm", "50~60cm", "60~70cm", "70~80cm", "80~90cm", "90cm以上")
    end
  end
end
