require 'open-uri'

class User < ApplicationRecord
  has_one_attached :image

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      # 外部URLの画像をActiveStorageに保存
      if auth.info.image.present?
        user.image.attach(io: URI.open(auth.info.image), filename: 'profile_image.jpg', content_type: 'image/jpeg')
      end
    end
  end

  def image_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
    else
      ActionController::Base.helpers.asset_path('default_profile_image.png')
    end
  end
end
