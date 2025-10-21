class Material < ApplicationRecord
  
  belongs_to :author
  belongs_to :user

  enum status: {draft: 0, published: 1, archived: 2}
  enum kind: {book: 0, article: 1, video: 2}

  validates :user, presence: true
  validates :author, presence: true
  validates :title, presence: true, length: {in: 3..100}
  validates :description, length: {maximum: 1000}, allow_blank: true
  validates :status, presence: true
  validates :kind, presence: true

  # Book-specific validations
  validates :isbn, presence: true, if: :book?
  validates :isbn, uniqueness: true, length: {is: 13}, if: :book?
  validates :isbn, format: {with: /\A\d+\z/}, if: :book?
  validates :pages, presence: true, if: :book?
  validates :pages, numericality: {only_integer: true, greater_than: 0}, if: :book?

  # Article-specific validations
  validates :doi, presence: true, if: :article?
  validates :doi, uniqueness: true, format: {with: %r{\A10\.\d{4,9}/[-._;()/:A-Z0-9]+\z}i}, if: :article?

  # Video-specific validations
  validates :duration, presence: true, if: :video?
  validates :duration, numericality: {only_integer: true, greater_than: 0}, if: :video?

end
