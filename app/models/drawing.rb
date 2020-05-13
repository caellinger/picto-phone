class Drawing < ApplicationRecord
  validates :drawing, presence: true
  validates :participant_id, presence: true

  belongs_to :participant

  mount_base64_uploader :drawing, DrawingUploader
end
