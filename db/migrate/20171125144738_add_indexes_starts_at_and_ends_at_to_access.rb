class AddIndexesStartsAtAndEndsAtToAccess < ActiveRecord::Migration[5.1]
  def change
    add_index :accesses, :starts_at
    add_index :accesses, :ends_at
  end
end
