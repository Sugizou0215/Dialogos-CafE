class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :introduction
      t.string :group_image_id
      t.integer :admin_user_id

      t.timestamps
    end
  end
end
