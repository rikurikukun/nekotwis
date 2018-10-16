class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  belongs_to :user
   validates :content, presence: true, length: { maximum: 255 }



  has_many :favorites
  has_many :favoriters, through: :favorites, source: :user
end
