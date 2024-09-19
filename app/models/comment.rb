class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :catch

  validates :content, presence: true
end
