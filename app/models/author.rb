class Author < ApplicationRecord

    has_many :materials

    enum kind: { person: 0, institution: 1 }
    validates :kind, presence: true
    
    # Person-specific validations
    validates :name, presence: true, length: {in: 3..80}, if: :person?
    validates :birth_date, presence: true, if: :person?
    validate :birth_date_not_in_future, if: :person?

    # Institution-specific validations
    validates :name, presence: true, length: {in: 3..120}, if: :institution?
    validates :city, presence: true, length: {in: 2..80}, if: :institution?

    def birth_date_not_in_future
        return if birth_date.blank?
        if birth_date > Date.today
            errors.add(:birth_date, "Birth date in the future")
        end
    end

end
