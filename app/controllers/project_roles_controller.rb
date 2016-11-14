class ProjectRolesController < ApplicationController
  before_action :set_project_role, only: [:show, :edit, :update, :destroy]

  # GET /project_roles
  # GET /project_roles.json
  def index
    @project_roles = ProjectRole.all
  end

  # GET /project_roles/1
  # GET /project_roles/1.json
  def show
  end

  def assign
    @project_role = ProjectRole.new
    @users = User.where(organization_id: current_user.organization_id)
  end

  # GET /project_roles/new
  def new
    logger.debug project_role_params[:project_id].to_s
    @user = User.where(id: project_role_params[:user_id])
    @project = Project.where(id: project_role_params[:project_id])
    @project_role = ProjectRole.new(project_role_params)
    @roles = Role.where(organization_id: current_user.organization_id)
  end

  # GET /project_roles/1/edit
  def edit
  end

  # POST /project_roles
  # POST /project_roles.json
  def create
    @project_role = ProjectRole.new(project_role_params)

    respond_to do |format|
      if @project_role.save
        format.html { redirect_to @project_role, notice: 'Project role was successfully created.' }
        format.json { render :show, status: :created, location: @project_role }
      else
        format.html { render :new }
        format.json { render json: @project_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_roles/1
  # PATCH/PUT /project_roles/1.json
  def update
    respond_to do |format|
      if @project_role.update(project_role_params)
        format.html { redirect_to @project_role, notice: 'Project role was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_role }
      else
        format.html { render :edit }
        format.json { render json: @project_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_roles/1
  # DELETE /project_roles/1.json
  def destroy
    @project_role.destroy
    respond_to do |format|
      format.html { redirect_to project_roles_url, notice: 'Project role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_role
      @project_role = ProjectRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_role_params
      params.require(:project_role).permit(:rate, :cost, :project_id, :user_id, :role_id)
    end
end
