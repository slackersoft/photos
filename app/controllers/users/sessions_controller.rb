class Users::SessionsController < ApplicationController
  def new
    sign_in_and_redirect User.first
    #redirect_to root_path
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
