class CreateCommunityLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :community_likes do |t|
      t.references :volunteer, null: false, foreign_key: true
      t.references :community_post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
