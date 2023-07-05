class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id', optional: true
  has_many :messages, dependent: :destroy
end
