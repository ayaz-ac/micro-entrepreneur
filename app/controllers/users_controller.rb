# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit; end

  def update
    current_user.update!(user_params)

    redirect_to root_path, notice: 'Votre TJM a bien été modifié!'
  end

  private

  def user_params
    params.require(:user).permit(:average_daily_rate)
  end
end
