class CreateOpportunities < ActiveRecord::Migration[7.2]
  def change
    create_table :opportunities do |t|
      t.string :title
      t.text :description
      t.string :location
      t.references :organisation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
