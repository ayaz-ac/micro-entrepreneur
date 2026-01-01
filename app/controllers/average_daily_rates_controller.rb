# frozen_string_literal: true

class AverageDailyRatesController < AuthenticatedController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(average_daily_rate_params)
      render :edit, status: :ok
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def average_daily_rate_params
    params.require(:user).permit(:average_daily_rate)
  end
end
