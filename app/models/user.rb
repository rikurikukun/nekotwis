class User < ApplicationRecord
  mount_uploader :picture, PictureUploader
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
 
  has_secure_password
  has_many :posts, :dependent => :destroy
  
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow, dependent: :destroy
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  has_many :followers, through: :reverses_of_relationship, source: :user, dependent: :destroy
  
  has_many :favorites, dependent: :destroy
  has_many :favoritings, through: :favorites, source: :post, dependent: :destroy

 def follow(other_user)
   unless self == other_user
    self.relationships.find_or_create_by(follow_id: other_user.id)
   end
 end
  
  def unfollow(other_user)
    relationships = self.relationships.find_by(follow_id: other_user.id)
    relationships.destroy if relationships
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_posts
    Post.where(user_id: self.following_ids + [self.id])
  end
  
  
  
  def favorite(other_post)
    self.favorites.find_or_create_by(post_id: other_post.id)
  end
  
  def unfavorite(other_post)
    favorite = self.favorites.find_by(post_id: other_post.id)
    favorite.destroy if favorite
  end
  
  def favoriting?(other_post)
    self.favoritings.include?(other_post)
  end
end