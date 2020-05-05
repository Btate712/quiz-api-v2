class CreateUserProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :user_projects do |t|
      t.integer :user_id
      t.integer :project_id

      t.integer :access_level
      
      t.timestamps
    end
  end
end
