class NotificationPreferencesController < ApplicationController
  before_filter :authenticate_user!

  def create
    current_user.create_notification_preference!(params[:notification_preference])
    redirect_to account_path
  end

  def update
    current_user.notification_preference.update_attributes!(params[:notification_preference])
    redirect_to account_path
  end
end
