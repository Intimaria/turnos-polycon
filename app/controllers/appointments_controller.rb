class AppointmentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_professional
  # before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments
  def index
    @appointments = @professional.valid_appointments.order_by_latest_first.order(:date)
  end

  # GET /appointments/1
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments
  def create
    @appointment = @professional.appointments.new(appointment_params)

    if @appointment.save
      redirect_to [@professional, @appointment], notice: 'Appointment was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /appointments/1
  def update
    if @appointment.update(appointment_params)
      redirect_to [@professional, @appointment], notice: 'Appointment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /appointments/1
  def destroy
    @appointment.destroy
    redirect_to professional_appointments_url, notice: 'Appointment was successfully destroyed.'
  end

  private
    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:name, :surname, :phone, :notes, :date, :time, :active)
    end

      # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:professional_id])
    end

end
