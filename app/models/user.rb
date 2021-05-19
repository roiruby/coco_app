class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :posts, dependent: :destroy
  
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow, dependent: :destroy
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  has_many :followers, through: :reverses_of_relationship, source: :user, dependent: :destroy
  
  has_many :favorites, dependent: :destroy
  has_many :favposts, through: :favorites, source: :post, dependent: :destroy
  
  has_many :entries, dependent: :destroy
  has_many :entryposts, through: :entries, source: :post, dependent: :destroy
  
  has_many :comments, dependent: :destroy
  
  has_many :members, dependent: :destroy
  
  has_many :informations, dependent: :destroy
  
  mount_uploader :image, ImageUploader
  
  enum sex: { default: 0, female: 1, male: 2, unanswered: 3},_suffix: true
  
  enum age: { default: 0, late10s: 1, early20s: 2, late20s: 3, early30s: 4, late30s: 5, early40s: 6, late40s: 7, early50s: 8, late50s: 9,
              early60s: 10, late60s: 11, early70s: 12, late70s: 13, early80s: 14, late80s: 15, early90s: 16, late90s: 17},_suffix: true
              
  enum address: { default: 0, hokkaido: 1, aomori: 2, iwate: 3, miyagi: 4, akita: 5, yamagata: 6, fukushima: 7, ibaraki: 8, tochigi: 9, gunma: 10, saitama: 11,
                  chiba: 12, tokyo: 13, kanagawa: 14, niigata: 15, toyama: 16, ishikawa: 17, fukui: 18, yamanashi: 19, nagano: 20, gifu: 21, shizuoka: 22,
                  aichi: 23, mie: 24, shiga: 25, kyoto: 26, osaka: 27, hyogo: 28, nara: 29, wakayama: 30, tottori: 31, shimane: 32, okayama: 33, hiroshima: 34,
                  yamaguchi: 35, tokushima: 36, kagawa: 37, ehime: 38, kochi: 39, fukuoka: 40, saga: 41, nagasaki: 42, kumamoto: 43, oita: 44, miyazaki: 45,
                  kagoshima: 46, okinawa: 47},_suffix: true


  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def like(post)
    favorites.find_or_create_by(post_id: post.id)
  end

  def unlike(post)
    favorite = favorites.find_by(post_id: post.id)
    favorite.destroy if favorite
  end

  def  favpost?(post)
    self.favposts.include?(post)
  end
  
  def offer(post)
    entries.find_or_create_by(post_id: post.id)
  end

  def unoffer(post)
    entry = entries.find_by(post_id: post.id)
    entry.destroy if entry
  end

  def  entrypost?(post)
    self.entryposts.include?(post)
  end
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  private
  
  def downcase_email
    self.email = email.downcase
  end
  
  def create_activation_digest
    self.activation_token   =   User.new_token
    self.activation_digest  =   User.digest(activation_token)
  end
  
end
