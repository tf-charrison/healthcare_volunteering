class AddAvailabilityToVolunteers < ActiveRecord::Migration[7.2]
  def change
    add_column :volunteers, :availability, :string
  end
end
