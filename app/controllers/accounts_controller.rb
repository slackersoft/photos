class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def show
    current_user.build_notification_preference unless current_user.notification_preference
    if flash[:form_errors] && flash[:form_errors][:notification_preference]
      flash[:form_errors][:notification_preference].each do |attribute, errors|
        errors.each { |err| current_user.notification_preference.errors.add(attribute, err) }
      end
    end
  end

  def update
    current_user.name = params[:user][:name]
    current_user.save!

    redirect_to root_path
  end
end
