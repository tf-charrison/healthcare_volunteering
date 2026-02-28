class AddLocationToOrganisations < ActiveRecord::Migration[7.2]
  def change
    add_column :organisations, :location, :string
  end
end
