class GroupComment < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :comment, presence: true, length: { maximum: 200 }
end
