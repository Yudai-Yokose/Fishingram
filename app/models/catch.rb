class Catch < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many_attached :images
  validates :tide, presence: true
  validates :tide_level, presence: true
  validates :range, presence: true
  validates :size, presence: true

  enum :tide,       { "大潮" => 0, "中潮" => 1, "小潮" => 2, "若潮" => 3, "長潮" => 4 }
  enum :tide_level, { "満潮前後" => 0, "上げ前半" => 1, "上げ後半" => 2, "干潮前後" => 3, "下げ前半" => 4, "下げ後半" => 5 }
  enum :range,      { "トップ" => 0, "表層" => 1, "中層" => 2, "ボトム" => 3 }
  enum :size,       { "20cm以下" => 0, "20~30cm" => 1, "30~40cm" => 2, "40~50cm" => 3, "50~60cm" => 4, "60~70cm" => 5, "70~80cm" => 6, "80~90cm" => 7, "90cm以上" => 8 }

  def self.ransackable_attributes(auth_object = nil)
    [ "memo", "range", "size", "tide", "tide_level" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "comments" ]
  end

  ransacker :tide, formatter: proc { |v| tides[v] } do |parent|
    parent.table[:tide]
  end

  ransacker :tide_level, formatter: proc { |v| tide_levels[v] } do |parent|
    parent.table[:tide_level]
  end

  ransacker :range, formatter: proc { |v| ranges[v] } do |parent|
    parent.table[:range]
  end

  ransacker :size, formatter: proc { |v| sizes[v] } do |parent|
    parent.table[:size]
  end
end
