class RemovePositionFromPosts < ActiveRecord::Migration
  def self.up
    remove_column :posts, :latitude
    remove_column :posts, :longitude
  end

  def self.down
    add_column :posts, :longitude, :float
    add_column :posts, :latitude, :float
  end
end
