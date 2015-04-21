class Gallery < ActiveRecord::Base
  belongs_to :user
  has_many :images, dependent: :destroy
  validates_presence_of :user_id
end
