class User < ApplicationRecord
  require "open-uri"
  has_many :catches, dependent: :destroy
  has_many :diaries, dependent: :destroy
  validates :username, presence: true, uniqueness: true
  has_one_attached :profile_image
  after_create :set_default_profile_image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      if auth.info.image.present?
        user.profile_image.attach(io: URI.open(auth.info.image), filename: "profile_image.jpg", content_type: "image/jpeg")
      end
    end
  end

  private

  def set_default_profile_image
    unless profile_image.attached?
      default_image_path = Rails.root.join("public/default_profile_image.png")
      profile_image.attach(io: File.open(default_image_path), filename: "default_profile_image.png", content_type: "image/png")
    end
  end
end
