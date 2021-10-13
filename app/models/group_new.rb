class GroupNew < ApplicationRecord
  has_many :groups

  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true
end
