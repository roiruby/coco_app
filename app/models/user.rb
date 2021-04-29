class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :posts
  
  mount_uploader :image, ImageUploader
  
  enum sex: { default: 0, female: 1, male: 2, unanswered: 3},_suffix: true
  
  enum age: { default: 0, late10s: 1, early20s: 2, late20s: 3, early30s: 4, late30s: 5, early40s: 6, late40s: 7, early50s: 8, late50s: 9,
              early60s: 10, late60s: 11, early70s: 12, late70s: 13, early80s: 14, late80s: 15, early90s: 16, late90s: 17},_suffix: true
              
  enum address: { default: 0, hokkaido: 1, aomori: 2, iwate: 3, miyagi: 4, akita: 5, yamagata: 6, fukushima: 7, ibaraki: 8, tochigi: 9, gunma: 10, saitama: 11,
                  chiba: 12, tokyo: 13, kanagawa: 14, niigata: 15, toyama: 16, ishikawa: 17, fukui: 18, yamanashi: 19, nagano: 20, gifu: 21, shizuoka: 22,
                  aichi: 23, mie: 24, shiga: 25, kyoto: 26, osaka: 27, hyogo: 28, nara: 29, wakayama: 30, tottori: 31, shimane: 32, okayama: 33, hiroshima: 34,
                  yamaguchi: 35, tokushima: 36, kagawa: 37, ehime: 38, kochi: 39, fukuoka: 40, saga: 41, nagasaki: 42, kumamoto: 43, oita: 44, miyazaki: 45,
                  kagoshima: 46, okinawa: 47},_suffix: true

end
