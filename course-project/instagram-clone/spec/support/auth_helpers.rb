module AuthHelpers
  def sign_in_user(user)
    post user_session_path, params: { user: { email: user.email, password: "password123" } }
  end

  def build_user(attrs = {})
    defaults = {
      username: "user_#{SecureRandom.hex(4)}",
      email: "user_#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
    User.create!(defaults.merge(attrs))
  end

  def uploaded_test_image
    Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test-image.svg"), "image/svg+xml")
  end
end

RSpec.configure do |config|
  config.include AuthHelpers
end
