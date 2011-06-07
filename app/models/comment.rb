class Comment < ActiveRecord::Base
  attr_accessible :content, :post_id

  validates :content, :presence => true,
                      :length => { :maximum => 250 }
  validates :post_id, :presence => true
  validates :user_id, :presence => true
  
  belongs_to :post
  belongs_to :user
  
  default_scope :order => 'comments.created_at DESC'
end
