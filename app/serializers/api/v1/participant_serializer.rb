class Api::V1::ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :participant_type
end
