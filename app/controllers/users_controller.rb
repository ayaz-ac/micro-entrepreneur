# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit; end

  def update
    if user_params[:password].present?
      current_user.update!(user_params)
    else
      current_user.update!(user_params.except(:password, :password_confirmation))
    end

    redirect_to root_path, notice: t('.sucessful')
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :average_daily_rate)
  end
end
