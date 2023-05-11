class EmailOtp < ApplicationRecord
  validates :email, uniqueness: true
end
