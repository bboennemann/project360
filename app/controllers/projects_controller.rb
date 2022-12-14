class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.where(department_id: current_user.department_id)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    session[:project_id] = @project.id
    @project_roles = @project.project_roles
    @forecasts = @project.forecasts
  end

  # GET /projects/new
  def new
    @project = Project.new
    @client = Client.find(params[:client_id])
  end

  # GET /projects/1/edit
  def edit
    @client = Client.find(session[:client_id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.project_setting = @project.client.project_setting.clone
    @project.project_setting.update(project_id: @project.id, client_id: nil)

    respond_to do |format|
      if @project.save
        @project.project_setting.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    client_id = @project.client_id
    @project.destroy
    respond_to do |format|
      format.html { redirect_to clients_path(client_id), notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :start_date, :end_date, :active, :client_id, :department_id, :contract_value)
    end
end
