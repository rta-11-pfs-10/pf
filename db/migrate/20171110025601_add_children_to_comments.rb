class AddChildrenToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :children, :string
  end
end
