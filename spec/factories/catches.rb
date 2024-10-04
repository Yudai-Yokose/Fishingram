FactoryBot.define do
  factory :catch do
    user
    tide { "大潮" }
    tide_level { "満潮前後" }
    range { "表層" }
    size { "20cm以下" }
    images { [] }
  end
end
