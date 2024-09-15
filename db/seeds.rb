user = User.find(17)

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
