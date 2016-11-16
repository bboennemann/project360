class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.where(organization_id: current_user.organization_id)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def new
    @user = User.new
    @roles = Role.all
    @department_id = params[:department_id]
  end

  # GET /users/1/edit
  def edit
    @roles = Role.all
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    @user.organization_id = current_user.organization_id
    @user.department_id = params[:department_id] # why can't I use user_params??? Doesn;t work!

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'user was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :rate, :cost, :organization_id, :department_id, :password, :password_confirmation)
    end
end
