class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :recipient, polymorphic: true, null: false
      t.string :message
      t.string :link
      t.boolean :read

      t.timestamps
    end
  end
end
