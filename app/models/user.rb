class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :relations, :foreign_key => "follower_id",
                       :dependent => :destroy
  has_many :following, :through => :relations, :source => "followed"
  has_many :reverse_relations, :foreign_key => "followed_id",
                               :class_name => "Relation",
                               :dependent => :destroy
  has_many :followers, :through => :reverse_relations, :source => "follower"
  
  def following?(followed)
    self.relations.find_by_followed_id(followed)
  end
  
  def follow!(followed)
    self.relations.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    relations.find_by_followed_id(followed).destroy
  end
end
