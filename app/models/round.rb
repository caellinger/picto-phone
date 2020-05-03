class Round < ApplicationRecord
  validates :starter_name, presence: true
  has_many :participants
end
