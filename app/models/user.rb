class User < ActiveRecord::Base
  validates_presence_of :email

  devise :omniauthable

  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    if user = User.where(:email => data["email"]).first
      user
    else
      User.create!(:email => data["email"])
    end
  end

  def display_name
    name || email
  end
end
