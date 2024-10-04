FactoryBot.define do
  factory :diary do
    user
    weather { "晴れ" }
    catch_count { "1匹" }
    time_of_day { "朝まづめ" }
    temperature { "10~20℃" }
  end
end
