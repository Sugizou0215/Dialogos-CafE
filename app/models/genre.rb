class Genre < ApplicationRecord
  has_many :events

  validates :name, presence: true, length: { maximum: 20 }
end
