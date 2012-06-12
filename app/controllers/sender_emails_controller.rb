class SenderEmailsController < ApplicationController
  before_filter :authenticate_user!

  def create
    current_user.sender_emails.create params[:sender_email]
    redirect_to account_path
  end

  def destroy
    emails = current_user.sender_emails.where(id: params[:id])
    emails.destroy_all
    redirect_to account_path
  end
end
