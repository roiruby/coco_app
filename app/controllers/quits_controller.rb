class QuitsController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :new, :create]
  before_action :admin_user, only: :index
  before_action :devise_variant
  
  def index
    @quits = Quit.all.reverse_order.page(params[:page]).per(20)
  end
  
  def new
    @quit = Quit.new
    @user = current_user
  end

  def create
    @user = current_user
    @quit = Quit.new(quit_params)
    if @quit.save
      QuitMailer.quit_mail(@quit, @user).deliver
      QuitMailer.send_quit_mail(@quit, @user).deliver
      flash[:success] = '退会申請を受け付けました'
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def quit_params
    params.require(:quit).permit(:content, :user_id)
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
