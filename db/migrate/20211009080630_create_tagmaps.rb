class CreateTagmaps < ActiveRecord::Migration[5.2]
  def change
    create_table :tagmaps do |t|
      #デプロイ時にエラー発生、mysqlでrefernces=>bigintへとするよう指示されたため、本番環境ではbigintを使用
      # t.references :event, index: true, foreign_key: true
      t.bigint :event_id, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps
    end
  end
end
