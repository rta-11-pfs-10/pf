class AddThumbnailToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :thumbnail, :string
    add_column :posts, :description, :text
  end
end
