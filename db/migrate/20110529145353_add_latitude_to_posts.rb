class AddLatitudeToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :latitude, :double
  end

  def self.down
    remove_column :posts, :latitude
  end
end
