# frozen_string_literal: true

class AverageDailyRatesController < AuthenticatedController
  def edit
    @user = current_user
  end

  def update
    if current_user.update(average_daily_rate_params)
      flash.now[:notice] = t('.success')
    else
      flash.now[:alert] = resource.errors.full_messages
      render :edit, status: :unprocessable_content
    end
  end

  private

  def average_daily_rate_params
    params.require(:user).permit(:average_daily_rate)
  end
end
