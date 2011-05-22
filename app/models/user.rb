class User < ActiveRecord::Base
  attr_accessible :name, :intro, :email
  
  validates :email, :presence => true,
                    :uniqueness => { :case_sensitive => false },
                    :format => { :with => /^.+@.+\..+$/ }
  validates :name, :presence => true,
                   :uniqueness => { :case_sensitive => false } 
  
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :relations, :foreign_key => "follower_id",
                       :dependent => :destroy
  has_many :following, :through => :relations, :source => :followed_id
  has_many :reverse_relations, :foreign_key => "followed_id",
                               :class_name => "Relation",
                               :dependent => :destroy
  has_many :followers, :through => :reverse_relations, :source => :follower_id
  
  def following?(followed)
    self.relations.find_by_followed_id(followed)
  end
  
  def follow!(followed)
    self.relations.create!(:followed_id => followed.id)
  end
end
