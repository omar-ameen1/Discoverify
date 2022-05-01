class AddPreviewToSong < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :preview, :string
  end
end
