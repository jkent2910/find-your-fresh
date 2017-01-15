class ProfilesController < ApplicationController

  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :check_for_existing_profile, only: [:new, :create]
  before_action :ensure_profile_ownership, only: [:edit, :update, :destroy]

  def show
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user

    if @profile.save
      redirect_to farms_path, notice: "Profile created!"
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)

        format.html { redirect_to profile_path(@profile), notice: "Profile updated" }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @profile.destroy
    redirect_to root_path, notice: "Profile deleted!"
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def check_for_existing_profile
    if current_user.profile
      redirect_to current_user.profile, notice: "You've already created a profile"
    end
  end

  def ensure_profile_ownership
    if current_user != Profile.find(params[:id]).user
      redirect_to root_path, notice: "You aren't allowed to perform that action"
    end
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :street_address, :city, :state, :zipcode, :latitude, :longitude,
                                    :gender, :bio, :looking_for_split, :looking_for_csa, :profile_picture)
  end

end