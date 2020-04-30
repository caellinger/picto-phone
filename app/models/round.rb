class Round < ApplicationRecord
  validates :prompt, presence: true

  has_many :participants
end
