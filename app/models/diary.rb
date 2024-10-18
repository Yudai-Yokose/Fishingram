class Diary < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  validates :weather, presence: true
  validates :catch_count, presence: true
  validates :time_of_day, presence: true
  validates :temperature, presence: true

  enum :weather,     { "晴れ": 0, "曇り": 1, "雨": 2, "雪": 3, "強風": 4 }
  enum :catch_count, { "坊主": 0, "1匹": 1, "2匹": 2, "3匹": 3, "4匹": 4, "5匹": 5, "6~10匹": 6, "爆釣": 7, "至高の1匹": 8 }
  enum :time_of_day, { "朝まづめ": 0, "夕まづめ": 1, "Day": 2, "Night": 3 }
  enum :temperature, { "氷点下": 0, "0~10℃": 1, "10~20℃": 2, "20~30℃": 3, "真夏日": 4 }

  def self.ransackable_attributes(auth_object = nil)
    [ "weather", "catch_count", "time_of_day", "temperature", "content" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  ransacker :weather, formatter: proc { |v| weathers[v] } do |parent|
    parent.table[:weather]
  end

  ransacker :catch_count, formatter: proc { |v| catch_counts[v] } do |parent|
    parent.table[:catch_count]
  end

  ransacker :time_of_day, formatter: proc { |v| time_of_days[v] } do |parent|
    parent.table[:time_of_day]
  end

  ransacker :temperature, formatter: proc { |v| temperatures[v] } do |parent|
    parent.table[:temperature]
  end
end
