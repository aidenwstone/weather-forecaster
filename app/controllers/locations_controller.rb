class LocationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @locations = current_user.locations
  end

  def new
    @location = Location.new
  end

  def create
    @location = current_user.locations.build(allowed_location_params)

    if @location.save
      redirect_to locations_path, notice: "Location successfully added!"
    else
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
