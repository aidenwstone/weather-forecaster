class LocationsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
  end

  def create
  end

  def destroy
  end

  private

  def allowed_location_params
    params.expect(location: [ :address, :ip_address, :nickname ])
  end
end
