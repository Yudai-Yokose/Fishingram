require 'rails_helper'

RSpec.describe Catch, type: :model do
  let(:user) { create(:user) }
  let(:catch_record) { build(:catch, user: user) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(catch_record).to be_valid
    end

    it 'is invalid without a user' do
      catch_record.user = nil
      expect(catch_record).to_not be_valid
    end

    it 'is invalid without a tide' do
      catch_record.tide = nil
      expect(catch_record).to_not be_valid
    end

    it 'is invalid without a tide level' do
      catch_record.tide_level = nil
      expect(catch_record).to_not be_valid
    end

    it 'is invalid without a range' do
      catch_record.range = nil
      expect(catch_record).to_not be_valid
    end

    it 'is invalid without a size' do
      catch_record.size = nil
      expect(catch_record).to_not be_valid
    end
  end

  describe 'Associations' do
    it 'has many likes' do
      assoc = described_class.reflect_on_association(:likes)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end

    it 'has many liked_users through likes' do
      assoc = described_class.reflect_on_association(:liked_users)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:through]).to eq :likes
      expect(assoc.options[:source]).to eq :user
    end

    it 'has many comments' do
      assoc = described_class.reflect_on_association(:comments)
      expect(assoc.macro).to eq :has_many
      expect(assoc.options[:dependent]).to eq :destroy
    end
  end

  describe 'Enums' do
    it 'has a valid tide enum' do
      expect(Catch.tides.keys).to contain_exactly("大潮", "中潮", "小潮", "若潮", "長潮")
    end

    it 'has a valid tide_level enum' do
      expect(Catch.tide_levels.keys).to contain_exactly("満潮前後", "上げ前半", "上げ後半", "干潮前後", "下げ前半", "下げ後半")
    end

    it 'has a valid range enum' do
      expect(Catch.ranges.keys).to contain_exactly("トップ", "表層", "中層", "ボトム")
    end

    it 'has a valid size enum' do
      expect(Catch.sizes.keys).to contain_exactly("20cm以下", "20~30cm", "30~40cm", "40~50cm", "50~60cm", "60~70cm", "70~80cm", "80~90cm", "90cm以上")
    end
  end
end
