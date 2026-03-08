class CreateCommunityPosts < ActiveRecord::Migration[7.2]
  def change
    create_table :community_posts do |t|
      t.references :volunteer, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
