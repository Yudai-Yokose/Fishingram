class Post < ApplicationRecord
  validates :content, {presence: true}
  validates :content, {length: {maximum: 140}}
  validates :user_id, {presence: true}
  validates :image_name, presence: { message: "をアップロードしてください" }

  def user
    return User.find_by(id: self.user_id)
  end
end
