class Project < ApplicationRecord
  has_many :user_projects
  has_many :users, through: :user_projects 
  
  has_many :topics

  validates_presence_of :name

  validates_uniqueness_of :name

  def kill 
    self.topics.all.each { |topic| topic.kill }
    self.user_projects.all.each { |user_project| user_project.kill }
    self.delete
  end
end
