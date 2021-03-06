class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.references :user, index: true, foreign_key: true
      t.string :token
      t.datetime :last_used_at
      t.timestamps null: false
    end
  end
end
