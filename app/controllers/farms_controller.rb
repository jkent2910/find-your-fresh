class FarmsController < ApplicationController

  before_action :set_farm, only: [:show, :edit, :update, :destroy]
  before_action :check_for_existing_farm, only: [:new, :create]
  before_action :ensure_farm_ownership, only: [:edit, :update, :destroy]

  def index
    @location_search_results = []

    unless params[:q].nil?
      params[:q].delete(:organic_true) if params[:q][:organic_true] == '0'
      params[:q].delete(:taking_orders_true) if params[:q][:taking_orders_true] == '0'

      if params[:q][:start_date_eq].present?
        params[:q][:start_date_eq].to_date.strftime("%Y-%m-%d")
      end

      if params[:miles].present? && params[:zipcode].blank?
        redirect_to farms_path, notice: "To search by location, you must enter both a zipcode and a mile radius"
      elsif params[:zipcode].present? && params[:miles].blank?
        if !/^[A-z]/.match(params[:zipcode]).nil?
          redirect_to farms_path, notice: "You must enter a valid zipcode"
        else
          params[:miles] = 0
          @location_search_results = Farm.near(params[:zipcode], params[:miles])
        end
      elsif params[:miles].present? && params[:zipcode].present?
        if !/^[A-z]/.match(params[:zipcode]).nil?
          redirect_to farms_path, notice: "You must enter a valid zipcode"
        elsif !/^[A-z]/.match(params[:miles]).nil?
          redirect_to farms_path, notice: "You must enter a valid number of miles"
        else
          @location_search_results = Farm.near(params[:zipcode], params[:miles])
        end
      end

    end

    @q = Farm.ransack(params[:q])

    if @location_search_results.empty? && params[:miles].present? && params[:zipcode].present?
      @farms = []
    else
      if @location_search_results.empty?
        @farms = @q.result
      else
        @farms = @q.result.merge(@location_search_results)
      end
    end
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
      if params[:images]
        params[:images].each { |image|
          @farm.farm_photos.create(image: image)
        }
      end
      redirect_to farm_path(@farm), notice: "Farm created!"
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @farm.update(farm_params)

        # Build photos
        if params[:images]
          params[:images].each { |image|
            @farm.farm_photos.create(image: image)
          }
        end

        # Build vegetables
        if params[:share][:vegetables]
          share = Share.find(params[:share_id])
          share.update_attributes(vegetables: params[:share][:vegetables])
        end


        format.html { redirect_to farm_path(@farm), notice: "Farm updated" }
      else
        format.html { render :edit }
      end
    end
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
                                  :website_url, :contact_email, :contact_phone, shares_attributes: [:id, :_destroy, :season,
                                  :start_date, :end_date, :weeks, :price, :description, :num_shares, :organic, :taking_orders,
                                  vegetables: []], add_ons_attributes: [:id, :item, :description, :price, :_destroy])
  end

end