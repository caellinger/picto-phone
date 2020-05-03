class Api::V1::RoundSerializer < ActiveModel::Serializer
  attributes :id, :starter_id

  def starter_id
    starter = object.participants.find_by round_starter: true
    starter.user.user_name
  end
end
