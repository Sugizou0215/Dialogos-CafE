class CreateGroupComments < ActiveRecord::Migration[5.2]
  def change
    create_table :group_comments do |t|
      t.text :comment
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
