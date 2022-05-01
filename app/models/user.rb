require 'bcrypt'
class User < ApplicationRecord
  include BCrypt
  include Humanizer
  has_many :songs_user, dependent: :destroy
  has_many :songs, through: :songs_user
  has_many :playlists, dependent: :destroy
  require_human_on :create


  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  validates :username, presence: true
  validates :password_hash, presence: true
  validates :username, uniqueness: true
end
