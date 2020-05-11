class Api::V1::RoundShowSerializer < ActiveModel::Serializer
  attributes :id, :starter_name, :current_user, :participants, :status, :turn, :turn_user_id, :round_prompt, :current_prompt

  def current_user
    if scope
      {id: scope.id, userName: scope.user_name}
    else
      {id: nil, userName: nil}
    end
  end

  def participants
    ActiveModelSerializers::SerializableResource.new(object.participants, each_serializer: Api::V1::ParticipantSerializer)
  end
end
