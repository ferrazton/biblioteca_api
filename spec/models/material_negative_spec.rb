require "rails_helper"

RSpec.describe Material, type: :model do
  let(:user)   { create(:user) }
  let(:author) { create(:author) }

  it "rejects book with non-numeric pages or short isbn" do
    m = build(:material, :book, user: user, author: author, pages: -1, isbn: "123")
    expect(m).not_to be_valid
    expect(m.errors[:pages]).to be_present
    expect(m.errors[:isbn]).to be_present
  end

  it "rejects article with malformed doi" do
    m = build(:material, :article, user: user, author: author, doi: "bad-doi")
    expect(m).not_to be_valid
    expect(m.errors[:doi]).to be_present
  end

  it "rejects video with non-positive duration" do
    m = build(:material, :video, user: user, author: author, duration: 0)
    expect(m).not_to be_valid
    expect(m.errors[:duration]).to be_present
  end
end
