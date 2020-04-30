class Participant < ApplicationRecord
  validates :order_id, presence: true
  validates :participant_type, presence: true
  validates :round_starter, inclusion: { in: [true, false] } 

  belongs_to :round
  belongs_to :user
end
