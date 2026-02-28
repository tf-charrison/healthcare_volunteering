class RemoveExperienceSummaryFromApplications < ActiveRecord::Migration[7.2]
  def change
    remove_column :applications, :experience_summary, :string
  end
end
