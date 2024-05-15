# frozen_string_literal: true

class UsersController < AuthenticatedController
  before_action :authenticate_user!
  before_action :find_user

  def edit; end

  def update
    if user_params[:password].present?
      update_password
    elsif @user.update(user_params.except(:current_password, :password, :password_confirmation))
      redirect_to root_path, notice: t('.successful')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :current_password, :password, :password_confirmation, :average_daily_rate)
  end

  def find_user
    @user = current_user
  end

  def update_password
    if @user.update_with_password(user_params)
      bypass_sign_in(@user)

      redirect_to root_path, notice: t('.successful')
    else
      render :edit
    end
  end
end
