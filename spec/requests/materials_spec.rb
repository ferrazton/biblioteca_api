require "rails_helper"

RSpec.describe "Materials", type: :request do
  let(:user)   { create(:user) }
  let(:author) { create(:author, name: "Albert Camus") }
  let(:auth)   { auth_header_for(user) }

  it "lists materials (public index) with pagination defaults" do
    create_list(:material, 3, :book, user: user, author: author)
    get "/materials", headers: { "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json.length).to be >= 1
  end

  it "filters by title and author name" do
    create(:material, :book, user: user, author: author, title: "O Estrangeiro")
    create(:material, :book, user: user, author: author, title: "A Peste")
    get "/materials", params: { title: "estrangeiro" }, headers: { "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:ok)
    titles = JSON.parse(response.body).map { |m| m["title"] }
    expect(titles.any? { |t| t.downcase.include?("estrangeiro") }).to be true

    get "/materials", params: { author: "camus" }, headers: { "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:ok)
  end

  it "creates a material when authorized" do
    payload = {
      material: {
        title: "Book X",
        kind: "book",
        status: "published",
        isbn: "9780000000002",
        pages: 111,
        author_id: author.id
      }
    }
    post "/materials", params: payload.to_json, headers: auth
    expect(response).to have_http_status(:created)
  end

  it "rejects creation without token" do
    post "/materials", params: { material: { title: "Nope", kind: "book", status: "draft", isbn: "9780000000003", pages: 50, author_id: author.id } }.to_json,
                       headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:unauthorized)
  end

  it "forbids update by non-owner" do
    m = create(:material, :book, user: user, author: author, title: "Owned by A")
    other = create(:user)
    other_auth = auth_header_for(other)

    patch "/materials/#{m.id}", params: { material: { title: "Hacked" } }.to_json, headers: other_auth
    expect(response).to have_http_status(:forbidden)
  end

  it "shows a material (public)" do
    m = create(:material, :book, user: user, author: author, title: "Show Me")
    get "/materials/#{m.id}", headers: { "ACCEPT" => "application/json" }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["title"]).to eq("Show Me")
  end
end
