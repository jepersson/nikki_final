class Comment < ActiveRecord::Base
  attr_accessible :content

  validates :content, :presence => true
  validates :post_id, :presence => true
  validates :user_id, :presence => true
  
  belongs_to :post
  belongs_to :user
end
