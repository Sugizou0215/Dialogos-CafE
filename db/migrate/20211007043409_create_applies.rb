class CreateApplies < ActiveRecord::Migration[5.2]
  def change
    create_table :applies do |t|
      t.references  :user,  index: true, foreign_key: true
      t.references  :group, index: true, foreign_key: true

      t.timestamps
    end
  end
end
