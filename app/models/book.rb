class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}


  def self.looks(search,word)
    if search == "perfect_match"
      @book = Book.where("title like?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title like?", "#{word}%")
    elsif search == "backword_match"
      @book = Book.where("title like?", "%#{word}")
    elsif search == "partical_match"
      @book = Book.where("title like?","%#{word}%")
    else
      @book =Book.all
    end
  end
end
