class CreateApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :applications do |t|
      t.references :volunteer, null: false, foreign_key: true
      t.references :opportunity, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
