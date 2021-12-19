class AppointmentsController < ApplicationController
  load_and_authorize_resource :professional
  load_and_authorize_resource :appointment, through: :professional

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

  def cancel
    @professional.cancel_appointments_physical
    redirect_to professionals_url, notice: 'All appointments were successfully destroyed.'
  end

  private

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:name, :surname, :phone, :notes, :date, :time, :active)
  end
end
