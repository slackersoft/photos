class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def update
    current_user.name = params[:user][:name]
    current_user.save!

    redirect_to root_path
  end
end
