class SessionsController < ApplicationController 
  def login
  end

  def create
     user = User.find_by_email(params[:email])
     if user && user.authenticate(params[:password])
       session[:id] = user.id
       redirect_to root_path,
       notice: "Welcome back #{user.first_name.titleize}."
      else
        flash[:error] = 'Invalid email or password'
        render :login
      end
    end

    def destroy 
      if user = current_user
        session[:id] = nil
        redirect_to root_path,
        notice: "#{user.email} has been logged out."
      end
    end

    def oauth
      @user = User.where(
        email: omniauth_options[:email]
        ).first_or_initialize(omniauth_options)
      if @user.persisted?
        session[:id] = @user.id
        redirect_to root_path,
          notice: "Welcome back #{@user.first_name.titleize}. "
      else
          render "users/new"
      end
    end
end

private

def omniauth_options
   if auth_hash = request.env['omniauth.auth']
    first_name, last_name = auth_hash[:info][:name].split(/\s+/, 2)
    {
      email: auth_has(:info)[:email],
      first_name: first_name,
      last_name: last_name,
      omniauth: true
    }
  end
end