class User < ActiveRecord::Base
  has_many :sender_emails

  validates_presence_of :email

  after_create :create_sender_email

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

  private

  def create_sender_email
    sender_emails.create address: email
  end
end
