class AddTwoFactorToOrganisations < ActiveRecord::Migration[7.2]
  def change
    add_column :organisations, :otp_secret, :string
    add_column :organisations, :consumed_timestep, :integer
    add_column :organisations, :otp_required_for_login, :boolean
    add_column :organisations, :otp_backup_codes, :text
  end
end
