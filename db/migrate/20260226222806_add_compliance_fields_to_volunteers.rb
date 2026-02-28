class AddComplianceFieldsToVolunteers < ActiveRecord::Migration[7.2]
  def change
    add_column :volunteers, :cpr_certified, :boolean
    add_column :volunteers, :first_aid_certified, :boolean
    add_column :volunteers, :hipaa_trained, :boolean
    add_column :volunteers, :background_checked, :boolean
  end
end
