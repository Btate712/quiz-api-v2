class User < ApplicationRecord
  has_secure_password
  has_many :user_projects
  has_many :projects, through: :user_projects

  has_many :comments
  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email

  def has_project_rights?(project, required_access_level = READ_LEVEL) 
    if self.is_admin
      has_rights = true
    elsif project.is_public && required_access_level == READ_LEVEL
      has_rights = true
    elsif self.projects.include? project
      user_access_level = self.user_projects.find { |user_project| user_project.project_id == project.id }.access_level
      has_rights = user_access_level >= required_access_level ? true : false
    else
      has_rights = false
    end
  end

  def kill
    self.comments.all.each{ |comment| comment.kill }
    self.user_projects.all.each{ |user_project| user_project.kill }
    self.destroy
  end
end
