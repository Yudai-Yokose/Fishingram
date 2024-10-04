require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:catch_record) { create(:catch, user: user) }
  let(:like) { build(:like, user: user, catch: catch_record) }

  describe 'Validations' do
    it 'is valid with a user and a catch' do
      expect(like).to be_valid
    end

    it 'is invalid without a user' do
      like.user = nil
      expect(like).to_not be_valid
    end

    it 'is invalid without a catch' do
      like.catch = nil
      expect(like).to_not be_valid
    end

    it 'is invalid with a duplicate user_id for the same catch' do
      create(:like, user: user, catch: catch_record)
      expect(like).to_not be_valid
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
