user = User.find(32)

100.times do
  Catch.create!(
    user: user,
    tide: Catch.tides.keys.sample,
    tide_level: Catch.tide_levels.keys.sample,
    range: Catch.ranges.keys.sample,
    size: Catch.sizes.keys.sample,
    created_at: Faker::Time.between(from: 2.years.ago, to: Time.now),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Time.now),
    memo: Faker::Lorem.sentence(word_count: 10, supplemental: true)
  )
end

puts "100 catch records have been created for first user!"

100.times do
  Diary.create!(
    user: user,
    weather: Diary.weathers.keys.sample,
    catch_count: Diary.catch_counts.keys.sample,
    time_of_day: Diary.time_of_days.keys.sample,
    temperature: Diary.temperatures.keys.sample,
    content: Faker::Lorem.paragraphs(number: 5).join("\n\n"),
    diary_date: Faker::Date.between(from: 2.year.ago, to: Date.today),
    created_at: Faker::Time.between(from: 2.years.ago, to: Time.now),
    updated_at: Faker::Time.between(from: 2.years.ago, to: Time.now)
  )
end

puts "100 diary records have been created for first user!"
