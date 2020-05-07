class Topic < ApplicationRecord
  has_many :questions 
  belongs_to :project

  validates_presence_of :project_id, :name
  validates :name, uniqueness: { scope: :project, message: "should be unique within a project" }
end
