class AddSkillsToVolunteers < ActiveRecord::Migration[7.2]
  def change
    add_column :volunteers, :skills, :string
  end
end
