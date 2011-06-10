class RemoveFbid < ActiveRecord::Migration
  def self.up
    remove_column :users, :fbid
  end

  def self.down
    add_column :users, :fbid, :integer
  end
end
