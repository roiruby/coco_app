class EntriesController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_entry, only: [:show, :edit, :update, :toggle_status]
  
  def create
    post = Post.find(params[:post_id])
    current_user.offer(post)
    EntryMailer.entry_notification(current_user, post).deliver_now
    post.create_notification_entry!(current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    post = Post.find(params[:post_id])
    current_user.unoffer(post)
    redirect_back(fallback_location: root_path)
  end    


  def toggle_status
    @entry.toggle_status!
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def entry_params
    params.require(:entry).permit(:entry_status)
  end
  
  def set_entry
    @entry = Entry.find(params[:id] || params[:entry_id])
  end
  
end
