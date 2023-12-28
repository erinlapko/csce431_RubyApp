class MembersController < ApplicationController
  before_action :set_member, only: %i[ show edit update destroy ]

  #GET /members or /members.json
  def index
    if params[:sort]
      @members = Member.order(params[:sort])
    elsif params[:reverse_sort]
        @members = Member.order(params[:reverse_sort]).reverse_order
    elsif params[:search]
      @members = search_members
    else
      @members = Member.paginate(:page => params[:page], :per_page => 15)
    end
  end
def search_members 
  if @member = Member.all.find{|member| member.name.include?(params[:search])} 
    # redirect_to member_path( @member )
    @members = Member.where("name LIKE ?", "%#{params[:search]}%")
  else
    # render html: "<script>alert('No users!')</script>".html_safe
    @members = Member.all
    redirect_to "/members"
    flash[:notice] = "No User Found."

  end 
end

  # GET /members/1 or /members/1.json
  def show
    @member = Member.find(params[:id]) 
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members or /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to member_url(@member), notice: "Member was successfully created." }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to member_url(@member), notice: "Member was successfully updated." }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1 or /members/1.json
  def destroy
    @member.destroy

    respond_to do |format|
      format.html { redirect_to members_url, notice: "Member was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end


    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:name, :email, :points, :degree, :division)
    end
end
