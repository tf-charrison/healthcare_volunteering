class AddExpiryToOpportunities < ActiveRecord::Migration[7.2]
  def change
    add_column :opportunities, :expiry_date, :date
  end
end
