# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    unless params[:user].nil?

      if user_insert_email
        @user = User.find_by(email: params[:user][:login])
      else
        @user = User.find_by(username: params[:user][:login])
      end

    else

      if user_insert_email
        @user = User.find_by(email: params[:login])
      else
        @user = User.find_by(username: params[:login])
      end

    end

    puts "="*60
    respond_to do |format|
      if (!params[:user].nil? && @user && @user.valid_password?(params[:user][:password])) || (@user && @user.valid_password?(params[:password]))
        format.html{
          sign_in(@user)
          redirect_to @user.is_admin ? '/admin' : root_path,
          notice: "Successfully signed in!"
        }
      else
        format.html{
          render :new,
          alert: "Your identifiant is wrong, please try again"
        }
      end
    end

    puts "="*60
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def user_insert_email
    unless params[:user].nil?
      params.require(:user).permit(:login).each do |k, v|
        return v.include? "@"
      end
    else
      params.require(:login).include? "@"
    end
  end  
end
