class Drawer < ApplicationRecord
  validates :participant_id, presence: true

  belongs_to :participant
end
