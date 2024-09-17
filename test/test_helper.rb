ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "open-uri"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def attach_default_profile_images
      User.all.each do |user|
        unless user.profile_image.attached?
          default_image_path = Rails.root.join("public/u1.png")
          profile_image.attach(io: File.open(default_image_path), filename: "profile_image.png", content_type: "image/png")
        end
      end
    end

    setup do
      attach_default_profile_images
    end
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
