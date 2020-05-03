class Api::V1::RoundSerializer < ActiveModel::Serializer
  attributes :id, :starter_name, :user

  def user
    if scope
      {id: scope.id, userName: scope.user_name}
    else
      {id: nil, userName: nil}
    end
  end

  def user
    if scope
      {id: scope.id, userName: scope.user_name}
    else
      {id: nil, userName: nil}
    end
  end
end
