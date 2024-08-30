class Catch < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  enum tide: { "大潮": 0, "中潮": 1, "小潮": 2, "若潮": 3, "長潮": 4 }
  enum tide_level: { "満潮前後": 0, "上げ1~2部": 1, "上げ3~4部": 2, "上げ5~6部": 3, "上げ7~8部": 4, "干潮前後": 5, "下げ1~2部": 6, "下げ3~4部": 7, "下げ5~6部": 8, "下げ7~8部": 9 }
  enum range: { "トップ": 0, "表層": 1, "中層": 2, "ボトム付近": 3 }
  enum size: { "20cm以下": 0, "20~30cm": 1, "30~40cm": 2, "40~50cm": 3, "50~60cm": 4, "70~80cm": 5, "80~90cm": 6, "90cm以上": 7 }
end