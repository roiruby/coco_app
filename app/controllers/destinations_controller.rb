class DestinationsController < ApplicationController
  before_action :require_user_logged_in, only: [:create]
  
  def create
    @id = destination_id
    @destination = current_user.destinations.build(destination_params)
    if @destination.save
      flash[:success] = 'イベントを投稿しました。'
      redirect_to root_path
    else
      flash.now[:danger] = 'イベントの投稿に失敗しました。'
      render 'toppages/index'
    end
  end
  

  private

  def destination_params
    params.require(:destination).permit(:name, :_destroy, :prefecture_id, :city_id, :spot_id)
  end
  
end
