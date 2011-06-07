class RemovePositionFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :latitude
    remove_column :users, :longitude
  end

  def self.down
    add_column :users, :longitude, :float
    add_column :users, :latitude, :float
  end
end
