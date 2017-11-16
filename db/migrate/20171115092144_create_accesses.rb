class CreateAccesses < ActiveRecord::Migration[5.1]
  def change
    create_table :accesses do |t|
      t.integer :level
      t.datetime :starts_at
      t.datetime :ends_at
      
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
