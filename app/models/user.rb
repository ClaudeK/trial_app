class User < ActiveRecord::Base
	before_create :create_remember_token
    before_save { self.email = email.downcase }

	validates :name, presence: true, length: { maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
               uniqueness: { case_sensitive: false}

    has_secure_password
    validates :password, length: { minimum: 6}


    
    # GENERATES LENGTH 16 RANDOM STRING COMPOSED OF A-Z,a-z,0-9,-,_ TO BE USED AS REMEMBER TOKEN
    def User.new_remember_token
    	SecureRandom.urlsafe_base64
    end
    
    # ENCRYPTS GENERATED TOKEN USING SH1
    def User.encrypt(token)
    	Digest::SHA1::hexdigest(token.to_s)
    end

    private
    
    # ASSIGNS ENCRYPTED REMEMBER TOKEN TO USER MODEL'S remember_token ATTRIBUTE
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
