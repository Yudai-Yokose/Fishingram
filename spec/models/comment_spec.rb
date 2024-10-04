require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:catch_record) { create(:catch, user: user) }
  let(:comment) { build(:comment, user: user, catch: catch_record) }

  describe 'Validations' do
    it 'is valid with content, user, and catch' do
      expect(comment).to be_valid
    end

    it 'is invalid without content' do
      comment.content = nil
      expect(comment).to_not be_valid
    end

    it 'is invalid without a user' do
      comment.user = nil
      expect(comment).to_not be_valid
    end

    it 'is invalid without a catch' do
      comment.catch = nil
      expect(comment).to_not be_valid
    end
  end

  describe 'Associations' do
    it 'belongs to a user' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'belongs to a catch' do
      assoc = described_class.reflect_on_association(:catch)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
