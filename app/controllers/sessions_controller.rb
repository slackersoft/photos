class SessionsController < ApplicationController
  def new
    redirect_to root_path
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
