class UserSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer
  extend JsonWebToken
  attributes :first_name, :last_name, :country, :verified, :role, :email, :id

  meta do |user|
    { token: jwt_encode(user_id: user.id) }
  end
end
