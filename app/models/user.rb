# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: { message: 'must be filled out' }
  validates :email, presence: { message: 'must be filled out' },
                    uniqueness: { message: 'is already taken' }
                    
  validates :password, presence: { message: " can't be blank." }
  validates :password_confirmation, presence: { message: " can't be blank." }
  
  has_secure_password

  enum role: %w(default manager admin)

  def self.all_except_me(user)
    where.not(id: user.id)
  end

end
