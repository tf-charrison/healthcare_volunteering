class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :application, null: false, foreign_key: true
      t.string :sender_type, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
