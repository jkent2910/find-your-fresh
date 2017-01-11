class RegistrationsController < Devise::RegistrationsController


  def new
    super
  end

  def index
    super
  end

  def show
    super
  end

  def edit
    super
  end

  def create
    super
  end


  def update
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_type)
  end

end