class Diary < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  enum :weather,     { "晴れ": 0, "曇り": 1, "雨": 2, "雪": 3, "強風": 4 }
  enum :catch_count, { "坊主": 0, "1匹": 1, "2匹": 2, "3匹": 3, "4匹": 4, "5匹": 5, "6~10匹": 6, "爆釣": 7, "至高の1匹": 8 }
  enum :time_of_day, { "朝まづめ": 0, "夕まづめ": 1, "Day": 2, "Night": 3 }
  enum :temperature, { "氷点下": 0, "0~10℃": 1, "10~20℃": 2, "20~30℃": 3, "真夏日": 4 }
end
