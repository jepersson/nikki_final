class Post < ActiveRecord::Base
  attr_accessible :title, :user_id, :content, :position, :photo
                      
  validates :title, :presence => true
  validates :content, :presence => true
  validates :user_id, :presence => true
  
  belongs_to :user
  has_many :comments, :dependent => :destroy
  
  has_attached_file :photo,
    :styles => {
      :small => "300x400#",
      :original => "1024x600>" },
    :default_url => "../images/b.jpg"
  
  default_scope :order => 'posts.created_at DESC'
end
