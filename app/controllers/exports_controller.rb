class ExportsController < ApplicationController
    load_and_authorize_resource
    before_action :set_professionals
  # GET /exports/new
  def new
    @export = Export.new
  end

  # POST /exports
  def create
    @export = Export.new(export_params)
    if @export.valid?
        if !@export.professional.blank?
            @professional = Professional.find(@export.professional)
        end 
        @date = Date.parse(@export.date)
        pdf = ExportPdf.new(date: @date, professional: @professional, type: @export.type )
        send_data pdf.render, filename: 
            "export_appointments_for_#{@date.strftime("%d/%m/%Y")}.pdf",
            type: "application/pdf"
    else
        render :new, alert: @export.errors.messages, status: :unprocessable_entity
    end
  end


  private
  def set_professionals
    @professionals = Professional.all.order(:surname)
  end 
    # Only allow a list of trusted parameters through.
    def export_params
      params.require(:export).permit(:professional, :date, :type)
    end
end
