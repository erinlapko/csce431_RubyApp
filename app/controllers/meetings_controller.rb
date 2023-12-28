class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[ show edit update destroy ]

  # GET /meetings or /meetings.json
  def index
    if params[:sort]
      @meetings = Meeting.order(params[:sort])
    elsif params[:search]
      @meetings = search_meetings
    else
      @meetings = Meeting.paginate(:page => params[:page], :per_page => 15)
    end
  end
def search_meetings 
  if @meeting = Meeting.all.find{|meeting| meeting.title.include?(params[:search])} 
    @meetings = Meeting.where("title LIKE ?", "%#{params[:search]}%")
  else
    # render html: "<script>alert('No users!')</script>".html_safe
    @meetings = Meeting.all
    redirect_to "/meetings"
    flash[:notice] = "No Meeting Found."

  end 
end

  # GET /meetings/1 or /meetings/1.json
  def show
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings or /meetings.json
  def create
    @meeting = Meeting.new(meeting_params)

    respond_to do |format|
      if @meeting.save
        format.html { redirect_to meeting_url(@meeting), notice: "Meeting was successfully created." }
        format.json { render :show, status: :created, location: @meeting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meetings/1 or /meetings/1.json
  def update
    respond_to do |format|
      if @meeting.update(meeting_params)
        format.html { redirect_to meeting_url(@meeting), notice: "Meeting was successfully updated." }
        format.json { render :show, status: :ok, location: @meeting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1 or /meetings/1.json
  def destroy
    @meeting.destroy

    respond_to do |format|
      format.html { redirect_to meetings_url, notice: "Meeting was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def meeting_params
      params.require(:meeting).permit(:title, :time, :description, :points)
    end
end
