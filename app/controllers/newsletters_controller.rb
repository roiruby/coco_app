class NewslettersController < ApplicationController
  before_action :require_user_logged_in
  before_action :admin_user, only: [:new, :index, :show, :create, :edit, :update, :destroy]
  before_action :devise_variant
  
  def index
    @newsletter = Newsletter.all.page(params[:page]).per(10).reverse_order
    @user = current_user
  end

  def show
    @newsletter = Newsletter.find(params[:id])
    @newsletters = Newsletter.all.reverse_order.limit(6)
  end

  def new
    @newsletter = current_user.newsletters.build
  end

  def create
    @newsletter = current_user.newsletters.build(newsletter_params)
    if @newsletter.save
      flash[:success] = 'メルマガを送信しました。'
      NewsletterMailer.send_newsletter(@newsletter).deliver_now
      redirect_to root_url
    else
      @newsletter = current_user.newsletters.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メルマガの送信に失敗しました。'
      render 'toppages/index'
    end
  end

  def edit
    @newsletter = Newsletter.find(params[:id])
  end

  def update
    @newsletter = Newsletter.find(params[:id])

    if @newsletter.update(newsletter_params)
      redirect_to newsletter_path
    else
      flash.now[:danger] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @newsletter = Newsletter.find(params[:id])
    @newsletter.destroy
    flash[:success] = 'メルマガを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def newsletter_params
    params.require(:newsletter).permit(:user_id, :title, :content)
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
