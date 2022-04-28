class User < ApplicationRecord
  has_many :songs_user
  has_many :songs, through: :songs_user
  has_many :playlist, dependent: :destroy
end
