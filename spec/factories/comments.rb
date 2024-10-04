FactoryBot.define do
  factory :comment do
    user
    catch
    content { "This is a comment." }
  end
end
