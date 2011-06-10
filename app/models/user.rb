class User < ActiveRecord::Base
  attr_accessible :name, :location, :intro, :email, :photo, :x1, :y1, :width, :height, :position, :password, :password_confirmation
  attr_accessor :x1, :y1, :width, :height
  after_update :reprocess_photo, :if => :cropping?

  acts_as_authentic do |c|
    c.merge_validates_length_of_password_field_options({ :unless => :authenticated? })
    c.merge_validates_length_of_password_confirmation_field_options({ :unless => :authenticated? })
    c.merge_validates_confirmation_of_password_field_options({ :unless => :authenticated? })
  end

  def authenticated?
    self.authentications.any?
  end

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
    :length => { :maximum => 50 }
  validates :intro, :length => { :maximum => 500 }
  validates :email, :presence => true,
    :format => { :with => email_regex },
    :uniqueness => { :case_sensitive => false }

  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :relations, :foreign_key => "follower_id",
    :dependent => :destroy
  has_many :following, :through => :relations, :source => "followed"
  has_many :reverse_relations, :foreign_key => "followed_id",
    :class_name => "Relation",
    :dependent => :destroy
  has_many :followers, :through => :reverse_relations, :source => "follower"
  has_many :authentications, :dependent => :destroy

  has_attached_file :photo,
  :styles => {
    :mini => "40x40#",
    :small => { :geometry => "300x400#",
                :processors => [:cropper] },
  :original => "1024x600>" },
    :default_url => "../images/no-user.jpg"

  def following?(followed)
    self.relations.find_by_followed_id(followed)
  end

  def follow!(followed)
    self.relations.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relations.find_by_followed_id(followed).destroy
  end

  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email']

    case omniauth['provider']
    when 'facebook'
      self.name = omniauth['user_info']['name']
    end
  end

  def cropping?
    !x1.blank? && !y1.blank? && !width.blank? && !height.blank?
  end

  def photo_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(photo.path(style))
  end

  private

    def reprocess_photo
      photo.reprocess!
    end

end
