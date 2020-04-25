class Api::V1::RoundSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :user_name

  def user_name
    object.user.user_name
  end
end
