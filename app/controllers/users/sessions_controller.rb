class Users::SessionsController < ApplicationController
  def new
    if Rails.env.development?
      sign_in_and_redirect User.first
    else
      redirect_to root_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
