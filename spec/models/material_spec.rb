require "rails_helper"

RSpec.describe Material, type: :model do
  let(:user)   { create(:user) }
  let(:author) { create(:author) }

  it "validates book requirements" do
    m = build(:material, :book, user: user, author: author, title: "The Stranger", pages: 185, isbn: "9786610151271")
    expect(m).to be_valid
  end

  it "requires isbn and pages for book" do
    m = build(:material, :book, user: user, author: author, isbn: nil, pages: nil)
    expect(m).not_to be_valid
  end

  it "validates article requirements" do
    m = build(:material, :article, user: user, author: author, title: "ML Trends", doi: "10.1000/182")
    expect(m).to be_valid
  end

  it "validates video requirements" do
    m = build(:material, :video, user: user, author: author, title: "NNs", duration: 60)
    expect(m).to be_valid
  end

  it "has enums for kind and status" do
    expect(Material.kinds.keys).to include("book", "article", "video")
    expect(Material.statuses.keys).to include("draft", "published", "archived")
  end
end
