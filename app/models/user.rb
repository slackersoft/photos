class User < ActiveRecord::Base
  has_many :sender_emails
  has_many :photos

  validates_presence_of :email

  after_create :create_sender_email

  devise :omniauthable
  notification_recipient

  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    if user = User.where(:email => data["email"]).first
      user
    else
      User.create!(:email => data["email"])
    end
  end

  def self.authorized
    where(authorized: true)
  end

  def self.with_email(email_address)
    joins(:sender_emails).where(['sender_emails.address = ?', email_address]).first
  end

  def display_name
    name || email
  end

  private

  def create_sender_email
    sender_emails.create address: email
  end
end
