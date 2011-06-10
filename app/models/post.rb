class Post < ActiveRecord::Base
  attr_accessible :title, :content, :position, :photo, :x1, :y1, :width, :height
  attr_accessor :x1, :y1, :width, :height

  after_update :reprocess_photo, :if => :cropping?                      

  validates :title, :presence => true,
    :length => { :maximum => 75 }
  validates :content, :presence => true,
    :length => { :maximum => 500 }
  validates :user_id, :presence => true

  belongs_to :user
  has_many :comments, :dependent => :destroy

  has_attached_file :photo,
  :styles => {
    :small => { :geometry => "300x400#",
                :processors => [:cropper] },
  :original => "1024x600>" },
    :default_url => "../images/b.jpg"

  default_scope :order => 'posts.created_at DESC'

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
