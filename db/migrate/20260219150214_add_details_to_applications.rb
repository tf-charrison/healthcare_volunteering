class AddDetailsToApplications < ActiveRecord::Migration[7.2]
  def change
    add_column :applications, :cover_letter, :text
    add_column :applications, :availability, :string
    add_column :applications, :experience_summary, :text
  end
end
