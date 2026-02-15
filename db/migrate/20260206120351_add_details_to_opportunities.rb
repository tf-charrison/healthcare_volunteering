class AddDetailsToOpportunities < ActiveRecord::Migration[7.2]
  def change
    add_column :opportunities, :start_date, :date
    add_column :opportunities, :end_date, :date
    add_column :opportunities, :skills_required, :string
  end
end
