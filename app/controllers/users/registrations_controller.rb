# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  
  # GET /resource/sign_up


  def new
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)
    if @user.valid?
      session["devise.regist_data"] = {user: @user.attributes}
      session["devise.regist_data"][:user]["password"] = params[:user][:password]
      redirect_to profiles_path
    else
      render :new
    end
  end

  def new_profile
    @user = User.new(session["devise.regist_data"]["user"])
    @profile = Profile.new     
  end
  
  def create_profile
    @user = User.new(session["devise.regist_data"]["user"])
    @profile = Profile.new(profile_params)
    if @profile.valid?
      @user.save
      @profile = Profile.new(profile_params.merge(user_id: @user.id))
      @profile.save 
      session["devise.regist_data"]["user"].clear
      sign_in(:user, @user)
    else
      render :new_profile
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def profile_params
    params[:profile].permit(:email_publish, :nickname, :site, :company, :residence, :profile, :twitter, :facebook)
  end
  

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
