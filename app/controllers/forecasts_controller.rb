class ForecastsController < ApplicationController
  before_action :set_forecast, only: [:show, :edit, :update, :destroy, :publish, :clone]

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
    
    @user_forecasts = UserForecast.where(forecast_id: @forecast.id).order_by(:user_id => :desc).all

    @project_roles = ProjectRole.not_in(id: @user_forecasts.map { |fc| fc.project_role.id }).and(project_id: @forecast.project_id).all
  end

  def clone
    new_forecast = @forecast.clone
    new_forecast.revision = @forecast.revision + 1

    @forecast.user_forecasts.each do |user_forecast|
      new_user_forecast = user_forecast.clone
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

  # GET /forecasts/new
  def new
    @forecast = Forecast.new
    @project_id = params[:project_id]
    @project = Project.find(@project_id)
    @project_roles = ProjectRole.where(project_id: @project_id).all
  end

  # GET /forecast/1/publish
  def publish
    Forecast.where(project_id: @forecast.project_id).update_all(published: false)
    UserForecast.where(project_id: @forecast.project_id).update_all(published: false)
    UserForecast.where(forecast_id: @forecast.id).update_all(published: !@forecast.published)
    @forecast.update(published: !@forecast.published)
    respond_to do |format|
        format.html { redirect_to :action => 'edit', :id => @forecast.id, notice: 'Forecast was successfully published.' }
        format.json { render :show, status: :created, location: @forecast }
      end
  end

  # GET /forecasts/1/edit
  def edit

    if params[:start_date]
      @start_date = params[:start_date].to_date
    else
      @start_date = Date.today
    end
    
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
      params.require(:forecast).permit(:name, :revision, :project_id, :published)
    end
end
