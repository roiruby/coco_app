class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated,     true)
      user.update_attribute(:activated_at,  Time.zone.now)
      log_in user
      UserMailer.send_account_activation(user).deliver_now
      flash[:success] = "アカウントを認証しました！"
      redirect_to mypage_path
    else
      flash[:danger] = "アカウントを認証できませんでした"
      redirect_to root_url
    end
  end
end
