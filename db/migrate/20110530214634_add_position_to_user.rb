class AddPositionToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :longitude, :double
    add_column :users, :latitude, :double
  end

  def self.down
    remove_column :users, :latitude
    remove_column :users, :longitude
  end
end
