class AddMoreDetailsToOrganisations < ActiveRecord::Migration[7.2]
  def change
    add_column :organisations, :name, :string
    add_column :organisations, :description, :text
    add_column :organisations, :verified, :boolean
  end
end
