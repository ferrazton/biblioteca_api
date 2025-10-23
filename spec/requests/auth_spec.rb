require "rails_helper"

RSpec.describe "Auth", type: :request do
  it "signs up and signs in" do
    post "/users", params: { user: { email: "test@cin.ufpe.br", password: "123456", password_confirmation: "123456" } }.to_json,
                   headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:created)

    post "/users/sign_in", params: { user: { email: "test@cin.ufpe.br", password: "123456" } }.to_json,
                           headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:ok)
    expect(response.headers["Authorization"]).to be_present
  end
end
