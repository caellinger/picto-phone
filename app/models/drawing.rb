class Drawing < ApplicationRecord
  validates :drawing, presence: true

  mount_base64_uploader :drawing, DrawingUploader
end
