class CreateTagDrafts < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_drafts do |t|
      t.references :draft, null: false, foreign_key: true
      t.references :dtag,   null: false, foreign_key: true
      t.timestamps
    end
  end
end
