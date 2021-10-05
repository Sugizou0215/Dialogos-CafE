class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.text :introduction
      t.integer :genre_id
      t.datetime :start_at
      t.datetime :finish_at
      t.datetime :deadline
      t.integer :capacity
      t.text :tool
      t.boolean :is_valid,     default: true #中止ステータス用、中止するとfalseへ
      t.string :event_image_id
      t.integer :admin_uesr_id
      t.integer :group_id

      t.timestamps
    end
  end
end
