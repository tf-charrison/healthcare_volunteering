class CreateCommunityReplies < ActiveRecord::Migration[7.2]
  def change
    create_table :community_replies do |t|
      t.references :community_post, null: false, foreign_key: true
      t.references :volunteer, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
