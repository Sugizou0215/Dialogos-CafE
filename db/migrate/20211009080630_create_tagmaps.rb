class CreateTagmaps < ActiveRecord::Migration[5.2]
  def change
    create_table :tagmaps do |t|
      t.bigint :event_id, index: true, foreign_key: true
      t.references  :tag, index: true, foreign_key: true

      t.timestamps
    end
  end
end
