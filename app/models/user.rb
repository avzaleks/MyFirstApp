class User < ActiveRecord::Base
  has_many :books, dependent: :destroy

  before_save { self.name = name.downcase }
  before_create :create_remember_token

  validates :name, presence: true, length: {minimum: 6, maximum: 20},
            uniqueness: {case_sensitive: false}

  validates :email, presence: true, length: {minimum: 6, maximum: 30}

  has_secure_password
  validates :password, length: {minimum: 6, maximum: 20}


  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end


