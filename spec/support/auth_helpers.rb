module AuthHelpers
  def auth_header_for(user)
    # Sign in through the real endpoint to get a valid JWT
    post "/users/sign_in", params: { user: { email: user.email, password: "123456" } }.to_json,
                           headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
    token = response.headers["Authorization"]
    { "Authorization" => token, "ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json" }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
