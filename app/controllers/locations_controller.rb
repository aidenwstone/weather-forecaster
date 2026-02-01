class LocationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @location = current_user.locations.find(params[:id])
    @weather = WeatherFetcher.call(@location.latitude, @location.longitude, @location.timezone)
  end

  def index
    @locations = current_user.locations
  end

  def new
    @location = Location.new
  end

  def create
    @location = current_user.locations.build(allowed_location_params)

    unless @location.valid?
      render :new, status: :unprocessable_content
      return
    end

    location_data = LocationFinder.call(@location.address, @location.ip_address)

    if location_data
      @location.assign_attributes(location_data)
      @location.save
      redirect_to locations_path, notice: "Location successfully added!"
    else
      @location.errors.add(:base, "That location couldn't be found. Maybe try again later.")
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    @location = current_user.locations.find(params[:id])

    @location.destroy
    redirect_to locations_path, notice: "Location was successfully deleted!"
  end

  private

  def allowed_location_params
    params.expect(location: [ :address, :ip_address, :nickname ])
  end
end
