class User < ApplicationRecord
  has_secure_password
  has_many :user_projects
  has_many :projects, through: :user_projects

  has_many :comments
  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email
end
