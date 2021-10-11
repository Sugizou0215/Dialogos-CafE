class CreateGroupNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :group_notices do |t|
      t.integer :group_id
      t.integer :visiter_id
      t.integer :visited_id
      t.integer :group_comment_id
      t.string :action
      t.boolean :is_checked, default: false, null: false

      t.timestamps
    end
  end
end
