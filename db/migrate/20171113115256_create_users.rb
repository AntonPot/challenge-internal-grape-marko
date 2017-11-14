class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :token
      t.integer :access_level, default: 0

      t.timestamps
    end
  end
end