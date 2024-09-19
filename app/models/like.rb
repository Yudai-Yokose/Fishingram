class Like < ApplicationRecord
  belongs_to :user
  belongs_to :catch

  validates :user_id, uniqueness: { scope: :catch_id }
end
