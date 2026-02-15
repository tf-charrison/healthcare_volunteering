class AddNameAndPhoneToVolunteers < ActiveRecord::Migration[7.2]
  def change
    add_column :volunteers, :first_name, :string
    add_column :volunteers, :last_name, :string
    add_column :volunteers, :phone_number, :string
  end
end
