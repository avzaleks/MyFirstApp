class Book < ActiveRecord::Base

  has_and_belongs_to_many :genres
  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true, length: {minimum:4,  maximum: 100 }
  validates :author, presence: true, length: {minimum:4,  maximum: 100 }

end
