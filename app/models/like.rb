class Like < ApplicationRecord
  validates :user_id,{presence: true}
  validates :post_id,{presence: true}
end
