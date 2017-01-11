class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if resource.farmer?
      if resource.farm.nil?
        :new_farm
      else
        farm_path(resource.farm)
      end
    elsif resource.consumer?
      farms_path
    end
  end

end
