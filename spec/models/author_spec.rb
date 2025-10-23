require "rails_helper"

RSpec.describe Author, type: :model do
  it "is valid as person with name and birth_date" do
    a = build(:author, kind: :person, name: "Albert Camus", birth_date: "1913-11-07")
    expect(a).to be_valid
  end

  it "requires birth_date for person" do
    a = build(:author, kind: :person, name: "Albert Camus", birth_date: nil)
    expect(a).not_to be_valid
  end

  it "is valid as institution with name and city" do
    a = build(:author, :institution, name: "MIT Press", city: "Cambridge")
    expect(a).to be_valid
  end

  it "requires city for institution" do
    a = build(:author, :institution, name: "Some Org", city: nil)
    expect(a).not_to be_valid
  end

  it "has enum kind" do
    expect(Author.kinds.keys).to include("person", "institution")
  end
end
