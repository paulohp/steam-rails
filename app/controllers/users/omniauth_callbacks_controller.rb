class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :redirect_to_login_if_required

  def steam
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_steam_oauth(request.env["omniauth.auth"].except("extra"), current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Steam") if is_navigational_format?
    else
      session["devise.steam_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.steam_data"] && session["devise.steam_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end