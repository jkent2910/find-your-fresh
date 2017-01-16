class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_timezone


  def after_sign_in_path_for(resource)
    if resource.farmer?
      if resource.farm.nil?
        :new_farm
      else
        farm_path(resource.farm)
      end
    elsif resource.consumer?
      if resource.profile.nil?
        :new_profile
      else
        farms_path
      end
    end
  end


  def set_timezone
    Time.zone = 'America/Chicago'
  end

end
