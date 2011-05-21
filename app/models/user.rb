class User < ActiveRecord::Base
  attr_accessible :name, :intro
  
  validates :email, :presence => true
  validates :name, :presence => true
  
  has_many :posts, :dependent => :destroy
end
