class User < ApplicationRecord
  require 'securerandom'
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :country, presence: true
  validates :verified, inclusion: { in: [true, false] }
  validates :role, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def generate_token
    SecureRandom.hex(10)
  end

  def admin?
    role == 'admin'
  end
end
