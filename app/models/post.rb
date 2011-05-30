class Post < ActiveRecord::Base
  attr_accessible :title, :content, :longitude, :latitude
  
  validates :title, :presence => true
  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :longitude, :presence => true
  validates :latitude, :presence => true
  
  belongs_to :user
  has_many :comments, :dependent => :destroy
end
