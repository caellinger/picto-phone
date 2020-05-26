class Api::V1::ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :participant_type, :response, :user_name

  def user_name
    object.user.user_name
  end
end
