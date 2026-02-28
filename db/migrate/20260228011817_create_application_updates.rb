class CreateApplicationUpdates < ActiveRecord::Migration[7.2]
  def change
    create_table :application_updates do |t|
      t.references :application, null: false, foreign_key: true
      t.string :user_type
      t.integer :user_id
      t.text :message

      t.timestamps
    end
  end
end
