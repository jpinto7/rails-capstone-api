class CreateThingTags < ActiveRecord::Migration
  def change
    create_table :thing_tags do |t|
      t.references :thing, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :thing_tags, [:tag_id, :thing_id], unique: true
  end
end
