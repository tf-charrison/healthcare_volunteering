class AddDetailsToOrganisations < ActiveRecord::Migration[7.2]
  def change
    add_column :organisations, :phone_number, :string
    add_column :organisations, :address, :string
  end
end
