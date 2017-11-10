class AddTopLevelToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :is_top_level, :boolean
  end
end
