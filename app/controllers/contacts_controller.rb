class ContactsController < ApplicationController
  before_action :devise_variant
  
  def index
    @contact = Contact.new
  end
 
  def confirm
    @contact = Contact.new(contact_params)
    if @contact.valid?
      render :action => 'confirm'
    else
      render :action => 'index'
    end
  end
 
  def done
    @contact = Contact.new(contact_params)
    if params[:back]
      render :action => 'index'
    else
      ContactMailer.received_email(@contact).deliver_now
      ContactMailer.send_when_contact(@contact).deliver
      render :action => 'done'
    end
  end
  
  private
  def contact_params
    params.require(:contact).permit(:name, :email, :content, :category)
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
