class Round < ApplicationRecord
  validates :starter_name, presence: true
  validates :turn_user_id, presence: true
  
  has_many :participants
end
