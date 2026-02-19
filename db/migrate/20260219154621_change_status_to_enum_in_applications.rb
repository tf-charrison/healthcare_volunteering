class ChangeStatusToEnumInApplications < ActiveRecord::Migration[7.0]
  def up
    # Add a temporary column to store integer values
    add_column :applications, :status_temp, :integer, default: 0, null: false

    # Map existing string statuses to integers
    Application.reset_column_information
    Application.find_each do |app|
      app.update_columns(
        status_temp: case app.status
                     when "pending"  then 0
                     when "approved" then 1
                     when "rejected" then 2
                     else 0 # default to pending if nil/unknown
                     end
      )
    end

    # Remove old string column
    remove_column :applications, :status

    # Rename temporary column to status
    rename_column :applications, :status_temp, :status
  end

  def down
    # Revert back to string column
    add_column :applications, :status_temp, :string
    Application.reset_column_information
    Application.find_each do |app|
      app.update_columns(
        status_temp: case app.status
                     when 0 then "pending"
                     when 1 then "approved"
                     when 2 then "rejected"
                     end
      )
    end

    remove_column :applications, :status
    rename_column :applications, :status_temp, :status
  end
end
