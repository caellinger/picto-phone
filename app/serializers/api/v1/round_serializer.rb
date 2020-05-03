class Api::V1::RoundSerializer < ActiveModel::Serializer
  attributes :id, :starter_name, :user

  def starter_name
    starter = object.participants.find_by round_starter: true
    starter.user.user_name
  end

  def user
    if scope
      {id: scope.id, userName: scope.user_name}
    else
      {id: nil, userName: nil}
    end
  end
end
