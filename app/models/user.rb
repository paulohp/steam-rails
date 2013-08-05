class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  attr_accessor :login

  validates :username,
    :uniqueness => {
      :case_sensitive => false
    }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
          :omniauth_providers => [:steam], :authentication_keys => [:login]

  def self.find_for_steam_oauth(access_token, signed_in_resource=nil)
    data = access_token.info
    provider = access_token.provider
    uid = access_token.uid
    if user = User.where(:username => data["nickname"]).first
      user
    else
      User.create!(:provider => provider, :uid => uid,:name => data['name'], :picture => data['image'], :username => data["nickname"] ,:email => "example@company.com", :password => Devise.friendly_token[0,20])
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
