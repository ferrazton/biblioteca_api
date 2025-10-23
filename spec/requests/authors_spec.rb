require "rails_helper"

RSpec.describe "Authors", type: :request do
  let(:user) { create(:user) }
  let(:auth) { auth_header_for(user) }

  it "lists authors (public)" do
    create(:author, name: "Albert Camus")
    get "/authors", headers: { "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).length).to be >= 1
  end

  it "shows an author (public)" do
    a = create(:author, name: "MIT Press", kind: :institution, city: "Cambridge")
    get "/authors/#{a.id}", headers: { "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["name"]).to eq("MIT Press")
  end

  it "requires auth to create" do
    post "/authors",
         params: { author: { name: "New Author", kind: "person", birth_date: "1990-01-01" } }.to_json,
         headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:unauthorized)

    post "/authors",
         params: { author: { name: "New Author", kind: "person", birth_date: "1990-01-01" } }.to_json,
         headers: auth
    expect(response).to have_http_status(:created)
  end
end
