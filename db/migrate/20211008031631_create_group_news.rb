class CreateGroupNews < ActiveRecord::Migration[5.2]
  def change
    create_table :group_news do |t|
      t.integer :group_id
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
