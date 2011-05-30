class AddLongitudeToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :longitude, :double
  end

  def self.down
    remove_column :posts, :longitude
  end
end
