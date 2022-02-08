class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id",dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower
  has_many :group_users, dependent: :destroy
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50 }


  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize: "100x100").processed
  end

  def follow(user_id)
  follower.create(followed_id: user_id)
  end
# フォローを外すときの処理
  def unfollow(user_id)
  follower.find_by(followed_id: user_id).destroy
  end
# フォローしているか判定
  def following?(user)
  following_user.include?(user)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name like?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name like?", "#{word}%")
    elsif search == "backword_match"
      @user = User.where("name like?", "%#{word}")
    elsif search == "partical_match"
      @user =User.where("name like?", "%#{word}%")
    else
      @user = User.all
    end
  end



end
