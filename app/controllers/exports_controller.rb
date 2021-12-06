class ExportsController < ApplicationController
  load_and_authorize_resource
  before_action :set_professionals
  # GET /exports/new
  def new
    @export = Export.new
  end

  # POST /exports
  def create
    @export = Export.new
    @export.date = Date.parse(export_params["date"]) if export_params["date"].present?
    @export.type = export_params["type"].to_sym if export_params["type"].present?
    if export_params["professional"].blank?
      @export.professional = nil
    else
      @export.professional = Professional.find(export_params["professional"])
    end
    if @export.valid?
      pdf = ExportPdf.new(date: @export.date, professional: @export.professional, type: @export.type)
      send_data(pdf.render, filename:
          "Appointments_for_#{@export.type}_#{@export.date.strftime("%d/%m/%Y")}.pdf",
                            type: "application/pdf", status: "200 OK")
    else
      render :new, alert: 'Could not export file.'
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
