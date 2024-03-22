class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.string :endpoint
      t.string :key_id
      t.string :key_secret
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
