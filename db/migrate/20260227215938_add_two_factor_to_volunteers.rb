class AddTwoFactorToVolunteers < ActiveRecord::Migration[7.2]
  def change
    add_column :volunteers, :otp_secret, :string
    add_column :volunteers, :consumed_timestep, :integer
    add_column :volunteers, :otp_required_for_login, :boolean
    add_column :volunteers, :otp_backup_codes, :text
  end
end
