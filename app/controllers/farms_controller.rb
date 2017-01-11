class FarmsController < ApplicationController

  before_action :set_farm, only: [:show, :edit, :update, :destroy]
  before_action :check_for_existing_farm, only: [:new, :create]
  before_action :ensure_farm_ownership, only: [:edit, :update, :destroy]

  def index
    @farms = Farm.all
  end

  def show
  end

  def new
    @farm = Farm.new
  end

  def create
    @farm = Farm.new(farm_params)
    @farm.user = current_user

    if @farm.save
      redirect_to farm_path(@farm), notice: "Farm created!"
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @farm.destroy
    redirect_to root_path, notice: "Farm deleted!"
  end

  private

  def set_farm
    @farm = Farm.find(params[:id])
  end

  def check_for_existing_farm
    if current_user.farm
      redirect_to current_user.farm, notice: "You've already created a farm"
    end
  end

  def ensure_farm_ownership
    if current_user != Farm.find(params[:id]).user
      redirect_to root_path, notice: "You aren't allowed to perform that action"
    end
  end

  def farm_params
    params.require(:farm).permit(:name, :street_address, :city, :state, :zipcode, :description, :year_founded,
                                  :website_url, :contact_email, :contact_phone)
  end

end