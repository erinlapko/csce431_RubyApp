class AlumsController < ApplicationController
  before_action :set_alum, only: %i[ show edit update destroy ]

  # GET /alums or /alums.json
  def index
    if params[:sort]
      @alums = Alum.order(params[:sort])
    elsif params[:search]
      @alums = search_alums
    else
      @alums = Alum.paginate(:page => params[:page], :per_page => 15)
    end
  end

def search_alums 
  if @alum = Alum.all.find{|alum| alum.name.include?(params[:search])} 
    @alums = Alum.where("name LIKE ?", "%#{params[:search]}%")
  else
    # render html: "<script>alert('No users!')</script>".html_safe
    @alums = Alum.all
    redirect_to "/alums"
    flash[:notice] = "No Alumni Found."

  end 
end


  # GET /alums/1 or /alums/1.json
  def show
  end

  # GET /alums/new
  def new
    @alum = Alum.new
  end

  # GET /alums/1/edit
  def edit
  end

  # POST /alums or /alums.json
  def create
    @alum = Alum.new(alum_params)

    respond_to do |format|
      if @alum.save
        format.html { redirect_to alum_url(@alum), notice: "Alum was successfully created." }
        format.json { render :show, status: :created, location: @alum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @alum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alums/1 or /alums/1.json
  def update
    respond_to do |format|
      if @alum.update(alum_params)
        format.html { redirect_to alum_url(@alum), notice: "Alum was successfully updated." }
        format.json { render :show, status: :ok, location: @alum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @alum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alums/1 or /alums/1.json
  def destroy
    @alum.destroy

    respond_to do |format|
      format.html { redirect_to alums_url, notice: "Alum was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alum
      @alum = Alum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def alum_params
      params.require(:alum).permit(:name, :email, :degree, :divsion)
    end
end
