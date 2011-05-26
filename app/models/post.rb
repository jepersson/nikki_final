class Post < ActiveRecord::Base
  attr_accessible :title, :content, :user_id
  
  validates :title, :presence => true
  validates :content, :presence => true
  validates :user_id, :presence => true
  
  belongs_to :user
  has_many :comments, :dependent => :destroy
  
  default_scope :order => 'posts.created_at DESC'
end
