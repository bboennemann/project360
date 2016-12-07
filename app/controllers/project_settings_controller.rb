class ProjectSettingsController < ApplicationController
  before_action :set_project_setting, only: [:show, :edit, :update, :destroy]

  # GET /project_settings
  # GET /project_settings.json
  def index
    @project_settings = ProjectSetting.all
  end

  # GET /project_settings/1
  # GET /project_settings/1.json
  def show
  end

  # GET /project_settings/new
  def new
    @project_setting = ProjectSetting.new
  end

  # GET /project_settings/1/edit
  def edit
  end

  # POST /project_settings
  # POST /project_settings.json
  def create
    @project_setting = ProjectSetting.new(project_setting_params)

    respond_to do |format|
      if @project_setting.save
        format.html { redirect_to @project_setting, notice: 'Project setting was successfully created.' }
        format.json { render :show, status: :created, location: @project_setting }
      else
        format.html { render :new }
        format.json { render json: @project_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_settings/1
  # PATCH/PUT /project_settings/1.json
  def update
    respond_to do |format|
      if @project_setting.update(project_setting_params)
        format.html { redirect_to @project_setting, notice: 'Project setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_setting }
      else
        format.html { render :edit }
        format.json { render json: @project_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_settings/1
  # DELETE /project_settings/1.json
  def destroy
    @project_setting.destroy
    respond_to do |format|
      format.html { redirect_to project_settings_url, notice: 'Project setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_setting
      @project_setting = ProjectSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_setting_params
      params.require(:project_setting).permit(:default_hours_per_day, :workdays, :default_currency, :project_id, :organization_id, :client_id, :department_id)
    end
end
