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
    if params[:start_date]
      @start_date = params[:start_date].to_date
    else
      @start_date = Date.today
    end

    params[:weeks] ? @weeks = params[:weeks].to_i : @weeks = 1
    @weeks > 10 ? @weeks = 10 : nil
    @days = @weeks * 7

    logger.debug @days

    #! This seems to be very inefficcient. Load times are pretty long
    @user_ids = ProjectRole.where(project_id: @forecast.project_id).distinct(:user_id)
    #@users = User.in(id: users).all
    @user_forecasts = UserForecast.in(user_id: @user_ids).or(UserForecast.where(project_id: @forecast.project_id, approval_status: "requested").selector, UserForecast.where(approval_status: "approved").selector).order_by(user_id: :asc).all


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
    if params[:start_date]
      @start_date = params[:start_date].to_date
    else
      @start_date = Date.today
    end

    params[:weeks] ? @weeks = params[:weeks].to_i : @weeks = 1
    @weeks > 10 ? @weeks = 10 : nil
    @days = @weeks * 7
    
    @user_forecasts = UserForecast.where(forecast_id: @forecast.id).order_by(:user_id => :desc).all

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

    if params[:start_date]
      @start_date = params[:start_date].to_date
    else
      @start_date = Date.today
    end

    params[:weeks] ? @weeks = params[:weeks].to_i : @weeks = 1
    @weeks > 10 ? @weeks = 10 : nil
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
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast
      @forecast = Forecast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forecast_params
      params.require(:forecast).permit(:name, :revision, :project_id, :published, :approval_status)
    end
end
