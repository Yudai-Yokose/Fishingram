require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:catch_record) { create(:catch, user: user) }
  let(:comment) { build(:comment, user: user, catch: catch_record) }

  describe 'バリデーション' do
    it '内容、ユーザー、および釣果があれば有効であること' do
      expect(comment).to be_valid
    end

    it '内容がない場合は無効であること' do
      comment.content = nil
      expect(comment).to_not be_valid
    end

    it 'ユーザーがない場合は無効であること' do
      comment.user = nil
      expect(comment).to_not be_valid
    end

    it '釣果がない場合は無効であること' do
      comment.catch = nil
      expect(comment).to_not be_valid
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
