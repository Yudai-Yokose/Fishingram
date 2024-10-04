# spec/models/diary_spec.rb
require 'rails_helper'

RSpec.describe Diary, type: :model do
  let(:user) { create(:user) }
  let(:diary) { build(:diary, user: user) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(diary).to be_valid
    end

    it 'is invalid without a user' do
      diary.user = nil
      expect(diary).to_not be_valid
    end

    it 'is invalid without weather' do
      diary.weather = nil
      expect(diary).to_not be_valid
    end

    it 'is invalid without catch_count' do
      diary.catch_count = nil
      expect(diary).to_not be_valid
    end

    it 'is invalid without time_of_day' do
      diary.time_of_day = nil
      expect(diary).to_not be_valid
    end

    it 'is invalid without temperature' do
      diary.temperature = nil
      expect(diary).to_not be_valid
    end
  end

  describe 'Associations' do
    it 'belongs to user' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'has many attached images' do
      expect(diary.images).to respond_to(:attach)
    end
  end

  describe 'Enums' do
    it 'has a valid weather enum' do
      expect(diary.weather).to be_present
    end

    it 'has a valid catch_count enum' do
      expect(diary.catch_count).to be_present
    end

    it 'has a valid time_of_day enum' do
      expect(diary.time_of_day).to be_present
    end

    it 'has a valid temperature enum' do
      expect(diary.temperature).to be_present
    end
  end
end
