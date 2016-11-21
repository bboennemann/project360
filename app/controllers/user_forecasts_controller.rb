class UserForecastsController < ApplicationController
  before_action :set_user_forecast, only: [:show, :edit, :update, :destroy]

  # GET /user_forecasts
  # GET /user_forecasts.json
  def index
    @user_forecasts = UserForecast.all
  end

  # GET /user_forecasts/1
  # GET /user_forecasts/1.json
  def show
  end

  # GET /user_forecasts/new
  def new
    @user_forecast = UserForecast.new
  end

  # GET /user_forecasts/1/edit
  def edit
  end

  # POST /user_forecasts
  # POST /user_forecasts.json
  def create
    @user_forecast = UserForecast.new(user_forecast_params)

    respond_to do |format|
      if @user_forecast.save
        format.html { redirect_to @user_forecast, notice: 'User forecast was successfully created.' }
        format.json { render :show, status: :created, location: @user_forecast }
      else
        format.html { render :new }
        format.json { render json: @user_forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_forecasts/1
  # PATCH/PUT /user_forecasts/1.json
  def update
    respond_to do |format|
      if @user_forecast.update(user_forecast_params)
        format.html { redirect_to @user_forecast, notice: 'User forecast was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_forecast }
      else
        format.html { render :edit }
        format.json { render json: @user_forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_forecasts/1
  # DELETE /user_forecasts/1.json
  def destroy
    @user_forecast.destroy
    respond_to do |format|
      format.html { redirect_to user_forecasts_url, notice: 'User forecast was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_forecast
      @user_forecast = UserForecast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_forecast_params
      params.require(:user_forecast).permit(:timeentry, :published)
    end
end
