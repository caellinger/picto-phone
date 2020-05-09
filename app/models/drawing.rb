class Drawing < ApplicationRecord
  validates :drawing, presence: true
  validates :drawer_id, presence: true

  belongs_to :drawer

  mount_base64_uploader :drawing, DrawingUploader
end
