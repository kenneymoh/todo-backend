class User < ApplicationRecord
  has_many :tasks
    validates :email, presence: true, uniqueness: true
    validates :email, format: {with: URI::Mailto::EMAIL_REGEXP}
    validates :username, presence: true, uniqueness: true
    validates :password, length: {minimum: 6}, if: -> { new_record? || !password.nil}
end
