class SenderEmail < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :address
  validates_uniqueness_of :address, :message => 'has been claimed by another account'
  validates_format_of :address, :allow_blank => true, :with => Devise.email_regexp
end
