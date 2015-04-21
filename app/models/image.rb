class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :gallery
  validates_presence_of :user_id
  validates_presence_of :gallery_id
  has_attached_file :avatar, :styles => {:thumb => "100x100>"}
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  def next
    gallery.images.where("id > ?", id).first
  end

  def prev
    gallery.images.where("id < ?", id).last
  end
end
