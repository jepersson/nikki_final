class User < ActiveRecord::Base
  attr_accessible :name, :intro
  
  validates :email, :presence => true,
                    :uniqueness => { :case_sensitive => false },
                    :format => { :with => /^.+@.+\..+$/ }
  validates :name, :presence => true,
                    :uniqueness => { :case_sensitive => false } 
  
  has_many :posts, :dependent => :destroy
end
