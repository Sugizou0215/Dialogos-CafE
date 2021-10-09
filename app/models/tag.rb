class Tag < ApplicationRecord
  has_many :tagmaps, dependent: :destroy, foreign_key: 'tag_id'
  has_many :events, through: :tagmaps
end
