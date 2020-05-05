class Api::V1::RoundSerializer < ActiveModel::Serializer
  attributes :id, :starter_name, :current_user

  def current_user
    if scope
      {id: scope.id, userName: scope.user_name}
    else
      {id: nil, userName: nil}
    end
  end
end
