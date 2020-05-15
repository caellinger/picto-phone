class Api::V1::RoundSerializer < ActiveModel::Serializer
  attributes :id, :starter_name, :current_user

  def current_user
    if scope
      {id: scope.id, user_name: scope.user_name}
    else
      {id: nil, user_name: nil}
    end
  end
end
