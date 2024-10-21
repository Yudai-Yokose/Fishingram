require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:catch_record) { create(:catch, user: user) }
  let(:like) { build(:like, user: user, catch: catch_record) }

  describe 'バリデーション' do
    it 'ユーザーと釣果があれば有効であること' do
      expect(like).to be_valid
    end

    it 'ユーザーがない場合は無効であること' do
      like.user = nil
      expect(like).to_not be_valid
    end

    it '釣果がない場合は無効であること' do
      like.catch = nil
      expect(like).to_not be_valid
    end

    it '同じ釣果に対して同じユーザーIDが重複している場合は無効であること' do
      create(:like, user: user, catch: catch_record)
      expect(like).to_not be_valid
    end
  end

  describe '関連付け' do
    it 'ユーザーに属すること' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it '釣果に属すること' do
      assoc = described_class.reflect_on_association(:catch)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
