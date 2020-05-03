class Participant < ApplicationRecord
  validates :participant_type, presence: true
  validates :round_starter, inclusion: { in: [true, false] }
  validates :round_id, presence: true
  validates :user_id, presence: true

  belongs_to :round
  belongs_to :user
end