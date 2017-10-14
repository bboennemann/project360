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
    if params[:start_date]
      @start_date = params[:start_date].to_date
    else
      @start_date = Date.today
    end

    @user_forecasts = UserForecast.where(user_id: @user_forecast.user.id, approval_status: "approved")
  end



  # GET /user_forecasts/new
  def new
    @user_forecast = UserForecast.new
  end



  # GET /user_forecasts/1/edit
  def edit
  end



  def update_time_entry

    @entry_date = user_forecast_params[:time_entries_attributes].values[0][:entry_date].to_date
    
    hours = user_forecast_params[:time_entries_attributes].values[0][:hours]
    if hours.empty?
      hours = 0.0
    end

    #! Needs cleanup and performamce review
    if UserForecast.where(forecast_id: user_forecast_params[:forecast_id] , project_role_id: user_forecast_params[:project_role_id]).exists?
      
      @user_forecast = UserForecast.find_by(forecast_id: user_forecast_params[:forecast_id] , project_role_id: user_forecast_params[:project_role_id])
      @forecast = @user_forecast.forecast


      time_entry = @user_forecast.time_entries.detect {|te| te.entry_date == @entry_date.to_date}
      if time_entry.nil?
        update
      else
        
        @user_forecast.total_hours +=  hours.to_f - time_entry.hours
        @user_forecast.update

        @user_forecast.forecast.total_hours +=  hours.to_f - time_entry.hours
        @user_forecast.forecast.update
        
        respond_to do |format|
          if time_entry.update_attributes(hours: hours)           

            #format.html { redirect_to @user_forecast, notice: 'User forecast was successfully created.' }
            format.json { render :show, status: :created, location: time_entry }
          else
            #format.html { render :new }
            format.json { render json: time_entry.errors, status: :unprocessable_entity }
          end

        end

      end

    else
      create
    end
  end



  # POST /user_forecasts
  # POST /user_forecasts.json
  def create

    @user_forecast = UserForecast.new(user_forecast_params)
    @forecast = Forecast.find(user_forecast_params[:forecast_id])

    @user_forecast.forecast.total_hours += user_forecast_params[:time_entries_attributes].values[0][:hours].to_f
    @user_forecast.forecast.update

    # set initial total value based on initial time entry
    @user_forecast.total_hours += user_forecast_params[:time_entries_attributes].values[0][:hours].to_f
    
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
    @user_forecast.forecast.total_hours += user_forecast_params[:time_entries_attributes].values[0][:hours].to_f
    @user_forecast.forecast.update

    @user_forecast.total_hours += user_forecast_params[:time_entries_attributes].values[0][:hours].to_f
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
      params.require(:user_forecast).permit(:published, :user_id, :project_id, :forecast_id, :project_role_id, time_entries_attributes: [:entry_date, :hours])
    end
end
