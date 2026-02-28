class AddExperienceToVolunteers < ActiveRecord::Migration[7.2]
  def change
    add_column :volunteers, :experience, :text
  end
end
