class InformationsController < ApplicationController
  before_action :require_user_logged_in
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :devise_variant
  
  def index
    @news = Information.all.page(params[:page]).per(10).reverse_order
    @user = current_user
  end

  def show
    @news = Information.find(params[:id])
    @info = Information.all.reverse_order.limit(6)
  end

  def new
    @news = current_user.informations.build
  end

  def create
    @news = current_user.informations.build(information_params)
    if @news.save
      flash[:success] = 'お知らせを作成しました。'
      redirect_to root_url
    else
      @news = current_user.informations.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'お知らせの作成に失敗しました。'
      render 'toppages/index'
    end
  end

  def edit
    @news = Information.find(params[:id])
  end

  def update
    @news = Information.find(params[:id])

    if @news.update(information_params)
      redirect_to information_path
    else
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end
  end

  def destroy
    @news = Information.find(params[:id])
    @news.destroy
    flash[:success] = 'お知らせを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def information_params
    params.require(:information).permit(:user_id, :title, :content)
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  def devise_variant
      case request.user_agent
      when /iPhone/
        request.variant = :mobile
      when /android/
        request.variant = :android
      end
  end
end
