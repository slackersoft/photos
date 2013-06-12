module LetMeKnow
  class PreferencesController < ActionController::Base
    protect_from_forgery
    before_filter :authenticate_user!

    def create
      update_preference current_user.build_notification_preference
    end

    def update
      update_preference current_user.notification_preference
    end

    private

    def update_preference(preference)
      preference.send_notifications = params[:let_me_know_preference][:send_notifications]
      preference.schedule = params[:let_me_know_preference][:schedule]
      unless preference.save
        flash[:form_errors] = { notification_preference: preference.errors.messages }
      end
      redirect_to :back
    end
  end
end
