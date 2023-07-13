class Message < ApplicationRecord
  belongs_to :user
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id', optional: true
  belongs_to :chat
end
