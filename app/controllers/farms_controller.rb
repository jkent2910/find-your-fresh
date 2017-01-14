class FarmsController < ApplicationController

  before_action :set_farm, only: [:show, :edit, :update, :destroy]
  before_action :check_for_existing_farm, only: [:new, :create]
  before_action :ensure_farm_ownership, only: [:edit, :update, :destroy]

  def index
    @location_search_results = []

    @pickup_location_search_results = []

    unless params[:q].nil?
      params[:q].delete(:shares_organic_true) if params[:q][:shares_organic_true] == '0'
      params[:q].delete(:shares_taking_orders_true) if params[:q][:shares_taking_orders_true] == '0'

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

      if params[:pickup_miles].present? && params[:pickup_zipcode].blank?
        redirect_to farms_path, notice: "To search by location, you must enter both a zipcode and a mile radius"
      elsif params[:pickup_zipcode].present? && params[:pickup_miles].blank?
        if !/^[A-z]/.match(params[:pickup_zipcode]).nil?
          redirect_to farms_path, notice: "You must enter a valid zipcode"
        else
          params[:pickup_miles] = 0
          location_results = Location.near(params[:pickup_zipcode], params[:pickup_miles])
          location_results.each do |l|
            share = Share.find(l.share_id)
            @pickup_location_search_results << Farm.find(share.farm_id)
          end
        end
      elsif params[:pickup_miles].present? && params[:pickup_zipcode].present?
        if !/^[A-z]/.match(params[:pickup_zipcode]).nil?
          redirect_to farms_path, notice: "You must enter a valid zipcode"
        elsif !/^[A-z]/.match(params[:pickup_miles]).nil?
          redirect_to farms_path, notice: "You must enter a valid number of miles"
        else
          location_results = Location.near(params[:pickup_zipcode], params[:pickup_miles])
          location_results.each do |l|
            share = Share.find(l.share_id)
            @pickup_location_search_results << Farm.find(share.farm_id)
          end
        end
      end

    end

    @q = Farm.ransack(params[:q])

    if @location_search_results.empty? && params[:miles].present? && params[:zipcode].present?
      @farms = []
    elsif @pickup_location_search_results.empty? && params[:pickup_miles].present? && params[:pickup_zipcode].present?
      @farms = []
    else
      if @location_search_results.empty? && @pickup_location_search_results.empty?
        @farms = @q.result
      elsif !@location_search_results.empty? && @pickup_location_search_results.empty?
        @farms = @q.result.joins(:locations).merge(@location_search_results)
      elsif @location_search_results.empty? && !@pickup_location_search_results.empty?
        @farms = @q.result.joins(:shares).merge(@pickup_location_search_results)
      elsif !@location_search_results.empty? && !@pickup_location_search_results.empty?
        @farms = @q.result.joins(:locations).merge(@pickup_location_search_results).merge(@location_search_results)
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
                                  vegetables: [], locations_attributes:[:id, :street_address, :city, :state, :zipcode, :start_time,
                                  :end_time, :other_info, :day_of_week, :frequency, :_destroy]], add_ons_attributes: [:id, :item, :description, :price, :_destroy])
  end

end