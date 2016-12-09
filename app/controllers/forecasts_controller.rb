class ForecastsController < ApplicationController
  before_action :set_forecast, only: [:show, :edit, :update, :destroy, :approval, :clone, :review]

  # POST /forecast/1/approval
  def approval
    approval_status = forecast_params[:approval_status]
    Forecast.where(project_id: @forecast.project_id, approval_status: approval_status).update_all(approval_status: nil)
    UserForecast.where(project_id: @forecast.project_id, approval_status: approval_status).update_all(approval_status: nil)
    UserForecast.where(forecast_id: @forecast.id).update_all(approval_status: approval_status)
    @forecast.update(approval_status: approval_status)
    respond_to do |format|
        format.html { redirect_to :action => 'edit', :id => @forecast.id, notice: 'Forecast was successfully published.' }
        format.json { render :show, status: :created, location: @forecast }
      end
  end

  # GET /forecast/1/review
  def review
    @start_date = first_day_of_week

    params[:weeks] ? @weeks = params[:weeks].to_i : @weeks = 1
    @weeks > 10 ? @weeks = 10 : nil
    @days = @weeks * 7

    logger.debug @days

    
    @user_ids = UserForecast.where(project_id: @forecast.project_id).distinct(:user_id)
    
    #! Need filtering on only approved & approval requested for current project
    @users = User.in(id: @user_ids).all


  end


  def clone
    new_forecast = @forecast.clone
    new_forecast.revision = @forecast.revision + 1
    new_forecast.approval_status = nil

    @forecast.user_forecasts.each do |user_forecast|
      new_user_forecast = user_forecast.clone
      user_forecast.approval_status = nil
      new_user_forecast.forecast_id = new_forecast.id
      new_user_forecast.save
    end

    respond_to do |format|
      if new_forecast.save
        format.html { redirect_to :controller => 'projects', :action => 'show', :id => @forecast.project.id, success: 'Forecast was successfully cloned.' }
        #format.json { render :show, status: :created, location: @forecast }
      else
        format.html { redirect_to :controller => 'projects', :action => 'show', :id => @forecast.project.id, notice: 'There was a problem cloning this forecast.' }
        #format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /forecasts
  # GET /forecasts.json
  def index
    @forecasts = Forecast.all
  end

  # GET /forecasts/1
  # GET /forecasts/1.json
  def show

    params[:periods] ? @periods = params[:periods].to_i : @periods = 5

    if params[:period_type] == "week"
      @period_type = "week"
      @start_date = first_day_of_week
      @periods > 24 ? @periods = 24 : nil
    elsif params[:period_type] == "month"
      params[:start_date] ? @start_date = params[:start_date] : @start_date = Date.today
      @period_type = "month"
      @periods > 12 ? @periods = 12 : nil
    elsif params[:period_type] == "custom"
      @start_date = params[:start_date].to_date
      @end_date = params[:end_date].to_date
      @period_type = "custom"
      @periods = 1
    else
      @start_date = first_day_of_week
      params[:weeks] ? @weeks = params[:weeks].to_i : @weeks = 1
      @weeks > 12 ? @weeks = 12 : nil
      @days = @weeks * 7
      @period_type = "day"
    end

    @start_date = @start_date.to_date
    
    @user_forecasts = UserForecast.where(forecast_id: @forecast.id).order_by(:'time_entries.entry_date'.asc).all
    @project_roles = ProjectRole.not_in(id: @user_forecasts.map { |fc| fc.project_role.id }).and(project_id: @forecast.project_id).all
  end


  # GET /forecasts/new
  def new
    @forecast = Forecast.new
    @project_id = params[:project_id]
    @project = Project.find(@project_id)
    @project_roles = ProjectRole.where(project_id: @project_id).all    
  end


  # GET /forecasts/1/edit
  def edit
    if @forecast.approval_status == "approved"
      redirect_to @forecast, notice: 'This forecast is locked for editing.'
    end

    @start_date = first_day_of_week

    params[:weeks] ? @weeks = params[:weeks].to_i : @weeks = 1
    @weeks > 12 ? @weeks = 12 : nil
    @days = @weeks * 7

    
    @user_forecasts = UserForecast.where(forecast_id: @forecast.id).order_by(:user_id => :desc).all

    @project_roles = ProjectRole.not_in(id: @user_forecasts.map { |fc| fc.project_role.id }).and(project_id: @forecast.project_id).all
  end

  # POST /forecasts
  # POST /forecasts.json
  def create
    @forecast = Forecast.new(forecast_params)
    @forecast.user_id = current_user.id

    respond_to do |format|
      if @forecast.save
        format.html { redirect_to :action => 'edit', :id => @forecast.id, notice: 'Forecast was successfully created.' }
        format.json { render :show, status: :created, location: @forecast }
      else
        format.html { render :new }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forecasts/1
  # PATCH/PUT /forecasts/1.json
  def update
    respond_to do |format|
      if @forecast.update(forecast_params)
        format.html { redirect_to @forecast, notice: 'Forecast was successfully updated.' }
        format.json { render :show, status: :ok, location: @forecast }
      else
        format.html { render :edit }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forecasts/1
  # DELETE /forecasts/1.json
  def destroy
    @forecast.destroy
    respond_to do |format|
      format.html { redirect_to forecasts_url, notice: 'Forecast was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def first_day_of_week
      if params[:start_date]
        @start_date = params[:start_date].to_date - params[:start_date].to_date.cwday + 1
      else
        @start_date = Date.today - Date.today.cwday + 1
      end
    end

    def first_day_of_month
      if params[:start_date]
        @start_date = params[:start_date].to_date  - Date.today.cwday + 1
      else
        @start_date = Date.today - Date.today.cwday + 1
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_forecast
      @forecast = Forecast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forecast_params
      params.require(:forecast).permit(:name, :revision, :project_id, :published, :approval_status)
    end
end
