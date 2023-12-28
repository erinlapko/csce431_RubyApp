class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ show edit update destroy ]

  # GET /attendances or /attendances.json
  def index
    if params[:sort]
      @attendances = Attendance.order(params[:sort])
    elsif not(params[:search_name].blank?)
        @attendances = search_att_name
    elsif not(params[:search_title].blank?)
      @attendances = search_att_title
    else
      @attendances = Attendance.paginate(:page => params[:page], :per_page => 15)
    end
  end

  def search_att_name
    if @attendances = Attendance.all.find{|attendance| Member.where(id: attendance.member_id).last.name.eql?(params[:search_name])} 
      # redirect_to member_path( @member )
      @attendeances = Attendance.where("member_id = ?", Member.where("name = ?","#{params[:search_name]}").last.id.to_s)
    else
      # render html: "<script>alert('No users!')</script>".html_safe
      @attandances = Attendance.all
      redirect_to "/attendances"
      flash[:notice] = "No Record Found."
  
    end 
  end

  def search_att_title
    if @attendances = Attendance.all.find{|attendance| Meeting.where(id: attendance.meeting_id).last.title.eql?(params[:search_title])} 
      # redirect_to member_path( @member )
      @attendeances = Attendance.where("meeting_id =?", Meeting.where("title LIKE ?","#{params[:search_title]}").last.id)
    else
      # render html: "<script>alert('No users!')</script>".html_safe
      @attandances = Attendance.all
      redirect_to "/attendances"
      flash[:notice] = "No Record Found."
  
  
    end 
  end

  # GET /attendances/1 or /attendances/1.json
  def show
  end

  # GET /attendances/new
  def new
    @attendance = Attendance.new
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances or /attendances.json
  def create
    @attendance = Attendance.new(attendance_params)

    respond_to do |format|
      if @attendance.save
        meetingId = @attendance.meeting_id
        memberId = @attendance.member_id
        meetingPoint = Meeting.where("id =?", meetingId).last.points
        memberPoint = Member.where("id =?", memberId).last.points
        currPoint = meetingPoint + memberPoint

        Member.where("id =?", memberId).update(points:"#{currPoint}")
        format.html { redirect_to attendance_url(@attendance), notice: "Attendance was successfully created." }
        format.json { render :show, status: :created, location: @attendance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendances/1 or /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to attendance_url(@attendance), notice: "Attendance was successfully updated." }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1 or /attendances/1.json
  def destroy
        meetingId = @attendance.meeting_id
        memberId = @attendance.member_id
        meetingPoint = Meeting.where("id =?", meetingId).last.points
        memberPoint = Member.where("id =?", memberId).last.points
        currPoint = memberPoint - meetingPoint

        Member.where("id =?", memberId).update(points:"#{currPoint}")
    @attendance.destroy

    respond_to do |format|
      format.html { redirect_to attendances_url, notice: "Attendance was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attendance_params
      params.require(:attendance).permit(:meeting_id, :member_id, :att_time)
    end
end
